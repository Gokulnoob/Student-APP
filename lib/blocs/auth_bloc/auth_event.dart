import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// 🔹 Login Event
class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// 🔹 Sign Up Event
class AuthSignUp extends AuthEvent {
  final String email;
  final String password;

  AuthSignUp({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// 🔹 Logout Event
class AuthLogout extends AuthEvent {}
