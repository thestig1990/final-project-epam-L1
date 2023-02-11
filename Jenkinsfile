pipeline {
    agent {
        label "aws"
    }
    tools {
        terraform "Terraform"
    }
    stages {
        stage("Build") {
            steps {
                script {
                    sh """
                    echo "#-----------------Build STARTED-----------------#" 
                    sleep 10
                    ls -la
                    echo "#-----------------Build FINISHED----------------#" 
                    """
                }
            }
        }
        stage("Unit Test") {
            steps {
                script {
                    sh script: "bash ${WORKSPACE}/scripts/unit_test.sh", returnStatus: true
                }
            }
        }
        stage("Deploy to S3 bucket") {
            environment {
                ARTIFACT = sh (returnStdout: true, script: 
                """
                aws s3api list-buckets --query 'Buckets[].Name' | grep -wo "\\w*thestig-artifact-\\w*" | cut -d" " -f2
                """
                ).trim()
                TFSTATE = sh (returnStdout: true, script: 
                """
                aws s3api list-buckets --query 'Buckets[].Name' | grep -wo "\\w*thestig-tfstate-\\w*" | cut -d" " -f2
                """
                ).trim()
            }
            steps {
                script {
                    sh """
                    echo "#-----------------Deploy STARTED-----------------#" 
                    sleep 2
                    zip  $UNIQUE_IDENTIFIER-build-artifacts.zip index.html
                    aws s3 cp $UNIQUE_IDENTIFIER-build-artifacts.zip s3://${ARTIFACT}
                    sleep 2
                    echo "#-----------------Deploy FINISHED----------------#" 
                    """
                }
            }
        }
    }

    

}
