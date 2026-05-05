<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Dio-red?style=for-the-badge&logo=dart&logoColor=white" alt="Dio">
</div>

<p align="center">
  <strong>Language:</strong>
  <a href="README.pt-br.md">Português</a> | English
</p>

<h1 align="center">Flutter HTTP Architecture</h1>

<p align="center">
  Decoupled infrastructure for HTTP request management, based on contracts and semantic error handling.
  <br>
  <a href="#about-the-project"><strong>Explore the documentation »</strong></a>
</p>

## Table of Contents

- [Overview](#overview)
  - [Motivation and Problems](#motivation-and-problems)
  - [Goals and Benefits](#goals-and-benefits)
- [Requirements and Technologies](#requirements-and-technologies)
- [Installation and Execution](#installation-and-execution)
- [Folder Structure](#folder-structure)
- [Architecture Components](#architecture-components)
  - [HttpClient and Driver](#httpclient-and-driver)
  - [RequestExecutor](#requestexecutor)
  - [ApiResponse and Error Handling](#apiresponse-and-error-handling)
- [Execution Flow](#execution-flow)
- [Resilience and Idempotency](#resilience-and-idempotency)
- [Advanced Features](#advanced-features)
  - [File Upload (Multipart)](#file-upload-multipart)
  - [Monitoring and Diagnostics (Logs)](#monitoring-and-diagnostics-logs)
- [Implementation Examples](#implementation-examples)
- [License](#license)
- [Author](#author)

## Overview

This architecture provides a robust and decoupled HTTP layer for Flutter applications. Its goal is to ensure that all HTTP requests are handled centrally, shielding the domain and data layers from technical implementation details. By abstracting the network engine (Dio driver), the architecture allows repositories and services to receive normalized responses, eliminating the need to deal directly with raw exceptions or inconsistent behavior from external libraries.

### Motivation and Problems

Using an HTTP client directly within repositories or services can cause several maintenance and scalability issues:

- **Abstraction Leakage**  
  Library-specific errors (such as `DioException`) reach the upper layers, making them dependent on the driver's technical details.

- **Inconsistent Retries**  
  Each part of the code might implement its own retry logic, leading to duplication and inconsistent behavior for the same type of failure.

- **Incorrect Use of Idempotency**  
  Requests may be retried indiscriminately, even in sensitive operations (like `POST`), which can lead to duplicate or inconsistent data.

- **Difficulty in Testing**  
  Direct coupling with the HTTP client makes testing more complex, requiring mocks that are harder to configure.

- **Lack of Visibility**  
  Without a central control point, it becomes difficult to track the request lifecycle, such as execution time, number of attempts, failures, and success rates. This limits the ability to diagnose problems, identify performance bottlenecks, and understand application behavior.

### Goals and Benefits

1. **HTTP Engine Isolation**  
   Define abstract interfaces that hide the HTTP driver usage, allowing the implementation to be swapped without affecting the domain or data layers.

2. **Response Normalization**  
   Standardize request returns with a single model (`ApiResponse`), representing both success and error consistently.

3. **Automated Resilience**  
   Apply retries intelligently, considering the request type, idempotency, and the type of failure occurred.

4. **Semantic Error Mapping**  
   Convert technical errors into clear categories (such as `network`, `timeout`, and `unauthorized`), facilitating business logic handling.

5. **Metrics and Diagnostics**  
   Collect information such as execution time, number of attempts, and request status to facilitate analysis.

6. **Support for Advanced Features**  
   Offer integrated support for file uploads (multipart), request cancellation, and structured logs for debugging.

This architecture centralizes HTTP communication, reduces complexity in upper layers, and improves the application's reliability, consistency, and maintainability.

## Requirements and Technologies

The architecture was developed using the following technical specifications:

- **Dart SDK**: [`^3.10.4`](https://dart.dev)
- **Flutter SDK**: [`^3.10.0`](https://flutter.dev) or higher
- **Dio**: [`^5.9.2`](https://pub.dev/packages/dio) (Request engine)
- **Logger**: [`^2.6.2`](https://pub.dev/packages/logger) (Structured visual diagnostics)
- **Riverpod**: [`Riverpod (^3.3.1)`](https://pub.dev/packages/riverpod) (Dependency injection and state management)

## Installation and Execution

To run the project locally, follow the steps below:

1. Install project dependencies:

```bash
flutter pub get
```

2. Ensure the Dart and Flutter environment is compatible with the versions defined in `pubspec.yaml`.

3. Run the project in debug mode:

```bash
flutter run
```

## Folder Structure

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

Defines the HTTP client contract and its concrete implementation using Dio.
Responsible for completely abstracting the network engine from the architecture.

- `http_client.dart` → Main HTTP client contract of the architecture.
- `dio_http_client.dart` → Concrete implementation using Dio.

---

## config

Centralizes all global network configurations for the application.

- `network_config.dart` → Defines baseUrl, timeouts, and default headers.

---

## errors

Responsible for standardizing, categorizing, and normalizing HTTP errors semantically.

- `http_error.dart` → Standard request error model.
- `http_error_type.dart` → Semantic HTTP error types.
- `http_error_mapper.dart` → Responsible for converting driver exceptions (ex: DioException) into `HttpError`.

---

## executor

Layer responsible for executing HTTP requests with flow control, retry, and metrics.

- `request_executor.dart` → Orchestrates execution, retry, and resilience.
- `request_context.dart` → Request context (time, status, retries, and metrics).

---

## interceptors

Interception layer used for logging and diagnosing the HTTP cycle.

- `logging_interceptor.dart` → Intercepts and records requests, responses, and errors.

---

## models

Contains standardized response models for the HTTP layer.

- `api_response.dart` → Standard wrapper containing data, error, and context.

---

## multipart

Responsible for abstracting file uploads via multipart/form-data.

- `http_multipart.dart` → Base multipart contract.
- `dio_http_multipart.dart` → Implementation using Dio/FormData.
- `multipart_helper.dart` → Helper for converting files to FormData.

---

## options

Defines specific configurations applied per HTTP request.

- `http_request_options.dart` → Timeout, retry, and execution rules.

---

## tokens

Responsible for request cancellation control.

- `http_cancel_token.dart` → Abstraction for canceling ongoing requests, **dependent on the driver implementation** (e.g., compatible with `DioCancelToken`, not fully agnostic).

---

## types

Defines auxiliary types used in the HTTP layer.

- `progress_callback_http.dart` → Callback for upload/download progress.

---

## utils

Internal utilities for the HTTP infrastructure.

- `log_sanitizer.dart` → Removes/sanitizes sensitive data before logging.

## Architecture Components

### HttpClient and Driver

The system is based on the `HttpClient` interface, which acts as the application's network contract. The `DioHttpClient` class provides the technical implementation using the Dio package, ensuring that the network engine can be replaced with minimal impact on client code.

### RequestExecutor

The `RequestExecutor` acts as the central execution orchestrator. It manages the call flow within a retry loop, controlling parameters such as the maximum number of attempts and the wait interval between failures.

### ApiResponse and Error Handling

Requests return an `ApiResponse<T>` object instead of throwing exceptions. This container provides the typed result or an `HttpError` object, which classifies the failure into semantic types like `network`, `unauthorized`, or `timeout`.

## Execution Flow

1. **Invocation**: The data layer calls the `HttpClient` to execute a request.

2. **Request Context**: The system creates a `RequestContext` to record the start of the operation and collect metrics like time and attempts.

3. **Call Execution**: The `RequestExecutor` performs the request using the HTTP driver.

4. **Error Handling**: If a failure occurs, the technical error is converted into the standard `HttpError` model.

5. **Retry (when applicable)**: The system checks if the error is recoverable (e.g., connection failures, timeout, HTTP 429, or 5xx errors) and if the request can be safely retried (based on the HTTP method idempotency or the `retryable` configuration).

   When permitted, the `RequestExecutor` applies an exponential backoff strategy based on the configured `retryDelay`. The wait time is progressively multiplied with each attempt (e.g., `baseDelay × 2ⁿ`), which can result in sequences like 500ms → 1s → 2s → 4s, up to a defined maximum limit to avoid excessive delays.

   If `retryDelay` is `Duration.zero`, no wait is applied between attempts.

   The goal of this strategy is to reduce server pressure during instability scenarios and increase the request success rate during temporary failures.

6. **Result Return**: The final result is encapsulated in an `ApiResponse` and returned to the calling layer.

## Resilience and Idempotency

The architecture adopts technical criteria based on the HTTP standard to ensure operation integrity:

- **Idempotent Methods**: `GET`, `PUT`, `DELETE`, `HEAD`, and `OPTIONS` operations are eligible for automatic retry in connection failure or server error (5xx) scenarios.
- **Non-Idempotent Methods**: `POST` and `PATCH` operations are not automatically retried to prevent duplicate sensitive transactions, except when explicitly authorized via the `retryable` flag.
- **Recovery Triggers**: Resilience logic is triggered for failures considered temporary, such as connection errors (`connectionError`), timeouts (`connectionTimeout`, `receiveTimeout`, `sendTimeout`), too many requests (HTTP 429), and internal server errors (status 5xx).

  When one of these scenarios occurs, the system checks if the request is eligible for retry based on the HTTP method idempotency or the `retryable` flag. Canceled requests (`cancel`) are not eligible for retry.

  If allowed, the retry mechanism is applied, respecting the maximum number of attempts and the configured delay strategy.

## Advanced Features

### File Upload (Multipart)

Binary data management is simplified by the `MultipartHelper`. This utility automatically identifies and converts objects of type `File`, `List<File>`, `Uint8List`, or file paths (`String`) into `MultipartFile` instances. This abstraction allows upper layers to operate with native Dart types without direct dependency on Dio package specific classes.

### Monitoring and Diagnostics (Logs)

The `LoggingInterceptor` provides a structured and detailed console output for monitoring the request lifecycle during development. It uses the `RequestContext` to calculate performance metrics and track retry counts in real-time.

#### Request Log Example

Recorded at the moment the call is triggered, including the initial context and request data with masked sensitive information.

```text
┌───────────── HTTP REQUEST ─────────────
│ ▶ REQUEST
│   POST https://api.example.com/v1/auth/login
│
│ ▶ CONTEXT
│   start=2024-10-27T10:00:00.000 | retry=0 | status=- | duration=-
│
│ ▶ HEADERS
│   {Content-Type: application/json, Accept: application/json}
│
│ ▶ BODY
│   {email: user@example.com, password: ***}
└────────────────────────────────────────
```

#### Response Log Example

Recorded after receiving data from the server, including total execution time, final status, and masked sensitive data.

```text
┌──────────── HTTP RESPONSE ─────────────
│ ▶ RESPONSE
│   POST https://api.example.com/v1/auth/login
│   STATUS: 200
│
│ ▶ CONTEXT
│   start=2024-10-27T10:00:00.000 | retry=0 | status=200 | duration=450ms
│
│ ▶ HEADERS
│   {content-type: [application/json; charset=utf-8], cache-control: [no-cache]}
│
│ ▶ DATA
│   {token: ***, user: {id: 1, name: User}}
└────────────────────────────────────────
```

#### Error Log Example

Recorded in cases of technical or protocol failure, displaying the `HttpError` diagnosis, exception details, and stack trace.

```text
┌───────────── HTTP ERROR ──────────────
│ ▶ REQUEST
│   GET https://api.example.com/v1/user/profile
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

## Implementation Examples

### HTTP Client Configuration

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

### GET Request

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

### GET Request with Parameters

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

### POST Request

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

### Request with Retry

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

### Multipart Upload

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

### Request Cancellation

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

### Repository Usage

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

### Error Handling

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

## License

Distributed under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Author

Developed by **Dário Matias**:

- Portfolio: [https://dariomatias-dev.com](https://dariomatias-dev.com)
- GitHub: [https://github.com/dariomatias-dev](https://github.com/dariomatias-dev)
- Email: [matiasdario75@gmail.com](mailto:matiasdario75@gmail.com)
- Instagram: [https://instagram.com/dariomatias_dev](https://instagram.com/dariomatias_dev)
- LinkedIn: [https://linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev)
