import 'package:assesment_motio/features/signup/data/models/signup_request.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupDatasource {
  Future<UserCredential> signupFirebase(SignupRequest request) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: request.email,
          password: request.password,
        );
    return userCredential;
  }
}
