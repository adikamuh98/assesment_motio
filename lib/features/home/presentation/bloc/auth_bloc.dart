import 'package:assesment_motio/core/services/hive_service.dart';
import 'package:assesment_motio/core/services/storage_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

abstract class AuthEvent extends Equatable {}

class Init extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class Logout extends AuthEvent {
  @override
  List<Object?> get props => [];
}

abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class LoggedIn extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoggedOut extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<Init>((event, emit) async {
      try {
        emit(AuthLoading());

        final isLoggedIn =
            ((await SecureStorageService.instance.readSecureData(
                      SecureKey.token,
                    )) ??
                    '')
                .isNotEmpty;

        if (isLoggedIn) {
          emit(LoggedIn());
        } else {
          emit(LoggedOut());
        }
      } catch (e, s) {
        Logger().e(e.toString(), error: e, stackTrace: s);
      }
    });

    on<Logout>((event, emit) async {
      try {
        emit(AuthLoading());
        await SecureStorageService.instance.deleteAllSecureData();
        await HiveService.instance.clearAll();
        emit(LoggedOut());
      } catch (e, s) {
        Logger().e(e.toString(), error: e, stackTrace: s);
        emit(AuthError('Failed to logout'));
      }
    });
  }
}
