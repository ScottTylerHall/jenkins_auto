pipeline {
  agent any
  stages {
    stage('Compile') {
      steps {
        sh 'make'
      }
    }
    stage('Deploy') {
      steps {
        sh 'make run'
        slackSend 'Compiled and Deployed'
      }
    }
  }
}