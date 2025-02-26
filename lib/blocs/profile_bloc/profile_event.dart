import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProfile extends ProfileEvent {
  final String regno;

  const LoadUserProfile(this.regno);

  @override
  List<Object> get props => [regno];
}

class UpdateUserProfile extends ProfileEvent {
  final String regno;
  final String name;
  final String dept;
  final String email;
  final String phone;
  final String skill;
  final String interest;
  final String bio;

  const UpdateUserProfile({
    required this.regno,
    required this.name,
    required this.email,
    required this.dept,
    required this.phone,
    required this.skill,
    required this.interest,
    required this.bio,
  });

  @override
  List<Object> get props =>
      [regno, name, email, dept, phone, skill, interest, bio];
}
