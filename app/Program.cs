using Prometheus;
var builder = WebApplication.CreateBuilder(args);

// Register Prometheus metrics as a hosted service
// This enables default .NET runtime metrics: GC, thread pool, memory, etc.
builder.Services.AddMetrics();
var app = builder.Build();
var version = Environment.GetEnvironmentVariable("APP_VERSION") ?? "1.0.0";
var environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Production";
var startTime = DateTime.UtcNow;

// ── Custom Prometheus metrics ─────────────────────────────────────────────────

// Counter: total HTTP requests received, labeled by endpoint and status code
var httpRequestsTotal = Metrics.CreateCounter(
    "kleva_http_requests_total",
    "Total number of HTTP requests received",
    labelNames: new[] { "endpoint", "status_code" }
);

// Histogram: tracks request duration in seconds, useful for latency percentiles
var httpRequestDuration = Metrics.CreateHistogram(
    "kleva_http_request_duration_seconds",
    "HTTP request duration in seconds",
    labelNames: new[] { "endpoint" },
    new HistogramConfiguration
    {
        // Buckets optimized for a fast local API (5ms to 2s)
        Buckets = new[] { 0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.0 }
    }
);

// Gauge: current number of active (in-flight) requests
var activeRequests = Metrics.CreateGauge(
    "kleva_active_requests",
    "Number of requests currently being processed"
);

// Gauge: app uptime in seconds — Grafana can graph this as an uptime counter
var appUptimeSeconds = Metrics.CreateGauge(
    "kleva_uptime_seconds",
    "Application uptime in seconds"
);

// Background thread: updates the uptime gauge every 5 seconds
// Runs as a fire-and-forget task — acceptable for a lab environment
_ = Task.Run(async () =>
{
    while (true)
    {
        appUptimeSeconds.Set((DateTime.UtcNow - startTime).TotalSeconds);
        await Task.Delay(TimeSpan.FromSeconds(5));
    }
});

// ── Middleware: track metrics on every request ────────────────────────────────

// UseHttpMetrics() from prometheus-net automatically tracks:
// - http_requests_in_progress
// - http_requests_received_total
// - http_request_duration_seconds
// Must be registered BEFORE route handlers
app.UseHttpMetrics();

// ── Endpoints ─────────────────────────────────────────────────────────────────

app.MapGet("/", async (HttpContext ctx) =>
{
    var timer = httpRequestDuration.WithLabels("/").NewTimer();
    activeRequests.Inc();

    try
    {
        var uptime = DateTime.UtcNow - startTime;
        var html = $$"""
        <!DOCTYPE html>
        <html lang="es">
        <head>
          <meta charset="UTF-8"/>
          <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
          <title>Kleva DevOps Lab</title>
          <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                   background: #0f172a; color: #e2e8f0; min-height: 100vh;
                   display: flex; align-items: center; justify-content: center; }
            .card { background: #1e293b; border: 1px solid #334155;
                    border-radius: 16px; padding: 48px; max-width: 520px; width: 100%; }
            .badge { display: inline-flex; align-items: center; gap: 6px;
                     background: #052e16; color: #4ade80; border: 1px solid #166534;
                     font-size: 13px; padding: 4px 12px; border-radius: 20px; margin-bottom: 24px; }
            .dot { width: 8px; height: 8px; background: #4ade80;
                   border-radius: 50%; animation: pulse 2s infinite; }
            @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:.4} }
            h1 { font-size: 28px; font-weight: 700; color: #f8fafc; margin-bottom: 8px; }
            .subtitle { color: #94a3b8; font-size: 15px; margin-bottom: 32px; }
            .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 32px; }
            .metric { background: #0f172a; border: 1px solid #334155;
                      border-radius: 10px; padding: 16px; }
            .metric-label { font-size: 12px; color: #64748b; margin-bottom: 4px; }
            .metric-value { font-size: 18px; font-weight: 600; color: #f1f5f9; }
            .footer { font-size: 12px; color: #475569; text-align: center;
                      border-top: 1px solid #334155; padding-top: 20px; }
            a { color: #38bdf8; text-decoration: none; }
          </style>
        </head>
        <body>
          <div class="card">
            <div class="badge"><span class="dot"></span> Sistema operativo</div>
            <h1>Kleva DevOps Lab</h1>
            <p class="subtitle">Infraestructura desplegada con Terraform + GitHub Actions</p>
            <div class="grid">
              <div class="metric">
                <div class="metric-label">Versión</div>
                <div class="metric-value">{{version}}</div>
              </div>
              <div class="metric">
                <div class="metric-label">Ambiente</div>
                <div class="metric-value">{{environment}}</div>
              </div>
              <div class="metric">
                <div class="metric-label">Uptime</div>
                <div class="metric-value">{{uptime.Hours:D2}}h {{uptime.Minutes:D2}}m</div>
              </div>
              <div class="metric">
                <div class="metric-label">Métricas</div>
                <div class="metric-value"><a href="/metrics">/metrics</a></div>
              </div>
            </div>
            <div class="footer">
              Deployed on AWS EC2 · IaC con Terraform · CI/CD via GitHub Actions<br/>
              <a href="/health">/health</a> · <a href="/metrics">/metrics</a>
            </div>
          </div>
        </body>
        </html>
        """;

        httpRequestsTotal.WithLabels("/", "200").Inc();
        ctx.Response.ContentType = "text/html";
        await ctx.Response.WriteAsync(html);
    }
    finally
    {
        // Always decrement active requests and observe duration, even on error
        activeRequests.Dec();
        timer.ObserveDuration();
    }
});

app.MapGet("/health", () =>
{
    httpRequestsTotal.WithLabels("/health", "200").Inc();

    return Results.Ok(new
    {
        status = "healthy",
        timestamp = DateTime.UtcNow,
        version,
        environment,
        uptime = $"{(DateTime.UtcNow - startTime).TotalSeconds:F0}s"
    });
});
// ── Prometheus scrape endpoint ────────────────────────────────────────────────
// MapMetrics() exposes /metrics in the OpenMetrics/Prometheus text format
// Prometheus scrapes this endpoint every 15s as configured in prometheus.yaml
// Do NOT add authentication here for the lab — Prometheus needs open access

app.MapMetrics();
app.Run();