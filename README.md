<div align="center">
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
<img src="https://img.shields.io/badge/Dio-red?style=for-the-badge&logo=dart&logoColor=white" alt="Dio">
</div>

<p align="center">
<strong>Language:</strong>
<a href="README.pt.md">Português</a> | English
</p>

<h1 align="center">Flutter HTTP Architecture</h1>

<p align="center">
Decoupled infrastructure for managing HTTP requests, based on contracts and semantic error handling.
<br>
<a href="#about-the-project"><strong>Explore the documentation »</strong></a>
</p>

## Table of Contents

- [Overview](#overview)
  - [Motivation and Problems](#motivation-and-problems)
  - [Goals and Benefits](#goals-and-benefits)
- [Requirements and Technologies](#requirements-and-technologies)
- [Installation and Execution](#installation-and-execution)
- [Architecture Components](#architecture-components)
  - [HttpClient and Driver](#httpclient-and-driver)
  - [RequestExecutor](#requestexecutor)
  - [ApiResponse and Error Handling](#apiresponse-and-error-handling)
- [Execution Flow](#execution-flow)
- [Resilience and Idempotency](#resilience-and-idempotency)
- [Advanced Features](#advanced-features)
  - [File Upload (Multipart)](#file-upload-multipart)
  - [Monitoring and Diagnostics (Logs)](#monitoring-and-diagnostics-logs)
- [Folder Structure](#folder-structure)
- [Implementation Examples](#implementation-examples)
- [License](#license)
- [Author](#author)

## Overview

This architecture provides a robust and decoupled HTTP layer for Flutter applications. Its goal is to ensure that all HTTP requests are handled centrally, protecting the domain and data layers from technical implementation details. By abstracting the network engine (Dio driver), the architecture allows repositories and services to receive normalized responses, eliminating the need to deal directly with raw exceptions or inconsistent behaviors from external libraries.

### Motivation and Problems

Using an HTTP client directly inside repositories or services can cause several maintenance and scalability issues:

- **Abstraction Leakage**  
  Library-specific errors (such as `DioException`) end up reaching the upper layers, which then depend on technical details of the driver.

- **Inconsistent Retries**  
  Each part of the code might implement its own retry logic, leading to duplication and different behaviors for the same type of failure.

- **Incorrect Use of Idempotency**  
  Requests may be repeated without criteria, including sensitive operations (like `POST`), which can lead to duplicate or inconsistent data.

- **Difficulty Testing**  
  Direct coupling with the HTTP client makes testing more complex, requiring mocks that are harder to configure.

- **Lack of Visibility**  
  Without a central control point, it becomes difficult to track the lifecycle of requests, such as execution time, number of attempts, failures occurred, and success rate. This limits the ability to diagnose problems, identify performance bottlenecks, and understand application behavior.

### Goals and Benefits

1. **Network Engine Isolation**  
   Define abstract interfaces that hide the use of the HTTP driver, allowing the implementation to be swapped without affecting the domain or data layers.

2. **Response Normalization**  
   Standardize request returns with a single model (`ApiResponse`), representing both success and error consistently.

3. **Automated Resilience**  
   Apply retries intelligently, considering the request type, idempotency, and the type of failure occurred.

4. **Semantic Error Mapping**  
   Convert technical errors into clear categories (such as `network`, `timeout`, and `unauthorized`), facilitating handling by business rules.

5. **Metrics and Diagnostics**  
   Collect information such as execution time, number of attempts, and request status, facilitating analysis.

6. **Support for Advanced Features**  
   Offer integrated support for file uploads (multipart), request cancellation, and structured logs for debugging.

This architecture centralizes network communication, reduces complexity in upper layers, and improves application reliability, consistency, and maintenance.

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

## Architecture Components

### HttpClient and Driver

The system is based on the `HttpClient` interface, which acts as the application's network contract. The `DioHttpClient` class provides the technical implementation using the Dio package, ensuring the network engine can be replaced with minimal impact on client code.

### RequestExecutor

The `RequestExecutor` acts as the central execution orchestrator. It manages the flow of calls within a retry loop, controlling parameters such as the maximum number of repetitions and the wait interval between failures.

### ApiResponse and Error Handling

Requests return the `ApiResponse<T>` object instead of throwing exceptions. This container provides the typed result or an `HttpError` object, which classifies the failure into semantic types like `network`, `unauthorized`, or `timeout`.

## Execution Flow

1. **Invocation**: The data layer calls the `HttpClient` to execute a request.

2. **Request Context**: The system creates a `RequestContext` to record the operation start and collect metrics such as time and attempts.

3. **Call Execution**: The `RequestExecutor` performs the request using the HTTP driver.

4. **Error Handling**: If a failure occurs, the technical error is converted to the standard `HttpError` model.

5. **Retry (when applicable)**: The system checks if the error is recoverable (e.g., connection failures, timeout, or 5xx errors) and if the request can be safely repeated (based on HTTP method idempotency or the `retryable` configuration).

   When allowed, the `RequestExecutor` applies an exponential backoff strategy between attempts, progressively increasing the wait time after each failure (e.g., 1s → 2s → 4s → 8s), up to a defined maximum limit to avoid excessive delays.

   The goal of this strategy is to reduce pressure on the server during instability scenarios and increase the request success rate during temporary failures.

6. **Result Return**: The final result is encapsulated in an `ApiResponse` and returned to the requesting layer.

## Resilience and Idempotency

The architecture adopts technical criteria based on the HTTP standard to ensure operation integrity:

- **Idempotent Methods**: `GET`, `PUT`, `DELETE`, `HEAD`, and `OPTIONS` operations are eligible for automatic retry in scenarios of connection failure or server errors (5xx).
- **Non-Idempotent Methods**: `POST` and `PATCH` operations are not automatically repeated, preventing the duplication of sensitive transactions, except when explicitly authorized via the `retryable` flag.
- **Recovery Triggers**: Resilience logic is triggered by failures considered temporary, such as connection issues, timeouts, too many requests (HTTP 429), and internal server errors (5xx status). When one of these scenarios occurs, the system checks if the request is eligible for retry before applying the retry mechanism.

## Advanced Features

### File Upload (Multipart)

Binary data management is simplified by the `MultipartHelper`. This utility automatically identifies and converts objects of type `File`, `List<File>`, `Uint8List`, or file paths (`String`) into `MultipartFile` instances. This abstraction allows upper layers to operate with native Dart types without direct dependence on specific Dio package classes.

### Monitoring and Diagnostics (Logs)

The `LoggingInterceptor` provides a structured and detailed console output for monitoring the lifecycle of requests during development. It uses the `RequestContext` to calculate performance metrics and track retry counts in real-time.

#### Request Log Example

Logged at the moment the call is triggered, including the initial context and request data with sensitive information masked.

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

Logged after receiving data from the server, including total execution time, final status, and protected sensitive data.

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

Logged in cases of technical or protocol failure, displaying the `HttpError` diagnostic, exception details, and stack trace.

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

## Folder Structure

```text
lib/
└─ src/
   └─ core/
      └─ http/
         ├─ client/
         │  ├─ http_client.dart            # Main HTTP client interface (architecture contract)
         │  └─ dio_http_client.dart        # Concrete implementation using Dio
         ├─ config/
         │  └─ network_config.dart         # Global network configurations (baseUrl, timeouts, default headers)
         ├─ errors/
         │  ├─ http_error.dart             # Standardized request error model
         │  └─ http_error_type.dart        # Semantic error types (timeout, network, server, etc.)
         ├─ executor/
         │  ├─ request_executor.dart       # Orchestrates execution, retry, and request resilience
         │  └─ request_context.dart        # Request context (time, retries, status, metrics)
         ├─ interceptors/
         │  └─ logging_interceptor.dart    # Intercepts and logs HTTP request and response details for debugging
         ├─ models/
         │  └─ api_response.dart           # Standardized response model containing data, error, and request info
         ├─ multipart/
         │  ├─ http_multipart.dart         # Base contract for multipart requests (FormData wrapper)
         │  ├─ dio_http_multipart.dart     # Multipart implementation using Dio (FormData)
         │  └─ multipart_helper.dart       # Builds FormData and converts files to MultipartFile
         ├─ options/
         │  └─ http_request_options.dart   # Defines specific request behaviors like retry, timeout, and execution rules
         ├─ tokens/
         │  └─ http_cancel_token.dart      # Control for canceling ongoing requests
         └─ types/
            └─ progress_callback_http.dart # Callback to track upload/download progress
```

## Implementation Examples

### Initialization and Global Configuration

```dart
final config = NetworkConfig(
  baseUrl: 'https://api.domain.com',
  connectTimeout: Duration(seconds: 15),
);

final client = DioHttpClient(config: config);
```

### Executing a GET Request with Monitoring

```dart
final response = await client.get<Map<String, dynamic>>('/v1/profile');

if (response.isSuccess) {
  print('Payload: ${response.data}');
  print('Execution time: ${response.context?.duration?.inMilliseconds}ms');
} else {
  print('Error: ${response.error?.message}');
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
