pipeline {

    agent any

    tools {
	maven 'MAVEN3'
    }

    stages {

	stage('Clean Workspace') {
	   steps {
	   	cleanWs()
	   }
	}

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
              script {
                  bat 'mvn -B -DskipTests clean package'
              }
            }
        }

        stage('Sonar Code Quality Check') {
            steps {
              bat 'mvn sonar:sonar'
            }
        }

        stage('Artifactory Upload') {
            steps {
               script {
                 def server = Artifactory.server 'Artifactory-1'
                 def uploadSpec = """{
                    "files": [{
                       "pattern": "target/vlab-devops-application.war",
                       "target": "vlab-devops/"
                    }]
                 }"""
                 echo "$WORKSPACE"
                 server.upload(uploadSpec)
               }
            }
        }

        stage('Deploy Tomcat') {
            steps {
               script {
                 def server = Artifactory.server 'Artifactory-1'
                 def downloadSpec = """{
                    "files": [{
                       "pattern": "vlab-devops/vlab-devops-application.war",
                       "target": "C:/DevOps-Master/apache-tomcat-8.5.41/apache-tomcat-8.5.41/webapps/"
                    }]
                 }"""
                 server.download(downloadSpec)
               }
            }
        }        
	
        stage ('Dockerize and Push to DockerHub') {
            steps {
                script {
                    bat "docker build . -t vlab-devops:tomcat"
                    docker.withRegistry('', 'dockerhub') {
                        bat "docker tag vlab-devops:tomcat sandeepvyas/vlab-devops:tomcat"
                        bat "docker push sandeepvyas/vlab-devops:tomcat"
                    }
                }
            }
        }
	
    }
}