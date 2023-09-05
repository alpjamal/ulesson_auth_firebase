import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulesson_auth_firebase/auth/models/auth_params.dart';
import 'package:ulesson_auth_firebase/auth/repository/auth.dart';
import 'package:ulesson_auth_firebase/auth/repository/google_auth.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<SignInEvent>(_signIn);
    on<SignUpEvent>(_signUp);
    on<SignOutEvent>(_signOut);
    on<GoogleSignInEvent>(_googleSignIn);
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
      _setSignInState(true);
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
    if (state.authStatus.isError) {
      emit(state.copyWith(authStatus: Status.initial));
    }
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
      _setSignInState(true);
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
    if (state.authStatus.isError) {
      emit(state.copyWith(authStatus: Status.initial));
    }
  }

  _signOut(SignOutEvent event, emit) async {
    emit(state.copyWith(authStatus: Status.loading));
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await Auth().signOut();
      emit(state.copyWith(authStatus: Status.initial));
      _setSignInState(false);
    } on FirebaseException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  _setSignInState(bool signIn) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSignedIn', signIn);
  }

  _googleSignIn(
    GoogleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await GoogleAuth().googleSignIn();
      emit(
        state.copyWith(
          authStatus: Status.success,
        ),
      );
      _setSignInState(true);
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
    if (state.authStatus.isError) {
      emit(state.copyWith(authStatus: Status.initial));
    }
  }
}
