
# mbops

infra code to manage personal server(s)

```
brew install terraform
brew install python
sudo pip2 install awscli --ignore-installed six
```

## Configure awscli

```bash
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
