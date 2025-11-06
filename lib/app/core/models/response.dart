// 공통 API 응답 모델
// 모든 API 응답은 이 구조를 따릅니다.

/// 공통 성공 응답 (200 OK)
class SuccessResponse<T> {
  final int status;
  final String message;
  final T result;

  SuccessResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory SuccessResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return SuccessResponse<T>(
      status: json['status'] as int,
      message: json['message'] as String,
      result: fromJsonT(json['result']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'result': result,
    };
  }
}

/// 201 Created 응답
class Success201Response<T> {
  final int status;
  final String message;
  final T result;

  Success201Response({
    required this.status,
    required this.message,
    required this.result,
  });

  factory Success201Response.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return Success201Response<T>(
      status: json['status'] as int,
      message: json['message'] as String,
      result: fromJsonT(json['result']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'result': result,
    };
  }
}

/// 204 No Content 응답
class Success204Response {
  final int status;
  final String message;

  Success204Response({
    required this.status,
    required this.message,
  });

  factory Success204Response.fromJson(Map<String, dynamic> json) {
    return Success204Response(
      status: json['status'] as int,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}

/// 에러 응답
class ErrorResponse {
  final int status;
  final String message;

  ErrorResponse({
    required this.status,
    required this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      status: json['status'] as int,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}

