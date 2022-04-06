pipeline {
  agent any

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
          DOCKER_IMAGE = docker.build 'ksurabhi7/rest_mongo'
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
