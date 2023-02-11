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
                    echo "----------Build finished-------------" 
                    """
                }
            }
        }
        stage("Test") {
            steps {
                script {
                    sh script: "unit_test.sh", returnStatus: true
                }
            }
        }
    }

    

}
