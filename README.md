# 🚀 GCP Jenkins Kubernetes CI/CD Platform

End-to-end **DevOps CI/CD platform** built on **Google Cloud Platform** using:

* Terraform (Infrastructure as Code)
* Google Kubernetes Engine (GKE)
* Jenkins (installed via Helm)
* Artifact Registry
* Kaniko (container image build)
* GitHub Webhooks
* Workload Identity (secure GCP authentication)
* Prometheus metrics & Cloud Monitoring

The project demonstrates a **production-style CI/CD pipeline** deploying a containerized Python application to Kubernetes.

---

# 📐 Architecture

```
                +------------------+
                |      GitHub      |
                |  Source Control  |
                +---------+--------+
                          |
                          | Push
                          |
                    GitHub Webhook
                          |
                          ▼
                 +----------------+
                 |     Jenkins    |
                 | (running in    |
                 |      GKE)      |
                 +--------+-------+
                          |
                          | Build Pipeline
                          |
                          ▼
                +------------------+
                |      Kaniko      |
                | Docker Build     |
                +--------+---------+
                         |
                         | Push Image
                         ▼
             +--------------------------+
             |   Artifact Registry      |
             |  Docker Image Storage    |
             +------------+-------------+
                          |
                          | Deploy
                          ▼
                +----------------------+
                |  Google Kubernetes   |
                |     Engine (GKE)     |
                +-----------+----------+
                            |
                            ▼
                      Flask Application
                            |
                            ▼
                        /metrics
                            |
                            ▼
                   Cloud Monitoring
```

---

# 🧰 Technology Stack

| Component          | Technology                            |
| ------------------ | ------------------------------------- |
| Infrastructure     | Terraform                             |
| Container Platform | Google Kubernetes Engine              |
| CI/CD              | Jenkins                               |
| Image Build        | Kaniko                                |
| Container Registry | Artifact Registry                     |
| Authentication     | Workload Identity                     |
| Source Control     | GitHub                                |
| Monitoring         | Prometheus metrics + Cloud Monitoring |
| Application        | Python Flask                          |

---

# 📂 Repository Structure

```
GCP-Jenkins-Terraform
│
├── apps
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
│
├── jenkins
│   ├── values.yaml
│   └── jenkins-rbac.yaml
│
├── k8s
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── podmonitoring.yaml
│
├── terraform
│   ├── modules
│   │   ├── network
│   │   ├── iam
│   │   ├── gke
│   │   └── artifact_registry
│   │
│   └── environments
│       └── dev
│           ├── main.tf
│           ├── variables.tf
│           ├── terraform.tfvars
│           └── outputs.tf
│
└── Jenkinsfile
```

---

# ⚙️ Infrastructure (Terraform)

Terraform provisions:

* VPC Network
* Subnet
* Artifact Registry repository
* GKE Cluster
* Node Pool
* Service Accounts
* IAM Roles
* Workload Identity configuration

Deploy infrastructure:

```
cd terraform/environments/dev

terraform init
terraform plan
terraform apply
```

---

# ☸️ Jenkins Installation

Jenkins is installed on the Kubernetes cluster using **Helm**.

Add Helm repo:

```
helm repo add jenkins https://charts.jenkins.io
helm repo update
```

Install Jenkins:

```
helm install jenkins jenkins/jenkins \
  -n jenkins \
  -f jenkins/values.yaml
```

---

# 🔐 Workload Identity

Instead of using service account keys, the project uses **Workload Identity**.

Mapping:

```
Kubernetes Service Account
jenkins (namespace: jenkins)
        ↓
Google Service Account
jenkins-gsa
```

This allows Jenkins agents to authenticate to Google Cloud securely without storing credentials.

IAM binding example:

```
roles/iam.workloadIdentityUser
```

---

# 🔁 CI/CD Pipeline

The pipeline is defined in `Jenkinsfile`.

Pipeline stages:

```
1️⃣ Checkout code from GitHub

2️⃣ Build container image
   - Kaniko builds Docker image

3️⃣ Push image
   - Artifact Registry

4️⃣ Deploy to Kubernetes
   - kubectl apply
   - rolling update

5️⃣ Verify deployment
   - kubectl rollout status
```

---

# 🐳 Container Build (Kaniko)

Kaniko builds container images directly inside Kubernetes without requiring Docker.

Example build command used in pipeline:

```
/kaniko/executor \
  --context=${WORKSPACE}/apps \
  --dockerfile=${WORKSPACE}/apps/Dockerfile \
  --destination=${IMAGE}
```

---

# 🚀 Deployment

Application is deployed using Kubernetes manifests:

```
k8s/deployment.yaml
k8s/service.yaml
```

Deployment strategy:

```
Rolling Update
```

Image update example:

```
kubectl set image deployment/hello-app \
hello-app=${IMAGE}
```

---

# 📊 Monitoring

Application exposes Prometheus metrics.

