pipeline {
    agent any
    environment {
        VERSION="${env.BUILD_ID}"
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "http://localhost:8081"
        NEXUS_REPOSITORY = "maven-nexus-repo-test"
        NEXUS_CREDENTIAL_ID = "NEXUS_ID_CREDENTIAL"
    }
    

    stages {
        stage('Git Clone') {
           steps {
               script {
                   git credentialsId: 'GIT_CREDENTIAL', url: 'https://github.com/surjeetmohanty84/nexus-jenkins-demo.git'          
               }
           }
        }
        stage('Maven Build') {
           steps {
               script {
                   	    def mavenHome= tool name: "maven", type: "maven"
	    				def cmd= "${mavenHome}/bin/mvn"
	    				bat "${cmd} clean install"
               }
           }
        }
        stage('Sonar Qube Test') {
           steps {
               script {
                   withSonarQubeEnv(credentialsId: 'sonar-credential') {
		 	   			def mavenHome= tool name: "maven", type: "maven"
	    				def cmd= "${mavenHome}/bin/mvn"
	    				bat "${cmd} sonar:sonar"
		}
               }
           }
        }
        
        stage("Publish to Nexus Repository Manager") {
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

    }
}