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
        mail to: 'scotthall349@gmail.com',
        subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
        body: "Something is wrong with ${env.BUILD_URL}"
      }
    }
  }
}