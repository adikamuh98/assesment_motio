import 'package:assesment_motio/features/login/data/models/login_request.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginDatasource {
  Future<UserCredential> loginFirebase(LoginRequest request) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: request.email,
          password: request.password,
        );
    return userCredential;
  }
}
