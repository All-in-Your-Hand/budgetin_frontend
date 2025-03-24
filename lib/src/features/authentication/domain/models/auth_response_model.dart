class AuthResponseModel {
  final String? message;
  final String? userId;
  final String? token;
  final String? refreshToken;

  AuthResponseModel({
    this.message,
    this.userId,
    this.token,
    this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json['message'] as String?,
      userId: json['userId'] as String?,
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (message != null) 'message': message,
      if (token != null) 'token': token,
      if (refreshToken != null) 'refreshToken': refreshToken,
      if (userId != null) 'userId': userId,
    };
  }
}
