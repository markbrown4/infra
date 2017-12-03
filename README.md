
# mbops

infra code to manage personal server(s)

```
brew install terraform
brew install python
sudo pip2 install awscli --ignore-installed six
```

## Configure awscli

```bash
export AWS_DEFAULT_REGION="ap-southeast-2"
export AWS_PROFILE="yellowshoe"
aws configure set profile.yellowshoe.region ap-southeast-2
aws configure set profile.yellowshoe.aws_access_key_id <KEY>
aws configure set profile.yellowshoe.aws_secret_access_key <KEY>
```

## Configure terraform

```bash
terraform init
# modify .tf script
terraform plan
terraform apply
```

## linux

```bash
ssh ubuntu@<public_ip>

$ sudo netstat -lnp # see what ports are in use
$ curl 127.0.0.01:80 # check nginx running
```

## ansible

Install python2 on remote

```bash
$ apt-get install python -y
```

Install

```bash
sudo pip2 install ansible
mkdir /etc/ansible
# Add public ip / dns hostname
touch /etc/ansible/hosts
# check ansible can connect
ansible all -m ping --user ubuntu
```

## nginx

Install

```bash
ansible-galaxy install nginxinc.nginx-oss
ansible-playbook playbooks/nginx.yml
```

Verify

```bash
$ which nginx
$ sudo netstat -lnp
$ curl 127.0.0.1:80
```