Endpoint:

```
/metrics
```

Example metric:

```
hello_app_requests_total
```

Metrics are scraped by **Managed Prometheus on GKE** using:

```
PodMonitoring
```

Example configuration:

```
apiVersion: monitoring.googleapis.com/v1
kind: PodMonitoring
```

Metrics can be visualized in:

```
Google Cloud Monitoring
```

---

# 🧪 Testing the Application

After deployment:

```
kubectl get svc -n demo
```

Access application via LoadBalancer IP.

Test:

```
/health
/metrics
```

---

# 🔄 CI/CD Flow

```
Developer pushes code
        ↓
GitHub Webhook
        ↓
Jenkins Pipeline
        ↓
Kaniko builds image
        ↓
Push to Artifact Registry
        ↓
Kubernetes deployment update
        ↓
Application rollout
        ↓
Metrics exposed
        ↓
Cloud Monitoring
```

---

# 🛡 Security

Security best practices used:

* Workload Identity (no service account keys)
* RBAC for Jenkins
* Minimal IAM permissions
* Namespace isolation

---

# 📈 Future Improvements

Potential enhancements:

* Helm-based application deployment
* GitOps with ArgoCD
* Grafana dashboards
* Horizontal Pod Autoscaler
* Canary deployments
* Tracing with OpenTelemetry

---

# 📜 License

MIT License

---

# 👨‍💻 Author

DevOps portfolio project demonstrating:

* Kubernetes
* Terraform
* Jenkins
* CI/CD pipelines
* Google Cloud Platform

# 🧠 What I Learned

Building this project helped me understand how a real-world DevOps platform works end-to-end. Below are the most important concepts and lessons learned during development.

## Infrastructure as Code

Using **Terraform** allowed me to provision the entire cloud infrastructure in a reproducible and automated way.

Key learnings:

* Designing modular Terraform architecture
* Managing environments (`dev`)
* Using remote state and outputs
* Understanding dependencies between infrastructure components
* Avoiding manual infrastructure changes

This helped me understand how production infrastructure should be versioned and managed.

---

## Kubernetes Architecture

Working with **Google Kubernetes Engine** helped me understand how container orchestration works in practice.

Key learnings:

* Deploying applications with `Deployment` and `Service`
* Understanding Kubernetes networking and services
* Rolling updates and zero-downtime deployments
* Namespace isolation
* Pod scheduling and container lifecycle

I also learned how Kubernetes resources interact with each other during deployments.

---

## CI/CD Pipelines

Implementing the **Jenkins pipeline** helped me understand how automated delivery pipelines operate.

Key learnings:

* Pipeline as code (`Jenkinsfile`)
* Multi-stage pipelines
* Dynamic Kubernetes build agents
* Automating build → push → deploy workflows
* Triggering pipelines using GitHub webhooks

This demonstrated how a complete CI/CD pipeline can automate application delivery.

---

## Container Image Builds

Using **Kaniko** instead of Docker daemon taught me how container images can be built inside Kubernetes securely.

Key learnings:

* Building Docker images without privileged containers
* Understanding container image layers
* Optimizing build contexts
* Pushing images to Artifact Registry

---

## Secure Authentication in Kubernetes

One of the most important lessons was implementing **Workload Identity**.

Instead of using static service account keys:

```text
Kubernetes Service Account → Google Service Account
```

This allows secure authentication to Google Cloud services.

Key learnings:

* Mapping Kubernetes Service Accounts to Google Service Accounts
* IAM roles and permissions
* Eliminating credential secrets from the cluster

This is considered a **best practice for production systems**.

---

## Observability and Monitoring

Adding Prometheus metrics helped me understand how application monitoring works.

Key learnings:

* Exposing application metrics via `/metrics`
* Using Prometheus metric types (Counter, Gauge)
* Scraping metrics with `PodMonitoring`
* Integrating with Google Cloud Monitoring

This showed how systems collect telemetry data to monitor application health.

---

## Troubleshooting and Debugging

During development I encountered multiple real-world issues, such as:

* RBAC permission errors
* authentication failures with Artifact Registry
* Kubernetes service account misconfigurations
* CI pipeline failures

Resolving these issues helped me build stronger debugging and problem-solving skills.

---

## End-to-End DevOps Platform

This project helped me understand how different technologies integrate together:

```text
GitHub
↓
Webhook
↓
Jenkins CI/CD
↓
Kaniko build
↓
Artifact Registry
↓
Kubernetes Deployment
↓
Application Metrics
↓
Cloud Monitoring
```

Seeing the entire pipeline working together was one of the most valuable learning experiences.

---

## Key Takeaway

This project demonstrated how modern DevOps practices combine:

* Infrastructure as Code
* Container orchestration
* CI/CD automation
* Secure cloud authentication
* Observability and monitoring

Building the full pipeline from scratch gave me a much deeper understanding of how cloud-native systems are designed and operated in real environments.

