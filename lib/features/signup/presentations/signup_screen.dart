import 'package:assesment_motio/core/helper/snackbar_helper.dart';
import 'package:assesment_motio/core/models/state_controller.dart';
import 'package:assesment_motio/core/themes/app_button.dart';
import 'package:assesment_motio/core/themes/app_text_field.dart';
import 'package:assesment_motio/features/signup/domain/usecases/signup_firebase.dart';
import 'package:assesment_motio/features/signup/presentations/bloc/signup_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final SignupScreenCubit _signupScreenCubit;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _signupScreenCubit = SignupScreenCubit(
      signupFirebase: context.read<SignupFirebase>(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: BlocConsumer<SignupScreenCubit, StateController<bool>>(
        bloc: _signupScreenCubit,
        listener: (context, state) {
          if (state is Loading) {
            context.loaderOverlay.show();
          } else {
            context.loaderOverlay.hide();
          }

          if (state is Success) {
            SnackbarHelper.success(message: 'Account created successfully');
            Navigator.pop(context);
          }
          if (state is Error) {
            SnackbarHelper.error(message: state.inferredErrorMessage ?? '');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              spacing: 16,
              children: [
                const SizedBox(height: 20),
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                AppTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                ),
                AppTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  obscureText: true,
                ),
                AppButton(
                  text: 'Create Account',
                  isFitParent: true,
                  onTap: () {
                    if (_emailController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _confirmPasswordController.text.isEmpty) {
                      SnackbarHelper.error(message: 'Please fill all fields');
                      return;
                    }
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      SnackbarHelper.error(message: 'Passwords do not match');
                      return;
                    }

                    _signupScreenCubit.signup(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
