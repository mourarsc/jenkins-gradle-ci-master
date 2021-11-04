### Baixando Istio

curl -sL https://istio.io/downloadIstioctl | sh -


### Configurando o usuário

kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole=cluster-admin \
    --user=<<username_cluster>>
    
 Na GCP por exemplo usar: 
 
 kubectl create clusterrolebinding cluster-admin-binding \
     --clusterrole=cluster-admin \
     --user=$(gcloud config get-value core/account)
     
 Aplicando com istio exemplo:
 
 
### Instalar Istio 

istioctl install

#### Ver profiles de instalação:

istioctl profile list

Dump do profile:

istioctl profile dump demo

Diferenças entre profiles:

istioctl profile diff default demo

istioctl install --set profile=demo

istioctl verify-install

Gerando arquivo de validação:

istioctl manifest generate > $HOME/generated-manifest.yaml

kubectl create namespace coffeeandit
 
kubectl config set-context --current --namespace=coffeeandit

istioctl kube-inject -f kubernetes/deploy.yml | kubectl apply -f - -n coffeeandit

### Setando a namespace como side-car

kubectl label namespace coffeeandit istio-injection=enabled

#### Vendo o label 

kubectl get namespace -L istio-injection


#### Vendo informações dos proxys:

istioctl proxy-status

Exemplo de retorno

jenkins-gradle-ci-bfd575d46-8s9th.coffeeandit          SYNCED     SYNCED     SYNCED     SYNCED       istiod-7968744c5b-sncmz     1.6.5

### Comandos para ver estados do proxy:

istioctl proxy-config cluster jenkins-gradle-ci-bfd575d46-8s9th.coffeeandit
istioctl proxy-config bootstrap jenkins-gradle-ci-bfd575d46-8s9th.coffeeandit
istioctl proxy-config bootstrap jenkins-gradle-ci-bfd575d46-8s9th.coffeeandit
istioctl proxy-config listener jenkins-gradle-ci-bfd575d46-8s9th.coffeeandit
istioctl proxy-config route jenkins-gradle-ci-bfd575d46-8s9th.coffeeandit
istioctl proxy-config endpoints jenkins-gradle-ci-bfd575d46-8s9th.coffeeandit

### Ingress Gateway

kubectl get svc istio-ingressgateway -n istio-system

Pegando informações do Ingress

export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export TCP_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="tcp")].port}')

curl -s -I -HHost:jenkins-gradle.coffeeandit.com.br "http://$INGRESS_HOST:$INGRESS_PORT/actuator/health"


### Removendo istio

istioctl manifest generate --set profile=demo | kubectl delete -f -
kubectl delete namespace istio-system