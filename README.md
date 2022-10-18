# Simple app

## Installation

### In devcontainer

```sh
python api/src/api_server.py
streamlit run client/src/client.py

curl localhost:8501
```

### Container Build

```sh
cd api
docker build -t simple-app/api-service -f container/Dockerfile .
docker run -d --name simple-app/api-service simple-app/api-service:latest
```

```sh
cd client
docker build -t simple-app/client-service -f container/Dockerfile .
docker run -d --name simple-app/client-service -p 8501:8501 simple-app/client-service:latest
```

### On ECS

```sh
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.ap-northeast-1.amazonaws.com
```

Push ECR

```sh
cd api
docker build -t simple-app/api-service -f container/Dockerfile .
docker tag simple-app/api-service:latest <account-id>.dkr.ecr.ap-northeast-1.amazonaws.com/simple-app/api-service:latest
docker push <account-id>.dkr.ecr.ap-northeast-1.amazonaws.com/simple-app/api-service:latest
```

```sh
cd client
docker build -t simple-app/client-service -f container/Dockerfile .
docker tag simple-app/client-service:latest <account-id>.dkr.ecr.ap-northeast-1.amazonaws.com/simple-app/client-service:latest
docker push <account-id>.dkr.ecr.ap-northeast-1.amazonaws.com/simple-app/client-service:latest
```

### Deploy by Terraform

事前に ./terraform へ .tfvars ファイルを作成する。

```sh
cd terraform
touch terraform.tfvars
vim terraform.tfvars
# ...

terraform plan
terraform apply
```

## Reference

- [AWS ECS Fargateにシンプルなアプリをデプロイする](https://qiita.com/ny7760/items/6b1be8da329da79294e6)
- [Pythonの標準ライブラリでさくっとAPIサーバとWebサーバを立ち上げる](https://qiita.com/kai_kou/items/6cf5930330b85fa583b0)
- [Python だけで作る Web アプリケーション(フロントエンド編)](https://zenn.dev/alivelimb/books/python-web-frontend)
