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
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Componentes da Arquitetura](#componentes-da-arquitetura)
  - [HttpClient e Driver](#httpclient-e-driver)
  - [RequestExecutor](#requestexecutor)
  - [ApiResponse e Tratamento de Erros](#apiresponse-e-tratamento-de-erros)
- [Fluxo de Execução](#fluxo-de-execução)
- [Resiliência e Idempotência](#resiliência-e-idempotência)
- [Funcionalidades Avançadas](#funcionalidades-avançadas)
  - [Upload de Arquivos (Multipart)](#upload-de-arquivos-multipart)
  - [Monitoramento e Diagnóstico (Logs)](#monitoramento-e-diagnóstico-logs)
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

## Estrutura de Pastas

```text
lib/
└─ src/
   └─ core/
      └─ http/
         ├─ client/
         │  ├─ http_client.dart
         │  └─ dio_http_client.dart
         ├─ config/
         │  └─ network_config.dart
         ├─ errors/
         │  ├─ http_error_mapper.dart
         │  ├─ http_error.dart
         │  └─ http_error_type.dart
         ├─ executor/
         │  ├─ request_executor.dart
         │  └─ request_context.dart
         ├─ interceptors/
         │  └─ logging_interceptor.dart
         ├─ models/
         │  └─ api_response.dart
         ├─ multipart/
         │  ├─ http_multipart.dart
         │  ├─ dio_http_multipart.dart
         │  └─ multipart_helper.dart
         ├─ options/
         │  └─ http_request_options.dart
         ├─ tokens/
         │  └─ http_cancel_token.dart
         ├─ types/
         │  └─ progress_callback_http.dart
         └─ utils/
            └─ log_sanitizer.dart
```

---

## client

Define o contrato do cliente HTTP e sua implementação concreta utilizando Dio.
Responsável por abstrair completamente o motor de rede da arquitetura.

- `http_client.dart` → Contrato principal do cliente HTTP da arquitetura
- `dio_http_client.dart` → Implementação concreta usando Dio

---

## config

Centraliza todas as configurações globais de rede da aplicação.

- `network_config.dart` → Define baseUrl, timeouts e headers padrão

---

## errors

Responsável por padronizar, categorizar e normalizar erros HTTP de forma semântica.

- `http_error.dart` → Modelo padrão de erro da requisição
- `http_error_type.dart` → Tipos semânticos de erro HTTP
- `http_error_mapper.dart` → Responsável por converter exceções do driver (ex: DioException) em `HttpError`

---

## executor

Camada responsável por executar requisições HTTP com controle de fluxo, retry e métricas.

- `request_executor.dart` → Orquestra execução, retry e resiliência
- `request_context.dart` → Contexto da requisição (tempo, status, retries e métricas)

---

## interceptors

Camada de interceptação usada para logging e diagnóstico do ciclo HTTP.

- `logging_interceptor.dart` → Intercepta e registra requests, responses e erros

---

## models

Contém os modelos padronizados de resposta da camada HTTP.

- `api_response.dart` → Wrapper padrão contendo data, error e contexto

---

## multipart

Responsável por abstrair o envio de arquivos via multipart/form-data.

- `http_multipart.dart` → Contrato base de multipart
- `dio_http_multipart.dart` → Implementação usando Dio/FormData
- `multipart_helper.dart` → Conversão de arquivos para FormData

---

## options

Define configurações específicas aplicadas por requisição HTTP.

- `http_request_options.dart` → Timeout, retry e regras de execução

---

## tokens

Responsável pelo controle de cancelamento de requisições.

- `http_cancel_token.dart` → Abstração para cancelamento de requisições em andamento, **dependente da implementação do driver** (ex.: compatível com `DioCancelToken`, não totalmente agnóstica)

---

## types

Define tipos auxiliares usados na camada HTTP.

- `progress_callback_http.dart` → Callback de progresso de upload/download

---

## utils

Utilitários internos da infraestrutura HTTP.

- `log_sanitizer.dart` → Remove/sanitiza dados sensíveis antes de logs

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

5. **Retentativa (quando aplicável)**: O sistema verifica se o erro é recuperável (ex: falhas de conexão, timeout, HTTP 429 ou erros 5xx) e se a requisição pode ser repetida com segurança (com base na idempotência do método HTTP ou na configuração `retryable`).

   Quando permitido, o `RequestExecutor` aplica uma estratégia de backoff exponencial baseada no `retryDelay` configurado. O tempo de espera é multiplicado progressivamente a cada tentativa (ex: `baseDelay × 2ⁿ`), podendo resultar em sequências como 500ms → 1s → 2s → 4s, até um limite máximo definido para evitar atrasos excessivos.

   Caso `retryDelay` seja `Duration.zero`, nenhuma espera é aplicada entre as tentativas.

   O objetivo dessa estratégia é reduzir a pressão sobre o servidor em cenários de instabilidade e aumentar a taxa de sucesso das requisições em falhas temporárias.

6. **Retorno do resultado**: O resultado final é encapsulado em uma `ApiResponse` e retornado para a camada solicitante.

## Resiliência e Idempotência

A arquitetura adota critérios técnicos baseados no padrão HTTP para assegurar a integridade das operações:

- **Métodos Idempotentes**: Operações `GET`, `PUT`, `DELETE`, `HEAD` e `OPTIONS` são elegíveis para retentativa automática em cenários de falha de conexão ou erros de servidor (5xx).
- **Métodos Não-Idempotentes**: Operações `POST` e `PATCH` não são repetidas automaticamente, prevenindo a duplicidade de transações sensíveis, exceto quando explicitamente autorizado via flag `retryable`.
- **Gatilhos de recuperação**: A lógica de resiliência é acionada em falhas consideradas temporárias, como erros de conexão (`connectionError`), timeouts (`connectionTimeout`, `receiveTimeout`, `sendTimeout`), excesso de requisições (HTTP 429) e erros internos do servidor (status 5xx).

  Quando um desses cenários ocorre, o sistema verifica se a requisição é elegível para retentativa com base na idempotência do método HTTP ou na flag `retryable`. Requisições canceladas (`cancel`) não são elegíveis para retry.

  Se permitido, o mecanismo de retry é aplicado respeitando o número máximo de tentativas e a estratégia de delay configurada.

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

Registrado após o recebimento dos dados do servidor, incluindo tempo total de execução, status final e dados sensíveis mascaradas.

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

## Exemplos de Implementação

### Configuração do Cliente HTTP

```dart
final httpClient = DioHttpClient(
  config: NetworkConfig(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: Duration(seconds: 15),
    receiveTimeout: Duration(seconds: 15),
    defaultHeaders: {
      'Content-Type': 'application/json',
    },
  ),
);
```

---

### Requisição GET

```dart
final response = await httpClient.get<List<dynamic>>(
  '/posts',
);

if (response.isSuccess) {
  final posts = response.data;
} else {
  final error = response.error;
}
```

---

### Requisição GET com Parâmetros

```dart
final response = await httpClient.get<List<dynamic>>(
  '/comments',
  queryParameters: {'postId': 1},
);

if (response.isSuccess) {
  final comments = response.data;
} else {
  final error = response.error;
}
```

---

### Requisição POST

```dart
final response = await httpClient.post<Map<String, dynamic>>(
  '/posts',
  data: {
    'title': 'foo',
    'body': 'bar',
    'userId': 1,
  },
);

if (response.isSuccess) {
  final createdPost = response.data;
} else {
  final error = response.error;
}
```

---

### Requisição com Retry

```dart
final response = await httpClient.get<List<dynamic>>(
  '/posts',
  options: HttpRequestOptions(
    maxRetries: 2,
    retryDelay: Duration(milliseconds: 300),
  ),
);
```

---

### Upload Multipart

```dart
final multipart = await MultipartHelper.fromMap({
  'file': File('/path/to/file.png'),
});

final response = await httpClient.post<Map<String, dynamic>>(
  '/posts',
  data: multipart,
  onSendProgress: (sent, total) {
    final progress = sent / total;
  },
);
```

---

### Cancelamento de Requisição

```dart
final cancelToken = DioCancelToken();

final future = httpClient.get<List<dynamic>>(
  '/posts',
  cancelToken: cancelToken,
);

cancelToken.cancel();

final response = await future;
```

---

### Uso em Repositório

```dart
class PostRepository {
  final HttpClient client;

  PostRepository(this.client);

  Future<ApiResponse<List<dynamic>?>> getPosts() {
    return client.get('/posts');
  }
}
```

---

### Tratamento de Erros

```dart
final response = await httpClient.get('/posts');

if (!response.isSuccess) {
  switch (response.error?.type) {
    case HttpErrorType.network:
      break;
    case HttpErrorType.timeout:
      break;
    case HttpErrorType.unauthorized:
      break;
    case HttpErrorType.server:
      break;
    default:
      break;
  }
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
