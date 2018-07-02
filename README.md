# jenkins_test

Run Jenkins on Docker
---------------------
Mount volume locally
```
docker run --name jenkins -ti -p 8080:8080 -p 50000:50000 -v $PWD/jenkins:/var/jenkins_home:z -v /var/run/docker.sock:/var/run/docker.sock jenkinsci/blueocean:latest
```
Mount volume not locally
```
docker run --name jenkins -ti -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home:z -v /var/run/docker.sock:/var/run/docker.sock jenkins:latest
```
Mounting Volume as Root User
```
-u root
```
Produces annoying volume permission errors if volume not always run as root.

Run Docker in Jenkins (Link Host Docker to Jenkins Container)
---------------------
```
https://getintodevops.com/blog/the-simple-way-to-run-docker-in-docker-for-ci
```
In Jenkins container run:
```
chmod 777 /var/run/docker.sock
```
Restart container afterwards.

Update Jenkins on Docker
---------------------
```
https://medium.com/@jimkang/how-to-start-a-new-jenkins-container-and-update-jenkins-with-docker-cf628aa495e9
```

Build Project After Each Commit
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
        stage('Stage 1') {
            steps {
                echo 'Hello world!' 
            }
        }
    }
}
```

Error starting userland proxy: mkdir 
---------------------
Stop all the running containers 
```
docker stop $(docker ps -a -q)
```
Stop Docker on your machine & restart it.

Github Access Token (jenkins_test repo)
---------------------
c2f4deed7e0ffeb79928f62a13f177349a064f8b
