import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulesson_auth_firebase/auth/bloc/auth_bloc.dart';
import 'package:ulesson_auth_firebase/auth/presentation/sign_in_page.dart';
import 'package:ulesson_auth_firebase/home/bloc/home_bloc.dart';
import 'package:ulesson_auth_firebase/home/models/contact.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.authStatus.isInitial) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Users',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.deepPurple.shade300,
          ),
          body: state.status.isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.green,
                ))
              : SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      state.contacts.length,
                      (index) {
                        Contact contact = state.contacts[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: ListTile(
                            leading: const CircleAvatar(backgroundColor: Colors.grey),
                            title: Text(contact.email),
                            tileColor: Colors.green.shade200,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.read<HomeBloc>().add(SignOutEvent());
            },
            child: state.authStatus.isLoading ? const CircularProgressIndicator.adaptive() : const Icon(Icons.logout),
          ),
        );
      },
    );
  }
}
