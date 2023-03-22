# dummy_hello_app_infra
This repository contains the code to create an EKS cluster on AWS from scratch and deploy 3 replicas of a dummy app that responds with `'Hola Mundo'` when you make a request to the endpoint`'/hola'`. Additionally, it includes the Load Balancer service to expose the app to the internet.

## Dummy hello app
The source code for the app is in the `app/` directory. It's a simple Flask app. If you want to test it, run the following commands after cloning the repo:

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

The Dockerized Flask app can be deployed in a Kubernetes cluster. The manifest files are located in the `kubernetes-manifest/` directory. Here, you'll find the `deployment.yaml` file indicating 3 replicas and a `service.yaml` file that exposes the app with a LoadBalancer service.

If you want to try it locally, you must have [Minikube](https://minikube.sigs.k8s.io/docs/start/) installed. Minikube allows you to create a cluster on your local machine and simulate the load balancer to hit the app.

```bash 
minikube start
kubectl apply -f kubernetes-manifests/.
```

When everything is created, run

```bash 
minikube service dummy-hello-app --url
```
This will give you the URL to hit the pod locally.

## AWS
To have the app running on the cloud, we are using EKS from AWS. All the infrastructure was created as IaC using Terraform.

To try this, you will need the following:

- An AWS account
- `aws-cli` installed
- `terraform` installed
- `kubectl` installed

1. We configure `aws-cli` with our credentials in a new profile. You will need to create an access key and access secret on your AWS account,

```
aws configure --profile dummy-hello-app
```
(Follow the steps that the command show.)

Once you have done that, you can follow the terraform files to see what we have coded in oerder to create the infrastructure:

- Associate terraform with your `aws` credentials
- Create the VPC using the `vpc` module from terraform
- Create the EKS using the `eks`module from terraform, and also create the IAM resources needed.

Now you understand what is in the code, lets create all the resources with terraform.

```bash 
# Configure and prepare all neccessary to work with terraform 
terraform init

# Show what is going to be created and apply them on AWS by accepting with 'yes'
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
Below the `EXTERNAL-IP` column there is the public IP to access your app

`xxxxx.us-west-2.elb.amazonaws.com` is the public URL of your cluster, which goes directly to any of your `dummy-hello-app` replicas.

If you want to try it, run in your terminal
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

Here is the [link](https://drive.google.com/file/d/1kndiadg3zru6OnKTRBvue_Wf6JtKrf5x/view?usp=sharing) to the video

