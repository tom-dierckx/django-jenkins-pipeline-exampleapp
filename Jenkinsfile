def label = "worker-${UUID.randomUUID().toString()}"
podTemplate(label: label, containers: [
    containerTemplate(name: 'jnlp', image: 'tomdierckx/jenkins-arm-slave-jnlp:0.0.2', args: '${computer.jnlpmac} ${computer.name}'),
    containerTemplate(name: 'python3', image: 'arm32v7/python:3.6.5', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true),
    ],
volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {

    node(label) {
        stage('Build') {
            git credentialsId: 'bitbucket-cloud', url: 'https://dtommeke@bitbucket.org/dtommeke/jenkins-kubernetesbuild.git'
            container('python3') {
                stage('Running tests') {
                    sh 'pip install -r requirements.txt'
                    sh 'python manage.py test'
                }
            }
            container('docker') {
                stage('Building docker image') {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding',
                    credentialsId: 'dockerhub',
                    usernameVariable: 'DOCKER_HUB_USER',
                    passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
                    sh """
                        docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD}
                        docker build -t tomdierckx/python-django-ci-testapp:${BUILD_NUMBER} .
                        docker push tomdierckx/python-django-ci-testapp:${BUILD_NUMBER}
                        """
                    }
                }
            }
        }
    }   
}