import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulesson_auth_firebase/auth/bloc/auth_bloc.dart';
import 'package:ulesson_auth_firebase/auth/repository/auth.dart';

import '../models/contact.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<LoadEvent>(_loadEvent);
    on<SignOutEvent>(_signOut);
  }

  _loadEvent(LoadEvent event, emit) async {
    emit(state.copyWith(status: Status.loading));
    var usersCollection = FirebaseFirestore.instance.collection('users');

    var snapshot = await usersCollection.get();

    var list = snapshot.docs.map((e) => e.data()).toList();

    List<Contact> contacts = List.generate(
      list.length,
      (index) => Contact(
        name: list[index]['name'] ?? 'test name',
        email: list[index]['email'],
      ),
    );

    emit(state.copyWith(
      status: Status.success,
      contacts: contacts,
    ));
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
}
