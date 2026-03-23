# Trabalho final Docker, Swarm and Registry

Para executar o trabalho crie uma pasta na raiz do cloud9. Para tal execute o comando.

```shell
mkdir -p /workspaces/FIAP-Orquestracao-Kubernetes-e-Containers/04-Trabalho-Final && cd /workspaces/FIAP-Orquestracao-Kubernetes-e-Containers/04-Trabalho-Final
```

1. Crie um Dockerfile que instale um NGINX utilizando um Ubuntu latest como base.
   Como algumas versões mais recentes do Ubuntu não possuem mais o comando `apt-key`, utilize o conteúdo abaixo como referência para o arquivo `Dockerfile`.

   ```Dockerfile
   FROM ubuntu:latest
   RUN apt-get update -y && \
      apt-get install -y -q nginx && \
      rm -rf /var/lib/apt/lists/*
   EXPOSE 443 80
   CMD ["nginx", "-g", "daemon off;"]
   ```
2. Execute o build da sua imagem dando o nome de nginx-trabalho-final.
3. Crie um cluster swarm.
4. Crie um repositório do ECR e faça o push da imagem montada no passo 2.
5. Crie um docker-compose.yml que contenha:
   1. Um serviço chamado "web" que utiliza sua imagem do ECR, utilize a porta 80 do container e porta 5000 do nó e que apenas possa ser executado no nó manager.
   2. Criar uma network chamada "servico" do tipo overlay e attachable
6. Rode o docker compose criado no cluster swarm.


##### Entregavel

Monte um zip contendo:
1. Os arquivos Dockerfile e docker-compose criados
2. Prints do cluster swarm com o serviço executando `docker service ls`
3. Print do console do ECR onde foi feito o push da imagem

##### Material para consulta

1. Dockerfile: [link](https://github.com/vamperst/FIAP-Orquestracao-Kubernetes-e-Containers/tree/master/02-containers/02-Dockerfile)
2. ECR: [link](https://github.com/vamperst/FIAP-Orquestracao-Kubernetes-e-Containers/tree/master/02-containers/03-registry)
3. Criar cluster swarm: [link](https://github.com/vamperst/FIAP-Orquestracao-Kubernetes-e-Containers/tree/master/03-Swarm/01-Montando-o-cluster)
4. Docker-compose e execução: [link](https://github.com/vamperst/FIAP-Orquestracao-Kubernetes-e-Containers/tree/master/03-Swarm/02-compose-%26-swarm-intro)
