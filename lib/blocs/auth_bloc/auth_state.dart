import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String userId;
  Authenticated({required this.userId});

  @override
  List<Object> get props => [userId];
}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class Unauthenticated extends AuthState {}
