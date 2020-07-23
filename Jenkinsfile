def serviceAddress = ""

pipeline {
  agent any

  environment {
    dockerhubCredentials = 'dockerhubCredentials'
  }

  stages {

    stage('Lint with pylint and hadolint') {
        steps {
            sh 'hadolint Dockerfile'
        }
    }

    stage('Build docker') {
        steps {
            script {
                app = docker.build("aanorbel/ud-nd9991-capstone")
            }
        }
    }

    stage('Scan image with Aqua') {
        steps {
            aquaMicroscanner(imageName: 'aanorbel/ud-nd9991-capstone', notCompliesCmd: 'exit 4', onDisallowed: 'ignore', outputFormat: 'html')
        }
    }

    stage('Publish docker to Dockerhub') {
        steps {
            script {
                docker.withRegistry('', dockerhubCredentials) {
                    app.push("${env.GIT_COMMIT}")
                    app.push("latest")
                }
            }
        }
    }

    stage('Deploy to Kubernetes (EKS Cluster)') {
        steps {
            retry(3) {
                withAWS(credentials: 'aws-credentials-udacity', region: 'us-west-2') {
                    sh 'echo "Setup Kubernetes Cluster"'
                    sh "aws eks --region us-west-2 update-kubeconfig --name UdacityFinalProject-EKS-CLUSTER"
                    sh 'echo "Deploying to Kubernetes"'
                    sh 'sed -ie "s/latest/${GIT_COMMIT}/g" kubernetes/deployment.yml'
                    sh "kubectl apply -f kubernetes/deployment.yml"
                    sh 'echo "Showing the result of deployment"'
                    sh "kubectl get svc"
                    sh "kubectl get pods -o wide"
                    script{
                        serviceAddress = sh(script: "kubectl get svc --output=json | jq -r '.items[0] | .status.loadBalancer.ingress[0].hostname'", returnStdout: true).trim()
                    }
                    sh "echo 'Deployment Complete!'"
				    sh "echo 'View Page Here (Please Allow a Minute for Services to Refresh): http://$serviceAddress:8000'"
                }
            }
        }
    }
    stage("Cleaning up") {
        steps {
            sh 'echo "Cleaning up..."'
            sh "docker system prune -f"
        }
    }
  }
}