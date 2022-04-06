pipeline {
  agent any

  stages {
    stage('clone project from GitHub'){
      steps {
        git branch: 'main',
        url: 'https://github.com/k-surabhi/spartan_project_mongodb.git'
      }
    }

    stages('Build Docker Image') {
      steps {
        script {
          docker.build 'ksurabhi7/rest_mongo'
        }
      }
    }
  }
}
