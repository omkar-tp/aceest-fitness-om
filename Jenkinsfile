pipeline {
    agent any

    options {
        disableConcurrentBuilds()
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

        stage('Build (compile check)') {
            steps {
                sh '''
                    . venv/bin/activate
                    python -m py_compile app.py
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
    }

    post {
        success {
            echo 'BUILD SUCCEEDED: Quality gate passed.'
        }
        failure {
            echo 'BUILD FAILED: Check the logs above.'
        }
        always {
            deleteDir()
        }
    }
}
