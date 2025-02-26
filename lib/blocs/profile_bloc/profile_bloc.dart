import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:student_event_management/repositories/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final userProfile = await profileRepository.getUserProfile(event.regno);
      emit(ProfileLoaded(
        name: userProfile.name,
        email: userProfile.email,
        dept: userProfile.dept,
        phone: userProfile.phone,
        skill: userProfile.skill,
        interest: userProfile.interest,
        bio: userProfile.bio,
      ));
    } catch (e) {
      ('Error in _onLoadUserProfile: $e');
      emit(ProfileLoaded(
        name: '',
        email: '',
        dept: '',
        phone: '',
        skill: '',
        interest: '',
        bio: '',
      ));
    }
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<ProfileState> emit) async {
    try {
      final userProfile = UserProfile(
        name: event.name,
        email: event.email,
        dept: event.dept,
        phone: event.phone,
        skill: event.skill,
        interest: event.interest,
        bio: event.bio,
      );
      await profileRepository.updateUserProfile(event.regno, userProfile);
      emit(ProfileLoaded(
        name: event.name,
        email: event.email,
        dept: event.dept,
        phone: event.phone,
        skill: event.skill,
        interest: event.interest,
        bio: event.bio,
      ));
    } catch (e) {
      ('Error in _onUpdateUserProfile: $e');
      emit(ProfileError("Failed to update profile"));
    }
  }
}
