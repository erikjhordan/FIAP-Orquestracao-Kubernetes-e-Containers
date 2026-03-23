## Conteiners 2.3 - Volumes & Network

**Antes de começar, execute os passos abaixo para configurar o ambiente caso não tenha feito isso ainda na aula de HOJE: [Preparando Credenciais](../../01-create-codespaces/Inicio-de-aula.md)**


1. Vamos acessar o terminal do nó master do cluster pelo console para fazer a demonstração. Para isso acesse o [link](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:instanceState=running) e selecione o nó master criado no módulo anterior.
    
    ![img/1.png](img/1.png)
2. Com o nó selecionado, clique em `Conectar`
    
    ![img/2.png](img/2.png)

3. Selecione a aba `Session Manager` e clique em `Conectar`
    
    ![img/3.png](img/3.png) 

4. Se tudo deu certo, você deve estar conectado no terminal do nó master do cluster. Agora vamos para a parte prática da aula.

    ![](img/4.png)

5.  Dentro do nó master execute os comandos abaixo para se mover para a pasta correta e baixar do git o repositório dessa demo
``` shell
cd /home/ssm-user/
git clone https://github.com/vamperst/vote-docker-exemple.git
cd vote-docker-exemple
```

![img/gitclone.png](img/gitclone.png)

6. Para subir a stack execute os comandos abaixo 
    ``` shell
    accountID=`aws sts get-caller-identity | jq .Account -r`
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $accountID.dkr.ecr.us-east-1.amazonaws.com
    docker stack deploy --with-registry-auth --compose-file docker-compose.yaml vote
    ``` 
7. Note no visualizer que o container no visualizer ficou em um nó manager como esta na configuração.
    ```
    TOKEN=$(curl -sX PUT "http://169.254.169.254/latest/api/token" \
      -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
    publicC9Ip=`curl -sH "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4` && echo "http://$publicC9Ip:8080"
    ```
    ![img/visualizer1.png](img/visualizer1.png)

8. Teste o Serviço de votação. Para isso execute os comandos abaixo afim que pegar a URL de cada serviço. O contador de votos se encontra na porta 5001 e a página para votar esta na porta 5000.
   ```
   workerIp=`aws ssm get-parameter --name "docker-worker-ip" | jq .Parameter.Value -r` && echo "Contador de votos - http://$workerIp:5001"
   echo "Página de votação - http://$workerIp:5000"
   ```
![img/getaddress.png](img/getaddress.png)

![img/resultapp1.png](img/resultapp1.png)

![img/votingapp1.png](img/votingapp1.png)

9. Você deve ter notado que o sistema guarda apenas um voto, e cado mude seu voto, isso reflete na porcentagem da contagem (100% para a sua ultima opção), mas não reflete na quantidade. Para descobrir o que esta acontecendo vamos ver o log do banco que serve o aplicativo resultapp. Para tal execute o comando `docker service logs -f vote_db`. Note que cada vez que vota na mesma opção ocorre um erro. Para fechar o log do terminal utilize a combinação de teclas CTRL + C.

![img/dberror.png](img/dberror.png)

10. O erro acima ocorre porque a chave do banco utilizada na votação é o cookie do seu navegador. Logo para conseguir votar mais de uma vez é necessário abrir abas privativas no seu navegador, acessar a página de votação, executar o voto e fechar. Para abrir abas privativas utilize o atalho CTRL + Shift + N. Note que agora quando vota a porcentagem e a quantidade se alteram.
   ![img/resultapp2.png](img/resultapp2.png)
11.  Delete a stack com o comando `docker stack rm vote`

![](img/2.png)

12.  Este exercício consumiu bastante espaço de disco nos nós em que foi feito o deploy. Vamos fazer o deploy de uma stack para executar o comando docker system prune em todos os nós do cluster. Para executar rode os comandos abaixo no codespaces.
    ```
    cd /home/ssm-user/vote-docker-exemple/
    docker stack deploy --with-registry-auth --compose-file docker-compose-prune.yaml tasks
    ```
13.  Aguarde um minuto e rode o comando abaixo para ver os logs executados em cada maquina do cluster.
    ```
    docker service logs tasks_system-prune
    ```
14.  Afim de parar esse serviço execute o comando `docker stack rm tasks`
