pipeline {
  agent any

  environment {
    DOCKER_IMAGE = 'azaifel/qr-backend'
    DOCKER_TAG = 'latest'
    REGISTRY_CREDENTIALS = 'dockerhub-creds' // Jenkins credential ID
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        dir('api') {
          script {
            sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
          }
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: env.REGISTRY_CREDENTIALS,
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          script {
            sh '''
              echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
              docker push $DOCKER_IMAGE:$DOCKER_TAG
            '''
          }
        }
      }
    }
  }
}
