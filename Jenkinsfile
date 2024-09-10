pipeline {
    agent any

    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/AbsoluteZero24/login-app.git'
            }
        }

        stage('sonar analsys') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=login-app \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=login-app '''
                }
            }
        }

        stage('Build Image PHP') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerhub-cred', toolName: 'docker') {
                        sh "docker build -t absolutezero24/php-login:v1.3 ./src/"
                    }
                }
            }
        }

        stage('Build Image Nginx') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerhub-cred', toolName: 'docker') {
                        sh "docker build -t absolutezero24/php-nginx-login:v1.1 ."
                    }
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerhub-cred', toolName: 'docker') {
                        sh "docker push absolutezero24/php-login:v1.3"
                    }
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerhub-cred', toolName: 'docker') {
                        sh "docker push absolutezero24/php-nginx-login:v1.1"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'kubernetes-cred', namespace: '', restrictKubeConfigAccess: false, serverUrl: 'https://192.168.100.100:6443') {
                    sh ". deploy.sh"
                    }
                }
            }
        }
    }
}