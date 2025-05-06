import 'package:assesment_motio/core/models/state_controller.dart';
import 'package:assesment_motio/core/services/hive_service.dart';
import 'package:assesment_motio/core/services/storage_service.dart';
import 'package:assesment_motio/features/home/presentation/bloc/auth_bloc.dart';
import 'package:assesment_motio/features/login/data/models/login_request.dart';
import 'package:assesment_motio/features/login/domain/usecases/login_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class LoginScreenCubit extends Cubit<StateController<bool>> {
  final LoginFirebase loginFirebase;
  final AuthBloc authBloc;
  LoginScreenCubit({required this.loginFirebase, required this.authBloc})
    : super(StateController.idle());

  void login(LoginRequest request) async {
    try {
      emit(StateController.loading());
      final credential = await loginFirebase.call(request);
      if (credential.user != null) {
        final token = await credential.user!.getIdToken() ?? '';
        await SecureStorageService.instance.writeSecureData(
          SecureKey.token,
          token,
        );
        await HiveService.instance.initGroupBox();
        emit(StateController.success(true));
      } else {
        emit(StateController.error(errorMessage: 'Failed to login'));
      }
    } on FirebaseAuthException catch (e, s) {
      Logger().e(e.toString(), error: e, stackTrace: s);
      if (e.code == 'user-not-found') {
        emit(
          StateController.error(errorMessage: 'No user found for that email.'),
        );
      } else if (e.code == 'invalid-email') {
        emit(StateController.error(errorMessage: 'Invalid email address.'));
      } else if (e.code == 'user-disabled') {
        emit(StateController.error(errorMessage: 'User disabled.'));
      } else if (e.code == 'wrong-password') {
        emit(StateController.error(errorMessage: 'Wrong password provided.'));
      } else if (e.code == 'operation-not-allowed') {
        emit(StateController.error(errorMessage: 'Operation not allowed.'));
      } else if (e.code == 'invalid-credential') {
        emit(StateController.error(errorMessage: 'Invalid credential.'));
      } else {
        emit(StateController.error(errorMessage: 'An unknown error occurred.'));
      }
    } catch (e, s) {
      Logger().e(e.toString(), error: e, stackTrace: s);
      emit(StateController.error(errorMessage: 'Failed to login'));
    }
  }
}
