pipeline {
   
   tools {
        maven 'maven'
    }
    agent any
    environment {     
            NEXUS_VERSION = "nexus3"
            NEXUS_PROTOCOL = "http"
            NEXUS_URL = "176.34.158.145:8081"
            NEXUS_REPOSITORY = "maven-releases"
            NEXUS_CREDENTIAL_ID = "nexus"
    } 
    stages {
        stage('checkout code') {
            steps {
                    checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'git', url: 'https://github.com/Abhishek-alt-tech/DevOpsEKSDemo.git']]])
            }
        }
       
         stage('Maven Build'){
            steps {
                sh 'mvn clean deploy'           
               }
               }
            stage('SonarQube analysis'){

              steps{

                     script{

                         withSonarQubeEnv('sonar') {

                         sh "mvn sonar:sonar"

                              }

                         timeout(time: 2, unit: 'MINUTES') {

                              waitForQualityGate abortPipeline: true

                              }

                         

                      }

               }

        }

        stage('Push to Nexus'){
           steps {
                script {
                    pom = readMavenPom file: "pom.xml";
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    artifactPath = filesByGlob[0].path;
                    artifactExists = fileExists artifactPath;
                    if(artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: pom.version,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        );
                    } else {
                        error "*** File: ${artifactPath}, could not be found";
                    }
               }  
           }  
        }
      stage('Ansible Deploy'){
          steps {    
              echo "start connection"
              sh "pwd"
              sh 'ssh -tt -i IRELAND_KEYPAIR.pem root@ip-172-31-41-148.eu-west-1.compute.internal'
              sh 'whoami && ip r'
                //    echo "connection success"
                //    sh '''sudo su && cd /etc/ansible && sudo ansible-playbook -i /etc/ansible/myhost /etc/ansible/myplaybook/myplaybook.yml'''                     // sh 'sudo ansible-playbook -i myhosts ansible.yml'
               // ansiblePlaybook credentialsId: 'ansible', disableHostKeyChecking: true, installation: 'ansible', inventory: 'hosts', playbook: 'myplaybook.yml'
               //echo 'Tomcat Deployment is done'
         
          } 
       }
    }
 }
