pipeline {
    agent any

    environment {
        GIT_REPO = "https://github.com/topGuru77/ogya_nframa.git"
        BRANCH = "main"
        GIT_USER_NAME = "topGuru77"
        GIT_USER_EMAIL = "kwamenadollar17@yahoo.com"
        GIT_PAT = credentials('GIT_PAT') // Jenkins credential ID for your GitHub PAT
    }

    stages {
        stage('SCM Checkout Code') {
            steps {
                script {
                    sh '''
                        git config --global user.email "$GIT_USER_EMAIL"
                        git config --global user.name "$GIT_USER_NAME"
                        git clone $GIT_REPO topG
                    '''
                }
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                dir('topG') {
                    sh '''
                        terraform init
                        terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('topG') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Auto Git Commit & Push') {
            steps {
                dir('topG') {
                    sh '''
                        git add .
                        git commit -m "Auto commit after Terraform apply" || echo "Nothing to commit"
                        git push https://$GIT_USER_NAME:$GIT_PAT@github.com/topGuru77/ogya_nframa.git $BRANCH
                    '''
                }
            }
        }
    }
}
