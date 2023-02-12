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
        stage("Checking deployment") {
            environment {
                NAME = sh (returnStdout: true, script:
                    """
                    aws s3 ls s3://thestig-artifact-bucket | awk '{print \$4}'
                    """).trim()
            }
            steps {
                script {
                    if ('fp-mysite-build-artifacts.zip' == ${NAME}) {
                        sh "echo '#-----------------Deployment to the AWS S3 bucket was successful-----------------#' "
                    } else {
                        sh "echo '#-----------------Deployment to the AWS S3 bucket was failed-----------------#' "
                    }
                    sh "aws s3api list-objects --bucket thestig-artifact-bucket"
                }
            }
        }
    }

    

}
