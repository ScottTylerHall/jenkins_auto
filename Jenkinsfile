// pipeline {
//   agent any
//   stages {
//     stage('Compile') {
//       steps {
//         sh 'make'
//       }
//     }
//     stage('Deploy') {
//       steps {
//         sh 'make run'
//         slackSend 'Compiled and Deployed'
//       }
//     }
//   }
// }

pipeline {
  agent any
  currentBuild.result = "SUCCESS"

  try{
    stages {
      stage('Build') {
        steps {
          sh 'make'
        }
      }
      stage('Test') {
        steps {
          sh 'make run'
        }
      }
      stage('Deploy') {
        steps {
          slackSend 'Completed Successfully'
        }
      }
    }
  }catch(err) {
    currentBuild.result =  "FAILURE"
    slackSend 'Unsuccessful'
    throw err
  }
}