pipeline {
    agent {
        label "aws"
    }
    tools {
        terraform "Terraform"
    }

    parameters {
        string(name: 'UNIQUE_IDENTIFIER', defaultValue: 'fp-mysite', description: 'My unique identifier for the final project')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')
    }

     environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        /*stage('checkout') {
            steps {
                 script{
                        dir("terraform")
                        {
                            git "https://github.com/thestig1990/final-project-epam-L1.git"
                        }
                    }
                }
            } */

        stage('Plan') {
            environment {
                TFSTATE = sh (returnStdout: true, script: 
                """
                aws s3api list-buckets --query 'Buckets[].Name' | grep -wo "\\w*thestig-tfstate\\w*" | cut -d" " -f2
                """
                ).trim()
            }
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            steps {
                sh '''
                cd terraform
                pwd
                terraform init -no-color -backend-config="key=fpremote.tfstate" -backend-config="bucket=${TFSTATE}-bucket"
                terraform plan -input=false -out tfplan
                terraform show -no-color tfplan > tfplan.txt
                '''
            }
        }

        stage('Approval') {
            when {
                not {
                   equals expected: true, actual: params.autoApprove
                }
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            steps {
                script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Deploy/Apply') {
            environment {
                ARTIFACT = sh (returnStdout: true, script: 
                """
                aws s3api list-buckets --query 'Buckets[].Name' | grep -wo "\\w*thestig-artifact\\w*" | cut -d" " -f2
                """
                ).trim()
            }
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            steps {
                sh '''
                cd terraform
                terraform apply -input=false --auto-approve -no-color -var ARTIFACT=${ARTIFACT}-bucket
                '''
            }
        }

        stage("Show Domain") {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            steps {
                script {
                    sh script: "bash ${WORKSPACE}/scripts/display-elb-dns.sh ${UNIQUE_IDENTIFIER}", returnStatus: true
                }
            }
        }

        stage('Destroy') {
            when {
                equals expected: true, actual: params.destroy
            }
            steps {
                sh """
                cd terraform
                terraform destroy --auto-approve
                """
            }
        }
    }

    post {
        cleanup {
            script {
                if (params.destroy == true) {
                    deleteDir()
                    echo "Workspace directory was deleted"
                }
            } 
        }
    }
}