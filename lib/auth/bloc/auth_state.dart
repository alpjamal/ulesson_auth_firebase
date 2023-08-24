part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final String errorMessage;
  final Status authStatus;

  const AuthState({
    this.errorMessage = '',
    this.authStatus = Status.initial,
  });

  AuthState copyWith({
    String? errorMessage,
    Status? authStatus,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      errorMessage: errorMessage ?? '',
    );
  }

  @override
  List<Object?> get props => [
        errorMessage,
        authStatus,
      ];
}

enum Status { initial, loading, error, success }

extension StatusX on Status {
  bool get isInitial => this == Status.initial;

  bool get isLoading => this == Status.loading;

  bool get isError => this == Status.error;

  bool get isSuccess => this == Status.success;
}
