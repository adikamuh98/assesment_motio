import 'package:assesment_motio/features/signup/data/datasources/signup_datasource.dart';
import 'package:assesment_motio/features/signup/data/models/signup_request.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupRepository {
  final SignupDatasource datasource;

  SignupRepository({required this.datasource});

  Future<UserCredential> signupFirebase(SignupRequest request) async {
    return await datasource.signupFirebase(request);
  }
}
