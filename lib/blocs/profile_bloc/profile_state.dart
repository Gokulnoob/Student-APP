import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String dept;
  final String phone;
  final String skill;
  final String interest;
  final String bio;

  const ProfileLoaded({
    required this.name,
    required this.email,
    required this.dept,
    required this.phone,
    required this.skill,
    required this.interest,
    required this.bio,
  });

  @override
  List<Object> get props => [name, email, dept, phone, skill, interest, bio];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}
