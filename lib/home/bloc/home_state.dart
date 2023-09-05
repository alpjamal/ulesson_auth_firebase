part of 'home_bloc.dart';

class HomeState extends Equatable {
  final Status status;
  final String errorMessage;
  final Status authStatus;
  final List<Contact> contacts;

  const HomeState({
    this.status = Status.initial,
    this.errorMessage = '',
    this.authStatus = Status.success,
    this.contacts = const [],
  });

  HomeState copyWith({
    Status? status,
    String? errorMessage,
    Status? authStatus,
    List<Contact>? contacts,
  }) {
    return HomeState(
      status: status ?? this.status,
      authStatus: authStatus ?? this.authStatus,
      errorMessage: errorMessage ?? '',
      contacts: contacts ?? this.contacts,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        authStatus,
        contacts,
      ];
}
