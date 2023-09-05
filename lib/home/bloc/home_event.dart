part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class LoadEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class SignOutEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}
