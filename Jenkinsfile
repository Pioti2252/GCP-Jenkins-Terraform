pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: jenkins-kaniko-agent
spec:
  serviceAccountName: jenkins
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:debug
      command:
        - /busybox/cat
      tty: true
      volumeMounts:
        - name: kaniko-secret
          mountPath: /kaniko/.docker
    - name: kubectl
      image: bitnami/kubectl:latest
      command:
        - cat
      tty: true
  volumes:
    - name: kaniko-secret
      secret:
        secretName: kaniko-secret
"""
    }
  }

  environment {
    PROJECT_ID = "first-jenkins-488416"
    REGION     = "europe-west1"
    REPO       = "demo-repo"
    APP_NAME   = "hello-app"
    IMAGE      = "${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/${APP_NAME}:${BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build and Push') {
      steps {
        container('kaniko') {
          sh '''
            /kaniko/executor \
              --dockerfile=${WORKSPACE}/apps/hello-app/Dockerfile \
              --context=${WORKSPACE}/apps/hello-app \
              --destination=${IMAGE} \
              --verbosity=info
          '''
        }
      }
    }

    stage('Deploy') {
      steps {
        container('kubectl') {
          sh '''
            kubectl apply -f k8s/namespace.yaml
            kubectl apply -f k8s/service.yaml
            kubectl apply -f k8s/deployment.yaml
            kubectl -n demo set image deployment/hello-app hello-app=${IMAGE}
            kubectl rollout status deployment/hello-app -n demo
          '''
        }
      }
    }
  }
}