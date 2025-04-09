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
        stage('Terraform Init & Plan') {
            steps {
                dir('topG') {
                    sh '''
                        terraform init
                        terraform plan -out=tfplan \
                            -var "vpc_cidr_block=10.0.0.0/16" \
                            -var "pub_subnet1_az=us-east-1a" \
                            -var "pub_subnet2_az=us-east-1b" \
                            -var "pub_subnet3_az=us-east-1c" \
                            -var "priv_subnet1_az=us-east-1a" \
                            -var "priv_subnet2_az=us-east-1b" \
                            -var "ami=ami-00a929b66ed6e0de6" \
                            -var "key_name=Pekay-keys" \
                            -var "tag_overlay={\\\"Name\\\":\\\"ASG_network\\\",\\\"Env\\\":\\\"dev\\\",\\\"Project\\\":\\\"ASG\\\",\\\"PM\\\":\\\"top Guru\\\"}"
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
