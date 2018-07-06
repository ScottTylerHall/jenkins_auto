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
				bash 'make'
			}
		}
		stage('Test') {
			steps {
				bash 'make run'
			}
		}
		stage('Deploy') {
			steps {
				bash 'Completed Successfully'
			}
		}
	}
	post {
		failure {
			bash 'Unsuccessful'
		}
	}
}