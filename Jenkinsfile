pipeline {
    agent any
    environment {
        DOCKER_TAG = "khaledmohamed447/app-test:${env.BUILD_NUMBER ?: 'latest'}"
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://your-repo-url.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t todo-list-app .'
                      echo 'Image build'
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    echo 'Running tests... (implement test scripts if available)'
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    sh '''
                        docker stop todo-list-app || true
                        docker rm todo-list-app || true
                    '''
                    
                    sh 'docker run -d -p 5000:5000 --name todo-list-app todo-list-app'
                    echo 'Container Deploied'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline execution failed.'
        }
    }
}
