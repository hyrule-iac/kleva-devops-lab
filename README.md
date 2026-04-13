# 🚀 Kleva DevSecOps Lab: High-Availability Reference Architecture
**By Eng Aldo Raul Sanchez Estrada**

[![Build Status](https://img.shields.io/badge/CI/CD-GitHub%20Actions-blue)](https://github.com/your-repo)
[![Security: Snyk](https://img.shields.io/badge/Security-Snyk%20Passed-green)](https://snyk.io)
[![IaC: Terraform](https://img.shields.io/badge/IaC-Terraform%20HCP-blueviolet)](https://www.terraform.io/)

## 📖 Overview
This repository serves as a **DevSecOps Reference Architecture**. 
It demonstrates a fully automated, secure, and observable lifecycle for a .NET 10 Cloud-Native application. 
The project goes beyond simple deployment, implementing **Blue-Green strategies**, **Shift-Left security**, and **Remote State management** using industry-standard tooling.

---

## 🏗️ Technical Stack & Architecture
* **Application:** .NET 10 Minimal API (High-performance, container-ready).
* **Infrastructure as Code (IaC):** **Terraform** managed via **HCP (HashiCorp Cloud Platform)** for remote state and environment segregation.
* **Orchestration:** **Kubernetes (k3d/k3s)** for local production-parity and mimic on k8s productive environments.
* **CI/CD Engine:** **GitHub Actions** with YAML-first pipelines.
* **Observability Stack:** **Prometheus** (Metrics collection) + **Grafana** (Advanced visualization).
* **Security (Shift-Left): 
    * **Snyk:** SCA (Software Composition Analysis).
    * **SonarCloud:** Static Code Analysis & Quality Gates.
    * **CodeQL:** Semantic code analysis.

---

## 📂 Project Structure
```bash
kleva-devops-lab/
├── .github/
│   └── workflows/
│       ├── ci-cd.yml
│       ├── codeql.yml
│       └── deploy.yml
│
├── app/
│   ├── Dockerfile
│   ├── kleva-app.csproj
│   └── Program.cs
│
├── infra/
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
│
├── k8s/
│   ├── configmap.yaml
│   ├── deployment.yaml
│   ├── namespace.yaml
│   ├── secret.yaml
│   ├── service.yaml
│   └── monitoring/
│       ├── grafana-datasources.yaml
│       ├── grafana.yaml
│       └── prometheus.yaml
│
├── .gitattributes
├── .gitignore
├── README.md
└── minikube-installer.exe
```

---

## 🛠️ Deployment & Automation

### 1. Infrastructure (IaC)
Infrastructure is provisioned via Terraform. We utilize **HCP Terraform** to ensure state consistency and team collaboration.
```bash
cd terraform/
terraform init
terraform apply -auto-approve
```

### 2. The DevSecOps Pipeline
The CI/CD pipeline is designed with **Automated Quality Gates**. A deployment only proceeds if all security and unit tests pass.

* **Build Stage:** Compiles .NET code and executes unit tests.
* **Security Stage:** Runs Snyk and SonarCloud. High-severity vulnerabilities trigger an automatic **Pipeline Break**.
* **Package Stage:** Builds a multi-stage Docker image and pushes it to **GHCR/ACR**.
* **Deploy Stage:** Executes a **Rolling Update** or **Blue-Green** deployment to the Kubernetes cluster.

---

## 📊 Observability & Reliability
The application exposes a `/metrics` endpoint compatible with Prometheus.
* **Auto-Discovery:** K8s Service Discovery is configured via annotations.
* **Reliability:** Implemented **Liveness and Readiness probes** to ensure the Load Balancer only routes traffic to healthy pods.
* **Visuals:** Custom Grafana dashboards monitor **Request Rate, Error Rate, and Duration (RED pattern)**.

---

## 🎯 Future Roadmap (Phase 4)
* [ ] **Helm Charts:** Refactor manifests into versioned Helm packages.
* [ ] **GitOps:** Implement **ArgoCD** for declarative continuous delivery and drift detection.
* [ ] **Service Mesh:** Integrate **Istio** for mTLS and advanced traffic shaping.
* [ ] **FinOps:** Integration of cost-estimation tools in the IaC pipeline.

---

## 👨‍💻 Author
**Aldo Raul Sanchez Estrada** *Senior Systems & Cloud Engineer* *Specialist in Automation, IaC, and Scalable Architectures.*