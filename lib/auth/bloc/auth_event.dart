part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignInEvent extends AuthEvent {
  final AuthParams signInParams;

  const SignInEvent({required this.signInParams});

  @override
  List<Object?> get props => [signInParams];
}

class SignUpEvent extends AuthEvent {
  final AuthParams signUpParams;

  const SignUpEvent({required this.signUpParams});

  @override
  List<Object?> get props => [signUpParams];
}
