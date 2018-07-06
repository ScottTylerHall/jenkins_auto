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
				  echo 'Building..'
			}
		}
		stage('Test') {
			steps {
				 echo 'Testing..'
			}
		}
		stage('Deploy') {
			steps {
				 echo 'Deploying..'
			}
		}
	}
	post {
		failure {
			echo 'Unsuccessful'
		}
	}
}