import 'package:assesment_motio/core/themes/app_button.dart';
import 'package:assesment_motio/features/home/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Text(
              'Welcome to the Home Screen',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            const SizedBox(height: 20),
            AppButton(
              onTap: () {
                // Add your logout logic here
                context.read<AuthBloc>().add(Logout());
              },
              text: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
