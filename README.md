# API Gateway — Sistema de Gestão Veterinária

Este repositório contém a configuração do **API Gateway** do **Sistema de Gestão Veterinária**, responsável por atuar como o ponto único de entrada (*Single Point of Entry*) para todas as requisições do sistema.

O gateway é construído sobre o **Nginx** e encapsula o roteamento de tráfego HTTP/HTTPS, redirecionando as chamadas externas para os microsserviços internos Spring Boot e para a interface gráfica web na rede privada do Docker.

---

## Padrão de Arquitetura e Roteamento

O API Gateway intercepta todas as chamadas recebidas na porta `80` e realiza o proxy reverso para os respectivos contêineres da aplicação com base no prefixo da URL.

```text
                                +-------------------+
                                |   Cliente / Web   |
                                +---------+---------+
                                          |
                                          | HTTP (Porta 80)
                                          v
                                +-------------------+
                                |    API Gateway    |
                                |      (Nginx)      |
                                +---------+---------+
                                          |
        +------------------+--------------+--------------+------------------+
        | /                | /identidade  | /clinico     | /agendamentos    | /faturamento
        v                  v              v              v                  v
+---------------+  +---------------+  +---------------+  +---------------+  +---------------+
| Interface Web |  | Serv. Ident.  |  | Serv. Clínico |  | Serv. Agend.  |  | Serv. Fatur.  |
| (Frontend)    |  | (Porta 8080)  |  | (Porta 8080)  |  | (Porta 8080)  |  | (Porta 8080)  |
+---------------+  +---------------+  +---------------+  +---------------+  +---------------+
```

### Tabela de Mapeamento de Rotas

| Prefixo da URL | Serviço de Destino | Descrição |
|---|---|---|
| `/` | `interface-web` | Interface de usuário (HTML, CSS e JavaScript). |
| `/identidade/` | `servico-identidade` | Autenticação, usuários, perfis, tutores e animais. |
| `/clinico/` | `servico-clinico` | Prontuários, exames, atendimentos e prescrições. |
| `/agendamentos/` | `servico-agendamento` | Agendas, disponibilidade e check-in. |
| `/faturamento/` | `servico-faturamento` | Cobranças, faturas e pagamentos. |

## Estrutura do Repositório

```text
vet-api-gateway/
├── Dockerfile      # Especificação da imagem Nginx baseada em Alpine
├── nginx.conf      # Regras de roteamento, logs e proxy reverso
├── .gitignore      # Arquivos ignorados pelo Git
└── README.md       # Documentação técnica do gateway
```

## Tecnologias Utilizadas

- **Nginx** — versão `1.25-alpine`.
- **Docker** — conteinerização da aplicação.
- **Docker Compose** — orquestração dos contêineres.

## Como Executar

Este repositório é orquestrado de forma integrada por meio do repositório `vet-infrastructure`.

### 1. Build e execução via Docker Compose

Execute os comandos a partir do diretório `vet-infrastructure`:

```bash
cd ../vet-infrastructure
docker compose up -d --build api-gateway
```

### 2. Execução isolada via Docker (opcional)

Caso deseje construir e executar apenas a imagem do Nginx localmente para testes:

**Construir a imagem:**

```bash
docker build -t vet-api-gateway .
```

**Executar o contêiner:**

```bash
docker run -d -p 80:80 --name api-gateway vet-api-gateway
```

## Diagnósticos e Logs

O Nginx está configurado para registrar os logs de acesso e erros no formato padrão.

Para acompanhar os logs do gateway em tempo real, execute:

```bash
docker logs -f api-gateway
```

Para interromper a visualização dos logs, pressione `Ctrl + C`. Isso encerra apenas o acompanhamento dos logs, sem parar o contêiner.