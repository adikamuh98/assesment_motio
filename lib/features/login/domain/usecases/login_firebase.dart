import 'package:assesment_motio/features/login/data/models/login_request.dart';
import 'package:assesment_motio/features/login/domain/repositories/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginFirebase {
  final LoginRepository repository;
  LoginFirebase(this.repository);

  Future<UserCredential> call(LoginRequest request) async {
    return await repository.loginFirebase(request);
  }
}
