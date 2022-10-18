pipeline {
   
   tools {
        maven 'maven-3.5.2'
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
       
//    stage ('SonarQube Scann'){
//    steps {
//        script 
//        {
           
//             withSonarQubeEnv ('sonar'){
//                sh '''mvn sonar:sonar'''
//                sh '''/var/lib/jenkins/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonar/bin/sonar-scanner -Dsonar.projectKey=develop -Dsonar.sources=. '''
               
              
//             }
//             }
//         }

//   }    
   
    stage('Sonarqube') {
    environment {
        scannerHome = tool 'sonar'
    }
    steps {
        withSonarQubeEnv('sonar') {
            sh "${scannerHome}/bin/sonar-scanner"
           // sh 'mvn sonar:sonar'
        
        }
//        timeout(time: 2, unit: 'MINUTES') {
//             waitForQualityGate abortPipeline: true
//     }
    }
    }
//         stage('SonarQube') {

//             steps {

//             withSonarQubeEnv('sonar') {

//                  sh '''mvn sonar:sonar'''         }

//                  echo 'quality gate successfully passed'
            

//             }    

//         }
       
        stage('Maven Build'){
            steps {
                sh 'mvn clean deploy'           
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
                   
                    sh 'sudo ansible-playbook -i myhosts ansible.yml'
          } 
       }
    }
 }
