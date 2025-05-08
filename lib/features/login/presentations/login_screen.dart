import 'package:assesment_motio/core/helper/snackbar_helper.dart';
import 'package:assesment_motio/core/models/state_controller.dart';
import 'package:assesment_motio/core/themes/app_button.dart';
import 'package:assesment_motio/core/themes/app_colors.dart';
import 'package:assesment_motio/core/themes/app_fonts.dart';
import 'package:assesment_motio/core/themes/app_text_field.dart';
import 'package:assesment_motio/features/home/presentation/bloc/auth_bloc.dart';
import 'package:assesment_motio/features/login/data/models/login_request.dart';
import 'package:assesment_motio/features/login/domain/usecases/login_firebase.dart';
import 'package:assesment_motio/features/login/presentations/bloc/login_screen_cubit.dart';
import 'package:assesment_motio/features/signup/presentations/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginScreenCubit _loginScreenCubit;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginScreenCubit = LoginScreenCubit(
      loginFirebase: context.read<LoginFirebase>(),
      authBloc: context.read<AuthBloc>(),
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
        title: const Text('Login'),
        backgroundColor: appColors.white,
        surfaceTintColor: appColors.white,
        foregroundColor: appColors.black,
        shadowColor: appColors.black,
        centerTitle: true,
      ),
      backgroundColor: appColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocConsumer<LoginScreenCubit, StateController<bool>>(
          bloc: _loginScreenCubit,
          listener: (context, state) {
            if (state is Loading) {
              context.loaderOverlay.show();
            } else {
              context.loaderOverlay.hide();
            }

            if (state is Success) {
              context.read<AuthBloc>().add(Init());
            }

            if (state is Error) {
              SnackbarHelper.error(
                message: state.inferredErrorMessage ?? 'Failed to login',
              );
            }
          },
          builder: (context, state) {
            return Column(
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
                AppButton(
                  text: 'Login',
                  isFitParent: true,
                  onTap: () {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      SnackbarHelper.error(
                        message: 'Please fill in all fields',
                      );
                      return;
                    }

                    _loginScreenCubit.login(
                      LoginRequest(email: email, password: password),
                    );
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Create account',
                    style: appFonts.primary.bold.ts.copyWith(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? appColors.primary
                              : appColors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
