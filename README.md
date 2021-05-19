# Gerencia ONG :cat: :dog:


>Aplicação distribuída, na arquitetura cliente/servidor,
>que controla um sistema de  gerenciamento de uma ONG.

<p>
  <img src="https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white"/>
</p>

## Tópicos :round_pushpin:

- [Descriçao](#descrição-star2)
- [Pré-requisitos](#pré-requisitos-warning)
- [Como rodar](#como-rodar-ferris_wheel)

## Descriçao :star2:

Trabalho realizado para a disciplina de Sistemas Distríbuidos I do Curso Ciência da Computação - IFSUL Campus Passo Fundo

Protocolo de middleware de um sistema de gerenciamento de ONG.\
O Cliente (há dois tipos de cliente - admin da ONG e protetor) deve enviar operações, e o servidor processa a requisição, responde com status e o respectivo resultado.
Para fazer operações no sistema, o cliente deverá estar autenticado (via login).

O servidor inicia uma thread para cada cliente conectado, trata sua conexão e oferece ao cliente os estados: Conectado, Autenticado, Saindo.

Para o controle de estado foi utilizado [`State Design Pattern`](https://refactoring.guru/design-patterns/state).

## Pré-requisitos :warning:

Ruby >= 2.7 :)

## Como rodar :ferris_wheel:

Primeiro, é necessário que o servidor seja iniciado.\
Para fazer isso, abra o terminal na pasta raíz e rode o comando:
```
ruby server\server.rb
```

Após, é preciso iniciar os clientes.\
Abra outro terminal na pasta raíz no projeto e rode o comando para cada cliente:
```
ruby client\client.rb
```
