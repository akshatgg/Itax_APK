import 'package:json_annotation/json_annotation.dart';

part 'last_login.g.dart';

@JsonSerializable()
class LastLogin {
  final String email;
  final String password;
  LastLogin({
    this.email = '',
    this.password = '',
  });

  
  factory LastLogin.fromJson(Map<String, dynamic> json) =>
      _$LastLoginFromJson(json);

  Map<String, dynamic> toJson() => _$LastLoginToJson(this);


  LastLogin copyWith({
    String? email,
    String? password,
  }) {
    return LastLogin(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() => 'LastLogin(email: $email, password: $password)';
}
