pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        IMAGE_NAME = "aceest-fitness"
        IMAGE_TAG  = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Pulling latest code from GitHub...'
                checkout scm
            }
        }

        stage('Set up Python & Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh '''
                    . venv/bin/activate
                    pytest -v
                '''
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Performing clean Docker build...'
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Test Inside Container') {
            steps {
                sh 'docker run --rm ${IMAGE_NAME}:${IMAGE_TAG} sh -c "pip install --no-cache-dir pytest && pytest -v"'
            }
        }
    }

    post {
        success {
            echo 'BUILD SUCCEEDED: Quality gate passed.'
        }
        failure {
            echo 'BUILD FAILED: Check the logs above.'
        }
        always {
            cleanWs()
        }
    }
}
