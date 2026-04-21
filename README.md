# 🚀 Kleva DevOps Lab

This repository contains the complete infrastructure and Continuous Delivery lifecycle for **Kleva**, a Cloud-Native .NET 10 application. The project emulates a real-world production environment using **Pipeline Orchestration**, **Infrastructure as Code (IaC)**, and **Progressive Delivery** strategies.

## 🏗️ System Architecture

The entire ecosystem is deployed ephemerally in each run to ensure immutability and reproducibility.

* **Cluster:** k3d (Kubernetes in Docker) as the local execution environment.
* **IaC:** Terraform with state management in **HCP Terraform**.
* **CI:** GitHub Actions with reusable workflows and centralized orchestration.
* **CD:** Argo Rollouts for advanced deployment strategies (**Canary**).
* **Observability:** Automated Prometheus & Grafana stack.

## 🛡️ DevSecOps: The Quality Pipeline

The pipeline implements a "Shift Left Security" model to ensure code and dependency integrity:

1. **SAST (Static Application Security Testing):** Static code analysis using **CodeQL**.
2. **SCA (Software Composition Analysis):** NuGet dependency scanning via **Snyk** (Severity Threshold: High).
3. **Code Quality:** **SonarCloud** integration for bug detection and code smell analysis.
4. **Container Security:** Automated builds and publishing to **GHCR** (GitHub Container Registry) using authenticated `imagePullSecrets`.

## 🚀 Deployment Strategy (Canary)

Using **Argo Rollouts**, we minimize the "blast radius" of new releases:

* **Canary Analysis:** Traffic is shifted progressively to the new version.
* **Automated Rollback:** If Liveness/Readiness probes fail or Prometheus metrics detect anomalies, the system automatically reverts to the stable version.

## 📊 Observability & Monitoring

The lab includes a pre-configured monitoring stack injected via ConfigMaps:

* **Prometheus:** Auto-discovery of application pods via annotations.
* **Grafana:** Automated dashboard provisioning to visualize **Golden Signals** (Latency, Traffic, Errors, and Saturation).

## 🛠️ Prerequisites

* **HCP Terraform Token:** Configured as `TF_API_TOKEN` in GitHub Secrets.
* **Snyk Token:** Configured as `SNYK_TOKEN`.
* **GitHub Token:** The pipeline uses the built-in `GITHUB_TOKEN` with `packages:write` permissions for GHCR access.

## 📁 Project Structure

```bash
├── .github/workflows/    # Orchestrator & Reusable Workflows
├── app/                  # Kleva Source Code (.NET 10)
├── terraform/            # Infrastructure modules (Namespaces, Helm, RBAC)
├── k8s/
│   ├── application/      # Argo Rollout, Service, and Ingress manifests
│   └── monitoring/       # Prometheus & Grafana configurations
└── README.md
```

***
**Developed by Aldo Raul Sanchez Estrada** *Senior Cloud Engineer | Azure & DevOps Specialist*
***
