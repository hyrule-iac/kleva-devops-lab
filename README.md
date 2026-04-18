![CI](https://github.com/hyrule-iac/kleva-devops-lab/actions/workflows/CI.yml/badge.svg)
![CodeQL](https://github.com/hyrule-iac/kleva-devops-lab/actions/workflows/codeql.yml/badge.svg)

# 🚀 Kleva DevOps Lab: Cloud-Native Microservices Platform
A high-availability, observable microservices architecture built on **.NET Core**, orchestrated by **Kubernetes (k3d)**, and managed through **HashiCorp Terraform (IaC)**.
This is a cloud and GitOps-driven platform designed for rapid development, deployment, and monitoring of microservices in a scalable environment.

## 🏛 Architecture Overview
The platform follows a modular design pattern, separating infrastructure concerns from application logic.

### 1. Infrastructure as Code (IaC)
Managed via **HCP Terraform (Cloud)** using a **CLI-driven workflow**.
* **Provider Layer:** Defines `kubernetes` and `helm` providers to bridge the gap between cloud state and local execution.
* **State Management:** Remote backend ensures team collaboration and state locking.
* **Resource Orchestration:** Automated creation of `app` and `monitoring` namespaces and Grafana deployment via Helm.

### 2. Kubernetes Manifests Logic
Our manifests are organized by responsibility to ensure a clean **GitOps** flow:

* **`k8s/namespace.yaml`**: Standardizes the logical isolation.
* **`k8s/deployment.yaml`**: Handles the .NET Core lifecycle, resource limits (CPU/Memory), and rolling update strategies.
* **`k8s/service.yaml`**: Exposes the application internally.
* **`k8s/grafana-config.yaml`**: Implements a **Sidecar Pattern**.By using labeled `ConfigMaps`, we dynamically inject Prometheus Datasources and JSON Dashboards 
                                 into Grafana without restarting the pod.

## 🛠 CI/CD Pipeline Flow
The automation is split into two specialized workflows:

1.  **Continuous Integration (CI):** * Triggered on every Push/PR.
    * Executes `dotnet build` and `unit tests`.
    * **Static Analysis:** Integrated with **SonarCloud** (using `sonar-project.properties`) to enforce a Quality Gate.
    * **Security:** **Snyk** scans for vulnerabilities in both code and the `Dockerfile`.

2.  **Continuous Deployment (CD):**
    * Triggered only upon successful completion of the CI pipeline on the `master` branch.
    * **IaC Execution:** Runs `terraform apply` to ensure the environment is ready.
    * **Stateful Deployment:** Uses `kubectl apply` for application manifests, ensuring the latest Docker image is running in the `app` namespace.

## 📊 Observability Stack
The platform implements a full monitoring loop:
* **Prometheus:** Scrapes metrics from the .NET application.
* **Grafana:** Visualizes performance data. 
* **Accessing the Dashboards:**
    ```bash
    # Port-forward to access Grafana locally
    kubectl port-forward svc/grafana -n monitoring 3000:80
    ```

## 🛡 Security & Quality
* **Project Key:** `hyrule-iac_kleva-devops-lab`
* **Quality Gate:** Code coverage and security hotspots are monitored via SonarCloud.
* **Secrets Management:** Sensitive data (like `grafana_admin_password`) is injected at runtime via GitHub Secrets and HCP Terraform variables, never hardcoded.