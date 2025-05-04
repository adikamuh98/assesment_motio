import 'package:assesment_motio/core/models/state_controller.dart';
import 'package:assesment_motio/features/signup/data/models/signup_request.dart';
import 'package:assesment_motio/features/signup/domain/usecases/signup_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class SignupScreenCubit extends Cubit<StateController<bool>> {
  final SignupFirebase signupFirebase;
  SignupScreenCubit({required this.signupFirebase})
    : super(StateController.idle());

  void signup({required String email, required String password}) async {
    emit(StateController.loading());
    try {
      final credential = await signupFirebase(
        SignupRequest(email: email, password: password),
      );
      if (credential.user != null) {
        emit(StateController.success(true));
      } else {
        emit(StateController.error(errorMessage: 'Failed to sign up'));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(
          StateController.error(
            errorMessage: 'The password provided is too weak.',
          ),
        );
      } else if (e.code == 'invalid-email') {
        emit(
          StateController.error(
            errorMessage: 'The email address is badly formatted.',
          ),
        );
      } else if (e.code == 'operation-not-allowed') {
        emit(StateController.error(errorMessage: 'Operation not allowed.'));
      } else if (e.code == 'email-already-in-use') {
        emit(
          StateController.error(
            errorMessage: 'The account already exists for that email.',
          ),
        );
      } else {
        emit(StateController.error(errorMessage: 'An unknown error occurred.'));
      }
    } catch (e, s) {
      Logger().e(e.toString(), error: e, stackTrace: s);
      emit(StateController.error(errorMessage: 'Failed to sign up'));
    }
  }
}
