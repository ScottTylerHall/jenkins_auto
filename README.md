# jenkins_test

1. Run Jenkins on Docker
---------------------
Mount volume locally on disk
```
docker run --name jenkins -ti -p 8080:8080 -p 50000:50000 -v $PWD/jenkins:/var/jenkins_home:z -v /var/run/docker.sock:/var/run/docker.sock jenkins:latest
```
Mount volume in Jenkins container
```
docker run --name jenkins -ti -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home:z -v /var/run/docker.sock:/var/run/docker.sock jenkins:latest
```
Mounting volume as root user
```
-u root
```
Produces annoying volume permission errors if volume not always run as root.

2. Run Docker in Jenkins (Link Host Docker to Jenkins Container)
---------------------
2.1 Login to the Jenkins container:
```
docker exec -it -u root <docker-container-name> bash
```

2.2 Configure the official Docker apt repositories and install the latest Docker CE binaries:
```
apt-get update && \
apt-get -y install apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" && \
apt-get update && \
apt-get -y install docker-ce
```

2.3 In Jenkins container run:
```
chmod 777 /var/run/docker.sock
```

2.4 Restart container afterwards.

Steps obtained from:
https://getintodevops.com/blog/the-simple-way-to-run-docker-in-docker-for-ci

3. Update Jenkins on Docker
---------------------
3.1 Login to Jenkins container:
```
docker container exec -u 0 -it <docker-container-name> bash
```

3.2 Download the required update (Replace 2.121.1 with the required version):
```
wget http://updates.jenkins-ci.org/download/war/2.121.1/jenkins.war
```

3.3 Move the downloaded file to the correct location:
```
mv ./jenkins.war /usr/share/jenkins
```

3.4 Change permissions on the downloaded file:
```
chmod 777 /usr/share/jenkins/jenkins.war
```

3.5 Exit and restart the container:
```
# exit contaienr (inside container)
exit
# restart container (from your server)
docker container restart jenkins
```

Steps obtained from:
```
https://medium.com/@jimkang/how-to-start-a-new-jenkins-container-and-update-jenkins-with-docker-cf628aa495e9
```

Build Project After Each Commit (Github Webhook)
---------------------
```
https://youtu.be/Z3S2gMBUkBo
```

SCM (Source Control Management) 
---------------------
```
https://jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm
```

EXTRA
View Volume Contents of Docker Container Image
---------------------
Accessing Jenkins home directory
```
docker exec -it -u root <docker-container-name> bash
```
Docker container name retrieved by
```
docker ps -a
```

Accessing the Jenkins Console Log Through Docker Logs
---------------------
View the logs to retrieve the initialAdminPassword.
There is a possibility you may need to access the Jenkins console log, for instance, 
when Unlocking Jenkins as part of the Post-installation setup wizard.
```
docker logs <docker-container-name>
```

General Pipeline Structure
---------------------
Jenkinsfile (Declarative Pipeline)
```
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
                echo 'Deploying....'
            }
        }
    }
}
```

If the Port Never Closed Properly on Restart
---------------------
Stop all the running containers 
```
docker stop $(docker ps -a -q)
```
Stop Docker on your machine & restart it.
