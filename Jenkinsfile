pipeline {
  agent any


  environment {
    IMAGE_NAME = "ksurabhi7/rest_mongo:1." + "$BUILD_NUMBER"
    DOCKER_CREDENTIALS = 'docker_hub_crec'

  }

  stages {
    stage('Cloning the project from GitHub'){
      steps {
        checkout([
            $class: 'GitSCM', branches: [[name: '*/main']],
            serRemoteConfigs: [[
              url: 'git@github.com:oabu-sg/rest_mongo.git',
              credentialsId: 'ssh_git_cred'
            ]]
          ])
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          DOCKER_IMAGE = docker.build IMAGE_NAME
        }
      }
    }

    stage('Testing the Code'){
      steps{
        script {
         sh '''
          docker run --rm -v $PWD/test-results:/reports --workdir /app $IMAGE_NAME python -m pytest -v --junitxml=/reports/results.xml
          ls $PWD/test-results
        '''
       }
      }

      post {
       always {
        junit testResults: '**/test-results/*.xml'
       }
     }
    }

    stage('push to docker hub'){
      steps {
        script {
          docker.withRegistry('', DOCKER_CREDENTIALS){
            DOCKER_IMAGE.push()
          }
        }
      }
    }
    stage('Removing the Docker Image'){
      steps {
        sh "docker rmi $IMAGE_NAME"
      }
    }
  }
}
