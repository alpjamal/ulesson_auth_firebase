import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulesson_auth_firebase/auth/models/auth_params.dart';
import 'package:ulesson_auth_firebase/auth/repository/auth.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<SignInEvent>(_signIn);
    on<SignUpEvent>(_signUp);
  }

  _signIn(SignInEvent event, emit) async {
    emit(state.copyWith(authStatus: Status.loading));
    try {
      await Auth().signInWithEmailAndPassword(
        password: event.signInParams.password,
        email: event.signInParams.email,
      );
      emit(
        state.copyWith(
          authStatus: Status.success,
        ),
      );
    } on FirebaseException catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          authStatus: Status.error,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          authStatus: Status.error,
        ),
      );
    }
    emit(state.copyWith(authStatus: Status.initial));
  }

  _signUp(SignUpEvent event, emit) async {
    emit(state.copyWith(authStatus: Status.loading));
    try {
      await Auth().createUserWithEmailAndPassword(
        password: event.signUpParams.password,
        email: event.signUpParams.email,
      );
      emit(
        state.copyWith(
          authStatus: Status.success,
        ),
      );
    } on FirebaseException catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          authStatus: Status.error,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          authStatus: Status.error,
        ),
      );
    }
    emit(state.copyWith(authStatus: Status.initial));
  }
}
