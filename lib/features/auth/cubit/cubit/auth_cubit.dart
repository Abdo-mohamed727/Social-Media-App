import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/services/auth_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final authservices = AuthServices();
  Future<void> signInWithEmail(String email, String password) async {
    emit(AuthLoading());
    try {
      await authservices.signInWithEmail(email, password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(AuthLoading());
    try {
      await authservices.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await authservices.signOut();
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    try {
      await authservices.resetPassword(email);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void checkUserAuth() {
    final userData = authservices.fetchRawUser();
    if (userData != null) {
      emit(AuthSuccess());
    }
  }
}
