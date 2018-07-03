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
	post {
		failure {
			slackSend 'Unsuccessful'
		}
	}
}