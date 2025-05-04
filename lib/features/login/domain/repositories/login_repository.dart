import 'package:assesment_motio/features/login/data/datasources/login_datasource.dart';
import 'package:assesment_motio/features/login/data/models/login_request.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepository {
  final LoginDatasource datasource;

  LoginRepository({required this.datasource});

  Future<UserCredential> loginFirebase(LoginRequest request) async {
    return await datasource.loginFirebase(request);
  }
}
