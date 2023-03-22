# dummy_hello_app_infra

This repository has the code to create from scracth an EKS cluster on AWS, and there deploy 3 replicas of a dummy app, which response with `'Hola Mundo'` when you make request to the endpoint `'/hola'`, and also the Load Balancer service to expose the app to internet.
## Dummy hello app
The source code is at the `app/` directory. Just a simple flask app. If you want to test it run the followings commands after clone the repo.

Launch the app using python
``` bash
python install -r app/requirements.txt
python app/app.py
```

If you want to run it using docker
```bash
docker build -t dummy-hello-app ./app
docker run -p 8050:8050 dummy-hello-app
```

## Kubernetes manifest

The dockerized flask app could be deployed in a kubernetes cluster.The manifest are at the `/kubernetes-manifest` directory. Here you will see the `deployment.yaml` inidicating 3 replicas and a a `service.yaml` that expose the app with a LoadBalancer service.

If yoy want to try it local, you must need [minikube](https://minikube.sigs.k8s.io/docs/start/) installed. Minikube allow you to create a cluster in your local machine and simulate the loadbalancer to hit the the app.

```bash 
minikube start
kubectl apply -f kubernetes-manifests/.
```
When all will be created run
```bash 
minikube service dummy-hello-app --url
```
This will give you the the url to hit the pod locally

## AWS
To have the app living on the cloud we are using EKS from AWS. All the infrastructura was created as IaC using Terraform. 

To try this you will need the following:
- An AWS account
- `aws-cli` installed
- `terraform` installed
- `kubectl` installed

1. We configure `aws-cli` with our credentials in a new profile. You will need to create an access key and access secret on your aws account,

```
aws configure --profile dummy-hello-app
```
Follow the steps that the command show.

Once you have that. You can the terrafoirm file have coded the following thing

2. Associate this with terraform uising tyhe `aws` provider specifiyng the 
3. Create the VPC
    Was created using the `vpc`from terraform
3. Create the EKS
    Was created using the `eks`from terraform, also we create here the iam resources needed


```bash 
# Configure and prepare all neccessary to work with terraform 
terraform init

# Show what is going to create and if you accept with 'yes' apply them on AWS
terraform apply
```

This may take a while. After that you can configure `kubectl` make it able to talk directly with your cluster in AWS using the following command

```bash
aws eks update-kubeconfig --name dummy-hello-app-cluster --profile dummy-hello-app
```

Now we can interact with our cluster on AWS with `kubectl`. To deploy the app and expose it run

```
kubectl apply -f kubernetes-manifests/.
```

Whern all is created use `kuubectl`to get the public IP to hit your app.
```
kubectl get svc
```
Here you wil see something linke this. 
```bash
NAME       TYPE           CLUSTER-IP      EXTERNAL-IP                       PORT(S)        AGE
app-name  LoadBalancer  172.20.66.203   xxxxx.us-west-2.elb.amazonaws.com   80:32130/TCP   10m
```
Below the `EXTERNAL-IP` column there is the public IP to access to your app

`xxxxx.us-west-2.elb.amazonaws.com` is the public url of your cluster, that goes directly to any of the your dummy-hello-app replicas.

If you want to try it run in your terminal
```bash
curl xxxxx.us-west-2.elb.amazonaws.com/hola
```
you will see 'Hola Mundo' as a response


If you want to see the logs use

```bash 
kubectl logs -l app=dummy-hello-app -f
```

Here is a litle demo of the app working on aws and seeing the logs

![](demo.gif)


