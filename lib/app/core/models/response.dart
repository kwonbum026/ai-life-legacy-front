// 공통 API 응답 모델
// 모든 API 응답은 이 구조를 따릅니다.

/// 공통 성공 응답 (200 OK)
class SuccessResponse<T> {
  final int status;
  final String message;
  final T data;

  SuccessResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SuccessResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return SuccessResponse<T>(
      status: json['status'] as int,
      message: json['message'] as String,
      data: fromJsonT(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}

/// 201 Created 응답
class Success201Response<T> {
  final int status;
  final String message;
  final T data;

  Success201Response({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Success201Response.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return Success201Response<T>(
      status: json['status'] as int,
      message: json['message'] as String,
      data: fromJsonT(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}

/// 204 No Content 응답 (data가 null인 경우)
class Success204Response {
  final int status;
  final String message;
  final dynamic data;

  Success204Response({
    required this.status,
    required this.message,
    this.data,
  });

  factory Success204Response.fromJson(Map<String, dynamic> json) {
    return Success204Response(
      status: json['status'] as int,
      message: json['message'] as String,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}

/// 에러 응답
class ErrorResponse {
  final int status;
  final String message;
  final dynamic data;

  ErrorResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}



