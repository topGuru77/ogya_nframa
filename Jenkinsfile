pipeline {
    agent any

    environment {
        GIT_REPO = "https://github.com/topGuru77/ogya_nframa.git"
        BRANCH = "main"
        GIT_USER_NAME = "topGuru77"
        GIT_USER_EMAIL = "kwamenadollar17@yahoo.com"
    }

    stages {
        stage('SCM checkout Code') {
            steps {
                script {
                    // Handle existing directory
                    sh '''
                        if [ -d "topG" ]; then
                            echo "Directory 'topG' already exists. Pulling latest changes."
                            cd topG
                            git config --global user.email "$GIT_USER_EMAIL"
                            git config --global user.name "$GIT_USER_NAME"
                            git reset --hard
                            git pull origin $BRANCH
                        else
                            echo "Cloning repository."
                            git config --global user.email "$GIT_USER_EMAIL"
                            git config --global user.name "$GIT_USER_NAME"
                            git clone $GIT_REPO topG
                        fi
                    '''
                }
            }
        }

        stage('Debug Terraform Variables') {
            steps {
                dir('topG') {
                    sh '''
                        echo "Checking if jenkins.auto.tfvars exists..."
                        if [ -f "jenkins.auto.tfvars" ]; then
                            echo "jenkins.auto.tfvars file found:"
                            cat jenkins.auto.tfvars
                        else
                            echo "jenkins.auto.tfvars file NOT found!"
                            exit 1
                        fi
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
                    withCredentials([string(credentialsId: 'GITHUB_PAT', variable: 'PAT')]) {
                        sh '''
                            git add .
                            git commit -m "Auto commit after Terraform apply" || echo "Nothing to commit"
                            git push https://$GIT_USER_NAME:$PAT@github.com/topGuru77/ogya_nframa.git $BRANCH
                        '''
                    }
                }
            }
        }
    }
}