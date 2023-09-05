import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
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
      _setSignInState();
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
      final userCredential = await Auth().createUserWithEmailAndPassword(
        password: event.signUpParams.password,
        email: event.signUpParams.email,
      );
      emit(
        state.copyWith(
          authStatus: Status.success,
        ),
      );
      _setSignInState();

      await FirebaseFirestore.instance.collection('users').doc(userCredential!.user!.uid).set(
        {
          'name': userCredential.user!.displayName,
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
        },
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
    if (state.authStatus.isError) {
      emit(state.copyWith(authStatus: Status.initial));
    }
  }

  _setSignInState() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSignedIn', true);
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
      _setSignInState();
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
