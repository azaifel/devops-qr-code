pipeline {
  agent any

  environment {
    REGISTRY_CREDENTIALS = 'dockerhub-creds'
    BACKEND_IMAGE = 'azaifel/qr-backend'
    FRONTEND_IMAGE = 'azaifel/qr-frontend'
    IMAGE_TAG = 'latest'
  }

  stages {
    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Build & Push Backend Image') {
      steps {
        dir('api') {
          script {
            sh "docker build -t $BACKEND_IMAGE:$IMAGE_TAG ."
          }
        }
        withCredentials([usernamePassword(
          credentialsId: env.REGISTRY_CREDENTIALS,
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          script {
            sh """
              echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
              docker push $BACKEND_IMAGE:$IMAGE_TAG
            """
          }
        }
      }
    }

    stage('Build & Push Frontend Image') {
      steps {
        dir('front-end-nextjs') {
          script {
            sh "docker build -t $FRONTEND_IMAGE:$IMAGE_TAG ."
          }
        }
        withCredentials([usernamePassword(
          credentialsId: env.REGISTRY_CREDENTIALS,
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          script {
            sh """
              echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
              docker push $FRONTEND_IMAGE:$IMAGE_TAG
            """
          }
        }
      }
    }
  }
}
