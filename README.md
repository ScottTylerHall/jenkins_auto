# jenkins_test

Disclaimer: Steps 1-3 work perfectly up until 4 where I try to compile a Visual Studio project that is on github, I cannot get the MSBuild executable to work on the .sln to compile the project. Although the tutorial towards the bottom installs Jenkins locally on Windows without Docker and then it works perfectly with the Jenkinsfile to compile the .sln.

1 Run Jenkins on Docker
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

2 Run Docker in Jenkins (Link Host Docker to Jenkins Container)
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

3 Update Jenkins on Docker
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

4 How to use MSBuild with Jenkins on a Linux container?
Currently working on this
Build Project After Each Commit (Github Webhook)
---------------------
```
https://youtu.be/Z3S2gMBUkBo
```

Accessing the Jenkins Console Log Through Docker Logs
---------------------
View the logs to retrieve the initialAdminPassword.
There is a possibility you may need to access the Jenkins console log, for instance, 
when Unlocking Jenkins as part of the Post-installation setup wizard.
```
docker logs <docker-container-name>
```

SCM (Source Control Management) 
---------------------
These steps show how a Jenkinsfile which is saved in the reposirtory can be used for creating a pipeline.
```
https://jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm
```
The general pipeline structure for the pipeline is shown next.

General Pipeline Structure
---------------------
When using a pipleline a Jenkinsfile can be created in the repository by pointing the new job to the Jenkinsfile location in the repository. The Jenkinsfile will contain code of the following format (Groovy Syntax):
Jenkinsfile (Declarative Pipeline). The jenkins website has examples on the meaning of all the stages and steps and what and agent is. The agents can be seen under the build executor status tab when you start up Jenkins.
```
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                bat "\"${tool 'MSBuild'}\" WindowsFormsApp1/WindowsFormsApp1/WindowsFormsApp1.sln"
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
    post { // The post always happend can set different resons for it to occur such as failure, success, etc..
    // more can be found on the jenkins website.
        failure {
            echo 'Unsuccessful'
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


NOTES
---------------------
1 Currently having the problem whereby the Jenkins images are for Linux containers and then I do not know of a way to compile a Visual Studio project with the MSBuild.exe in the Linux container which hosts Jenkins. On Jenkins I installed the MSBuild plugin which allows me to in Manage Jenkins->Configure Global Tools select a MSBuild Compiler. Although after succesfully mounting the windows host MSBuild.exe to the Linux container, I still cannot use the MSBuild.exe as there are dependancy issues.

2 The Next step was to try and create a Windows Image whereby I would pre-install the MSBuild dependancies on the Windows container and install Jenkins on that Image. This should allow me through the MSBuild plugin to link the MSBuild.exe

3 I tried to use these two tutorials in order to combine them and have a Windows container running Jenkins with the MSBuild.exe installed on the container. I attempted to take the Dockerfile used to install Jenkins on the Windows container and then use the other docker file to install the MSBuild.exe on that image.
```
https://blog.alexellis.io/continuous-integration-docker-windows-containers/
https://blog.alexellis.io/3-steps-to-msbuild-with-docker/
```
3.1 First use the first 2 Dockerfile's from this:
 https://blog.alexellis.io/continuous-integration-docker-windows-containers/ 
 tutorial to set up JRE and Jenkins on the Windows image and then using the first Dockerfile from this: https://blog.alexellis.io/3-steps-to-msbuild-with-docker/ 
 tutorial in order to install MSBuild on the image. Then you should have an image that can be run with this command:
 ```
 docker run --name jenkinsci -p 8080:8080 -p 50000:50000 -d jenkins-windows-msbuild:2.130
 ```
4 If this fails (This did fail, for some reason some of the paths could not  be found) Jenkins might have to be installed locally without the use of Docker just so that the MSBuild.exe can be accessed easier through the MSBuild plugin. Lol why is this like this? This can then be done using this tutorial.

Setup Jenkins Without Docker
---------------------
This tutorial works perfectly, although with the downside of not having Jenkins in docker.
```
http://www.andyfrench.info/2015/03/getting-started-with-jenkins-git-and.html
Press the Windows+R keys to open the Run dialog, type services.msc in order to start Jenkins server.
```

Blue Ocean Plugin
---------------------
I suggest that this plugin be used for creating pipelines as it has a very user friendly interface that allows the user to create simple pipelines. Pipelines can also be edited and graphically and STEPS can be added in the various STAGES easily. Blue Ocean will also automatically save a Jenkinsfile to the repository or use an already implemented Jenkinsfile to create a pipeline.

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