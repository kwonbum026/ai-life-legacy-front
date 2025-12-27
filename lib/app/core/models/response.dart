// 공통 API 응답 모델
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

  // 1. json: 서버가 준 날것의 데이터
  // 2. fromJsonT: 내용물(T)을 어떻게 포장 풀지 알려주는 함수
  factory SuccessResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    // AI API는 'result' 필드를 사용하고, 다른 API는 'data' 필드를 사용
    final dataField = json['result'] ?? json['data'];

    return SuccessResponse<T>(
      status: (json['status'] ?? json['statusCode']) as int,
      message: json['message'] as String,
      data: fromJsonT(dataField),
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
    final dataField = json['result'] ?? json['data'];
    return Success201Response<T>(
      status: (json['status'] ?? json['statusCode']) as int,
      message: json['message'] as String,
      data: fromJsonT(dataField),
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
      status: (json['status'] ?? json['statusCode']) as int,
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
      status: (json['status'] ?? json['statusCode']) as int,
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
