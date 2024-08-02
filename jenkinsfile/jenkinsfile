pipeline {
    agent any
    tools {
        jdk 'jdk11' // Ensure this matches your Jenkins JDK installation name
        nodejs 'nodejs' // Ensure this matches your Jenkins NodeJS installation name
    }
    environment {
        SONAR_URL = 'http://15.157.62.185:9000/' // Your SonarQube server URL
        SONAR_AUTH_TOKEN = credentials('sonarqube-token') // SonarQube authentication token ID in Jenkins credentials
        SCANNER_HOME = '/opt/sonar-scanner' // Path to your Sonar Scanner installation
    }
    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout from Git') {
            steps {
                git branch: 'master', url: 'https://github.com/SHYAM-PALAKURTHI/2048_React_K8S.git'
            }
        }
        stage('Print Environment Variables') {
            steps {
                sh 'printenv | sort'
            }
        }
        stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') { // Ensure 'sonar-server' is the correct SonarQube server name configured in Jenkins
                    withEnv(["JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.24.8.1", "PATH=${env.JAVA_HOME}/bin:${SCANNER_HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"]) {
                        sh '''
                            echo "JAVA_HOME: $JAVA_HOME"
                            echo "PATH: $PATH"
                            if [ -x "$(command -v sonar-scanner)" ]; then
                                sonar-scanner \
                                    -Dsonar.projectKey=2048-game \
                                    -Dsonar.sources=. \
                                    -Dsonar.host.url=${SONAR_URL} \
                                    -Dsonar.login=${SONAR_AUTH_TOKEN} \
                                    -Dsonar.projectName=2048-game
                            else
                                echo "Sonar Scanner is not installed or not found in PATH."
                                exit 1
                            fi
                        '''
                    }
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'ls -lart'
                sh 'npm install'
            }
        }
        stage('Build and Push Docker Image') {
            environment {
                DOCKER_IMAGE = "palakuws/2048game:${BUILD_NUMBER}"
                REGISTRY_CREDENTIALS = credentials('dockerhub_id') // Docker Hub credentials ID in Jenkins credentials
            }
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                    def dockerImage = docker.image("${DOCKER_IMAGE}")
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_id') {
                        dockerImage.push()
                    }
                }
            }
        }
    }
    post {
        failure {
            echo "Pipeline failed, cleaning up workspace."
            cleanWs()
        }
    }
}
