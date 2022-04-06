pipeline {
  agent any


  environment {
    IMAGE_NAME = "ksurabhi7/rest_mongo:1." + "$BUILD_NUMBER"

  }

  stages {
    stage('clone project from GitHub'){
      steps {
        git branch: 'main',
        url: 'https://github.com/k-surabhi/spartan_project_mongodb.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          DOCKER_IMAGE = docker.build IMAGE_NAME
        }
      }
    }

    stage('push to docker hub'){
      steps {
        script {
          docker.withRegistry('', 'docker_hub_crec'){
            DOCKER_IMAGE.push()
          }
        }
      }
    }
  }
}
