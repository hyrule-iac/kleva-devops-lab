
# Nombres de los namespaces
app_namespace        = "app"
monitoring_namespace = "monitoring"

# Configuración de ambiente
environment = "dev"

# NOTE: Grafana password must be passed over a variable (grafana_admin_password) 
# NO la pongas aquí si vas a subir este archivo a Git.
# Es mejor pasarla como secreto en el pipeline o dejar que use el default.