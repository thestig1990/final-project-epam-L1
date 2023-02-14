pipeline {
    agent {
        label "aws"
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
                S3_OBJECT = sh (returnStdout: true, script:
                """
                aws s3 ls s3://thestig-artifact-bucket | cut -d" " -f10
                """
                ).trim()
                ARTIFACT_NAME = sh (returnStdout: true, script:
                """
                echo "$UNIQUE_IDENTIFIER-build-artifacts.zip"
                """
                ).trim()
            }
            steps {
                script {
                    sh """
                    echo "#-----------------Checking deployment-----------------#"
                    echo Artifact - ${ARTIFACT_NAME}
                    """
                }
                script {
                    if (env.ARTIFACT_NAME == env.S3_OBJECT) {
                        sh """
                        echo '#-----------------Deployment to the AWS S3 bucket was successful-----------------#'
                        echo "List of the objects in S3 bucket:"
                        aws s3api list-objects --bucket thestig-artifact-bucket
                        """
                        currentBuild.result = 'SUCCESS'
                        return
                    } else {
                        sh "echo '#-----------------Deployment to the AWS S3 bucket failed-----------------#'"
                        error("Deployment to the AWS S3 bucket failed")
                    }
                }
            }
        }
    }

    post {
        cleanup {
            deleteDir()
            echo "Workspace directory was deleted"
        } 
    }
}