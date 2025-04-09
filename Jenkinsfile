pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')  // Jenkins AWS Access Key ID Credential
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')  // Jenkins AWS Secret Access Key Credential
        GIT_REPO = "https://github.com/topGuru77/domino-25.git"
        BRANCH = "main"
        GIT_USER_NAME = "topGuru77"
        GIT_USER_EMAIL = "kwamenadollar17@yahoo.com"
    }

    stages {
        stage('SCM checkout Code') {
            steps {
                script {
                    // Checkout code from GitHub
                    sh '''
                        git config --global user.email "$GIT_USER_EMAIL"
                        git config --global user.name "$GIT_USER_NAME"
                        git clone $GIT_REPO
                    '''
                }
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                script {
                    // Terraform setup
                    sh '''
                        terraform init
                        terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply Terraform plan
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Auto Git Commit & Push') {
            steps {
                script {
                    // Check if we are in the correct directory after cloning
                    dir('domino-25') {
                        // Add, commit, and push changes to the GitHub repository
                        sh '''
                            git add .
                            git commit -m "Auto commit after Terraform apply" || echo "Nothing to commit"
                            git push https://$GIT_USER_NAME:$AWS_SECRET_ACCESS_KEY@github.com/topGuru77/domino-25.git $BRANCH
                        '''
                    }
                }
            }
        }
    }
}
