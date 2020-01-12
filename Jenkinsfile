pipeline {
    agent any
    environment {
      GREP_NAME = "kubernetes-CICD"
      GIO_NAME = "gcr.io"
      GPRJ_NAME = "gcp-project-name"
      GK8S_PJNAME = "kubenginx"
    }


    stages {
        stage('Development Build Image') {
            when {
               not { branch 'master' }
            }
            steps {
                sh "echo ${env.GREP_NAME}:${env.BRANCH_NAME}:${env.BUILD_NUMBER}"
                sh "echo ${GIO_NAME}/${GPRJ_NAME}/development/${GREP_NAME}:${BUILD_NUMBER}"
                sh "docker build . --tag ${GREP_NAME}:${BUILD_NUMBER}"
                sh "docker tag ${GREP_NAME}:${BUILD_NUMBER} ${GIO_NAME}/${GPRJ_NAME}/development/${GREP_NAME}:${BUILD_NUMBER}"
                sh "gcloud auth configure-docker"
                sh "docker push ${GIO_NAME}/${GPRJ_NAME}/development/${GREP_NAME}:${BUILD_NUMBER}"
                sh "docker rmi ${GIO_NAME}/${GPRJ_NAME}/development/${GREP_NAME}:${BUILD_NUMBER}"
                sh "docker rmi ${GREP_NAME}:${BUILD_NUMBER}"
                sh "git clone -b development git@github.com:carthorian/${GK8S_PJNAME}.git"
                sh "cd ${GK8S_PJNAME} && ls -all"
                sh "sed -i 's/{K8GIO_NAME}/${GIO_NAME}/g' ./k8s/${env.GREP_NAME}-deployment-development.yaml"
                sh "sed -i 's/{K8GPRJ_NAME}/${GPRJ_NAME}/g' ./k8s/${env.GREP_NAME}-deployment-development.yaml"
                sh "sed -i 's/{KREP_NAME}/${env.GREP_NAME}/g' ./k8s/${env.GREP_NAME}-deployment-development.yaml"
                sh "sed -i 's/{KBUILD_NUMBER}/${BUILD_NUMBER}/g' ./k8s/${env.GREP_NAME}-deployment-development.yaml"
                sh "cp ./k8s/${env.GREP_NAME}-deployment-development.yaml ./${GK8S_PJNAME}/${env.GREP_NAME}-deployment.yaml"
                sh "cd ${GK8S_PJNAME} && git add . && git commit -m \"DEVELOPMENT DEPLOYMENT: ${env.GREP_NAME}:${BUILD_NUMBER}\" && git push origin development"

            }
        }
        stage('Master Build Image') {
            when {
               branch 'master'
            }
            steps {
                sh "echo ${env.GREP_NAME}:${env.BRANCH_NAME}:${env.BUILD_NUMBER}"
                sh "echo ${GIO_NAME}/${GPRJ_NAME}/production/${GREP_NAME}:${BUILD_NUMBER}"
                sh "docker build . --tag ${GREP_NAME}:${BUILD_NUMBER}"
                sh "docker tag ${GREP_NAME}:${BUILD_NUMBER} ${GIO_NAME}/${GPRJ_NAME}/production/${GREP_NAME}:${BUILD_NUMBER}"
                sh "gcloud auth configure-docker"
                sh "docker push ${GIO_NAME}/${GPRJ_NAME}/production/${GREP_NAME}:${BUILD_NUMBER}"
                sh "docker rmi ${GIO_NAME}/${GPRJ_NAME}/production/${GREP_NAME}:${BUILD_NUMBER}"
                sh "docker rmi ${GREP_NAME}:${BUILD_NUMBER}"
                sh "git clone -b master git@github.com:carthorian/${GK8S_PJNAME}.git"
                sh "cd ${GK8S_PJNAME} && ls -all"
                sh "sed -i 's/{K8GIO_NAME}/${GIO_NAME}/g' ./k8s/${env.GREP_NAME}-deployment-production.yaml"
                sh "sed -i 's/{K8GPRJ_NAME}/${GPRJ_NAME}/g' ./k8s/${env.GREP_NAME}-deployment-production.yaml"
                sh "sed -i 's/{KREP_NAME}/${env.GREP_NAME}/g' ./k8s/${env.GREP_NAME}-deployment-production.yaml"
                sh "sed -i 's/{KBUILD_NUMBER}/${BUILD_NUMBER}/g' ./k8s/${env.GREP_NAME}-deployment-production.yaml"
                sh "cp ./k8s/${env.GREP_NAME}-deployment-production.yaml ./${GK8S_PJNAME}/${env.GREP_NAME}-deployment.yaml"
                sh "cd ${GK8S_PJNAME} && git add . && git commit -m \"PRODUCTION DEPLOYMENT: ${env.GREP_NAME}:${BUILD_NUMBER}\" && git push origin master"

            }
        }

    }
    post {
        failure {
            echo "Deploy Failed"
        }
        success {
            echo "Deploy Successfuly Completed..."
        }
        always {
                echo "Removing git repos"
                sh "pwd"
                sh "ls -all"
                sh "rm -fR ${GK8S_PJNAME}"
        }
    }
}

