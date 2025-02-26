import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_event_management/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository; // ✅ Declare AuthRepository

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // ✅ Require AuthRepository
    on<AuthLogin>((event, emit) async {
      emit(AuthLoading());
      try {
        final userId = await authRepository.signIn(event.email, event.password);
        emit(Authenticated(userId: userId));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<AuthSignUp>((event, emit) async {
      emit(AuthLoading());
      try {
        final userId = await authRepository.signUp(event.email, event.password);
        emit(Authenticated(userId: userId));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<AuthLogout>((event, emit) async {
      await authRepository.signOut();
      emit(Unauthenticated());
    });
  }
}
