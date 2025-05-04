import 'package:assesment_motio/features/signup/data/models/signup_request.dart';
import 'package:assesment_motio/features/signup/domain/repositories/signup_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupFirebase {
  final SignupRepository repository;
  SignupFirebase(this.repository);

  Future<UserCredential> call(SignupRequest request) async {
    return await repository.signupFirebase(request);
  }
}
