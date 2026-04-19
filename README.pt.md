<div align="center">
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
<img src="https://img.shields.io/badge/Dio-red?style=for-the-badge&logo=dart&logoColor=white" alt="Dio">
</div>

<p align="center">
<strong>Idioma:</strong>
Português | <a href="README.md">English</a>
</p>

<h1 align="center">Flutter HTTP Architecture</h1>

<p align="center">
Infraestrutura desacoplada para gerenciamento de requisições HTTP, baseada em contratos e tratamento semântico de erros.
<br>
<a href="#sobre-o-projeto"><strong>Explore a documentação »</strong></a>
</p>

## Sumário

- [Visão Geral](#visão-geral)
  - [Motivação e Problemas](#motivação-e-problemas)
  - [Objetivos e Benefícios](#objetivos-e-benefícios)
- [Requisitos e Tecnologias](#requisitos-e-tecnologias)
- [Instalação e Execução](#instalação-e-execução)
- [Componentes da Arquitetura](#componentes-da-arquitetura)
  - [HttpClient e Driver](#httpclient-e-driver)
  - [RequestExecutor](#requestexecutor)
  - [ApiResponse e Tratamento de Erros](#apiresponse-e-tratamento-de-erros)
- [Fluxo de Execução](#fluxo-de-execução)
- [Resiliência e Idempotência](#resiliência-e-idempotência)
- [Funcionalidades Avançadas](#funcionalidades-avançadas)
  - [Upload de Arquivos (Multipart)](#upload-de-arquivos-multipart)
  - [Monitoramento e Diagnóstico (Logs)](#monitoramento-e-diagnóstico-logs)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Exemplos de Implementação](#exemplos-de-implementação)
- [Licença](#licença)
- [Autor](#autor)

## Visão Geral

Esta arquitetura fornece uma camada HTTP robusta e desacoplada para aplicações Flutter. Seu objetivo é garantir que todas as requisições HTTP sejam tratadas de forma centralizada, protegendo as camadas de domínio e dados de detalhes técnicos da implementação. Ao abstrair o motor de rede (driver Dio), a arquitetura permite que repositórios e serviços recebam respostas normalizadas, eliminando a necessidade de lidar diretamente com exceções brutas ou comportamentos inconsistentes de bibliotecas externas.

### Motivação e Problemas

Usar diretamente um cliente HTTP dentro de repositórios ou serviços pode causar vários problemas de manutenção e escalabilidade:

- **Vazamento de abstração**  
  Erros específicos da biblioteca (como `DioException`) acabam chegando nas camadas superiores, que passam a depender de detalhes técnicos do driver.

- **Retentativas inconsistentes**  
  Cada parte do código pode implementar sua própria lógica de retry, gerando duplicação e comportamentos diferentes para o mesmo tipo de falha.

- **Uso incorreto de idempotência**  
  Requisições podem ser repetidas sem critério, inclusive em operações sensíveis (como `POST`), o que pode gerar dados duplicados ou inconsistentes.

- **Dificuldade para testar**  
  O acoplamento direto com o cliente HTTP torna os testes mais complexos, exigindo mocks mais difíceis de configurar.

- **Falta de visibilidade**  
  Sem um ponto central de controle, torna-se difícil acompanhar o ciclo de vida das requisições, como tempo de execução, número de tentativas, falhas ocorridas e taxa de sucesso. Isso limita a capacidade de diagnosticar problemas, identificar gargalos de performance e entender o comportamento da aplicação.

### Objetivos e Benefícios

1. **Isolamento do motor HTTP**  
   Definir interfaces abstratas que ocultam o uso do driver HTTP, permitindo trocar a implementação sem afetar as camadas de domínio ou dados.

2. **Normalização de respostas**  
   Padronizar o retorno das requisições com um único modelo (`ApiResponse`), que representa tanto sucesso quanto erro de forma consistente.

3. **Resiliência automatizada**  
   Aplicar retentativas de forma inteligente, considerando o tipo de requisição, idempotência e o tipo de falha ocorrida.

4. **Mapeamento semântico de erros**  
   Converter erros técnicos em categorias claras (como `network`, `timeout` e `unauthorized`), facilitando o tratamento pela regra de negócio.

5. **Métricas e diagnóstico**  
   Coletar informações como tempo de execução, número de tentativas e status das requisições, facilitando análise.

6. **Suporte a funcionalidades avançadas**  
   Oferecer suporte integrado a upload de arquivos (multipart), cancelamento de requisições e logs estruturados para depuração.

Essa arquitetura centraliza a comunicação HTTP, reduz complexidade nas camadas superiores e melhora a confiabilidade, consistência e manutenção da aplicação.

## Requisitos e Tecnologias

A arquitetura foi desenvolvida utilizando as seguintes especificações técnicas:

- **Dart SDK**: [`^3.10.4`](https://dart.dev)
- **Flutter SDK**: [`^3.10.0`](https://flutter.dev) ou superior
- **Dio**: [`^5.9.2`](https://pub.dev/packages/dio) (Motor de requisições)
- **Logger**: [`^2.6.2`](https://pub.dev/packages/logger) (Diagnóstico visual estruturado)
- **Riverpod**: [`Riverpod (^3.3.1)`](https://pub.dev/packages/riverpod) (Injeção de dependências e gerenciamento de estado)

## Instalação e Execução

Para executar o projeto localmente, siga os passos abaixo:

1. Instale as dependências do projeto:

```bash
flutter pub get
```

2. Verifique se o ambiente Dart e Flutter está compatível com as versões definidas no `pubspec.yaml`.

3. Execute o projeto em modo de depuração:

```bash
flutter run
```

## Componentes da Arquitetura

### HttpClient e Driver

O sistema baseia-se na interface `HttpClient`, que atua como o contrato de rede da aplicação. A classe `DioHttpClient` provê a implementação técnica utilizando o pacote Dio, garantindo que o motor de rede possa ser substituído com impacto mínimo no código cliente.

### RequestExecutor

O `RequestExecutor` atua como o orquestrador central de execuções. Ele gerencia o fluxo de chamadas dentro de um loop de tentativas, controlando parâmetros como a quantidade máxima de repetições e o intervalo de espera entre falhas.

### ApiResponse e Tratamento de Erros

As requisições retornam o objeto `ApiResponse<T>`, em substituição ao lançamento de exceções. Este container fornece o resultado tipado ou um objeto `HttpError`, o qual classifica a falha em tipos semânticos como `network`, `unauthorized` ou `timeout`.

## Fluxo de Execução

1. **Invocação**: A camada de dados chama o `HttpClient` para executar uma requisição.

2. **Contexto da requisição**: O sistema cria um `RequestContext` para registrar o início da operação e coletar métricas como tempo e tentativas.

3. **Execução da chamada**: O `RequestExecutor` realiza a requisição usando o driver HTTP.

4. **Tratamento de erros**: Se ocorrer uma falha, o erro técnico é convertido para o modelo padrão `HttpError`.

5. **Retentativa (quando aplicável)**: O sistema verifica se o erro é recuperável (ex: falhas de conexão, timeout ou erros 5xx) e se a requisição pode ser repetida com segurança (baseado na idempotência do método HTTP ou na configuração `retryable`).

   Quando permitido, o `RequestExecutor` aplica uma estratégia de backoff exponencial entre tentativas, aumentando progressivamente o tempo de espera a cada falha (ex: 1s → 2s → 4s → 8s), até um limite máximo definido para evitar atrasos excessivos.

   O objetivo dessa estratégia é reduzir a pressão sobre o servidor em cenários de instabilidade e aumentar a taxa de sucesso das requisições em falhas temporárias.

6. **Retorno do resultado**: O resultado final é encapsulado em uma `ApiResponse` e retornado para a camada solicitante.

## Resiliência e Idempotência

A arquitetura adota critérios técnicos baseados no padrão HTTP para assegurar a integridade das operações:

- **Métodos Idempotentes**: Operações `GET`, `PUT`, `DELETE`, `HEAD` e `OPTIONS` são elegíveis para retentativa automática em cenários de falha de conexão ou erros de servidor (5xx).
- **Métodos Não-Idempotentes**: Operações `POST` e `PATCH` não são repetidas automaticamente, prevenindo a duplicidade de transações sensíveis, exceto quando explicitamente autorizado via flag `retryable`.
- **Gatilhos de recuperação**: A lógica de resiliência é acionada em falhas consideradas temporárias, como problemas de conexão, timeouts, excesso de requisições (HTTP 429) e erros internos do servidor (status 5xx). Quando um desses cenários ocorre, o sistema verifica se a requisição é elegível para retentativa antes de aplicar o mecanismo de retry.

## Funcionalidades Avançadas

### Upload de Arquivos (Multipart)

O gerenciamento de dados binários é simplificado pelo `MultipartHelper`. Este utilitário identifica e converte automaticamente objetos do tipo `File`, `List<File>`, `Uint8List` ou caminhos de arquivo (`String`) em instâncias de `MultipartFile`. Tal abstração permite que as camadas superiores operem com tipos nativos do Dart, sem dependência direta de classes específicas do pacote Dio.

### Monitoramento e Diagnóstico (Logs)

O `LoggingInterceptor` provê uma saída estruturada e detalhada no console para monitoramento do ciclo de vida das requisições durante o desenvolvimento. Ele utiliza o `RequestContext` para calcular métricas de performance e rastrear a contagem de retentativas em tempo real.

#### Exemplo de Log de Requisição (Request)

Registrado no momento do disparo da chamada, incluindo o contexto inicial e os dados da requisição com informações sensíveis mascaradas.

```text
┌───────────── HTTP REQUEST ─────────────
│ ▶ REQUEST
│   POST https://api.exemplo.com/v1/auth/login
│
│ ▶ CONTEXT
│   start=2024-10-27T10:00:00.000 | retry=0 | status=- | duration=-
│
│ ▶ HEADERS
│   {Content-Type: application/json, Accept: application/json}
│
│ ▶ BODY
│   {email: user@exemplo.com, password: ***}
└────────────────────────────────────────
```

#### Exemplo de Log de Resposta (Response)

Registrado após o recebimento dos dados do servidor, incluindo tempo total de execução, status final e dados sensíveis protegidos.

```text
┌──────────── HTTP RESPONSE ─────────────
│ ▶ RESPONSE
│   POST https://api.exemplo.com/v1/auth/login
│   STATUS: 200
│
│ ▶ CONTEXT
│   start=2024-10-27T10:00:00.000 | retry=0 | status=200 | duration=450ms
│
│ ▶ HEADERS
│   {content-type: [application/json; charset=utf-8], cache-control: [no-cache]}
│
│ ▶ DATA
│   {token: ***, user: {id: 1, name: Usuario}}
└────────────────────────────────────────
```

#### Exemplo de Log de Erro (Error)

Registrado em casos de falha técnica ou de protocolo, exibindo o diagnóstico do `HttpError`, detalhes da exceção e o rastro de pilha (stack trace).

```text
┌───────────── HTTP ERROR ──────────────
│ ▶ REQUEST
│   GET https://api.exemplo.com/v1/user/profile
│   STATUS: 503
│
│ ▶ CONTEXT
│   start=2024-10-27T10:05:00.000 | retry=1 | status=503 | duration=120ms
│
│ ▶ ERROR
│   HttpErrorType.server | Service Unavailable
│
│ ▶ DATA
│   {message: Server is under maintenance}
│
│ ▶ EXCEPTION
│   DioException [bad response]: The server returned an invalid response.
│
│ ▶ STACK
│   #0      RequestExecutor.execute (package:flutter_http_architecture/...)
│   #1      DioHttpClient._request (package:flutter_http_architecture/...)
└────────────────────────────────────────
```

## Estrutura de Pastas

```text
lib/
└─ src/
   └─ core/
      └─ http/
         ├─ client/
         │  ├─ http_client.dart            # Interface principal do cliente HTTP (contrato da arquitetura)
         │  └─ dio_http_client.dart        # Implementação concreta usando o Dio
         ├─ config/
         │  └─ network_config.dart         # Configurações globais de rede (baseUrl, timeouts, headers padrão)
         ├─ errors/
         │  ├─ http_error.dart             # Modelo padronizado de erro da requisição
         │  └─ http_error_type.dart        # Tipos semânticos de erro (timeout, network, server, etc.)
         ├─ executor/
         │  ├─ request_executor.dart       # Orquestra execução, retry e resiliência das requisições
         │  └─ request_context.dart        # Contexto da requisição (tempo, retries, status, métricas)
         ├─ interceptors/
         │  └─ logging_interceptor.dart    # Intercepta e registra detalhes das requisições e respostas HTTP para debug
         ├─ models/
         │  └─ api_response.dart           # Modelo de resposta padronizada contendo dados, erro e informações da requisição
         ├─ multipart/
         │  ├─ http_multipart.dart         # Contrato base para requisições multipart (wrapper de FormData)
         │  ├─ dio_http_multipart.dart     # Implementação do multipart usando Dio (FormData)
         │  └─ multipart_helper.dart       # Constrói FormData e converte arquivos para MultipartFile
         ├─ options/
         │  └─ http_request_options.dart   # Define comportamentos específicos da requisição como retry, timeout e regras de execução
         ├─ tokens/
         │  └─ http_cancel_token.dart      # Controle de cancelamento de requisições em andamento
         └─ types/
            └─ progress_callback_http.dart # Callback para acompanhar progresso de upload/download
```

## Exemplos de Implementação

### Inicialização e Configuração Global

```dart
final config = NetworkConfig(
  baseUrl: 'https://api.dominio.com',
  connectTimeout: Duration(seconds: 15),
);

final client = DioHttpClient(config: config);
```

### Execução de Requisição GET com Monitoramento

```dart
final response = await client.get<Map<String, dynamic>>('/v1/perfil');

if (response.isSuccess) {
  print('Payload: ${response.data}');
  print('Tempo de execução: ${response.context?.duration?.inMilliseconds}ms');
} else {
  print('Erro: ${response.error?.message}');
}
```

## Licença

Distribuído sob a Licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais informações.

## Autor

Desenvolvido por **Dário Matias**:

- Portfolio: [https://dariomatias-dev.com](https://dariomatias-dev.com)
- GitHub: [https://github.com/dariomatias-dev](https://github.com/dariomatias-dev)
- Email: [matiasdario75@gmail.com](mailto:matiasdario75@gmail.com)
- Instagram: [https://instagram.com/dariomatias_dev](https://instagram.com/dariomatias_dev)
- LinkedIn: [https://linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev)
