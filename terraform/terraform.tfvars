# Name of the namespaces
app_namespace        = "app"
monitoring_namespace = "monitoring"

# environment label for namespaces and resources
environment = "dev"

# Grafana admin password is on the secrets of the pipeline, so we can avoid hardcoding it here. 
#(grafana_admin_password) 
grafana_admin_password = "admin123"