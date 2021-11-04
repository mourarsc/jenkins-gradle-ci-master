kubectl cluster-info | grep 'Kubernetes master' | awk '/http/ {print $NF}' 

kubectl get secrets  

kubectl get secret default-token-tvlrj -o jsonpath="{['data']['ca\.crt']}" | base64 --decode



cat <<EOF | cfssl genkey - | cfssljson -bare server
{
  "hosts": [
    "jenkins-gradle-ci.default.svc.cluster.local",
    "jenkins-gradle-ci.pod.cluster.local"
  ],
  "CN": "jenkins-gradle-ci.default.pod.cluster.local",
  "key": {
    "algo": "ecdsa",
    "size": 256
  }
}
EOF

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: jenkins-gradle-ci.default
spec:
  request: $(cat server.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF

kubectl get csr
kubectl certificate approve jenkins-gradle-ci.default
