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
                    echo "----------Build started-------------" 
                    sleep 10
                    ls -la
                    echo "----------Build finished-------------" 
                    """
                }
            }
        }
        stage("Test") {
            steps {
                script {
                    sh script: "bash ${WORKSPACE}/scripts/scripts/unit_test.sh", returnStatus: true
                }
            }
        }
    }

    

}
