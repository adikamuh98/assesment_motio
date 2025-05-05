import 'package:assesment_motio/core/helper/snackbar_helper.dart';
import 'package:assesment_motio/core/services/hive_service.dart';
import 'package:assesment_motio/core/themes/app_colors.dart';
import 'package:assesment_motio/features/home/data/datasources/task_datasource.dart';
import 'package:assesment_motio/features/home/domain/repositories/task_repository.dart';
import 'package:assesment_motio/features/home/domain/usecases/add_group.dart';
import 'package:assesment_motio/features/home/domain/usecases/delete_group.dart';
import 'package:assesment_motio/features/home/domain/usecases/get_all_groups.dart';
import 'package:assesment_motio/features/home/domain/usecases/update_group.dart';
import 'package:assesment_motio/features/home/presentation/bloc/auth_bloc.dart';
import 'package:assesment_motio/features/home/presentation/home_screen.dart';
import 'package:assesment_motio/features/login/data/datasources/login_datasource.dart';
import 'package:assesment_motio/features/login/domain/repositories/login_repository.dart';
import 'package:assesment_motio/features/login/domain/usecases/login_firebase.dart';
import 'package:assesment_motio/features/login/presentations/login_screen.dart';
import 'package:assesment_motio/features/signup/data/datasources/signup_datasource.dart';
import 'package:assesment_motio/features/signup/domain/repositories/signup_repository.dart';
import 'package:assesment_motio/features/signup/domain/usecases/signup_firebase.dart';
import 'package:assesment_motio/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveService.instance.init();

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc()..add(Init());
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: _repositories(),
      child: MultiRepositoryProvider(
        providers: _usecases(),
        child: MultiBlocProvider(
          providers: _blocs(),
          child: GlobalLoaderOverlay(
            overlayColor: appColors.black.withValues(alpha: 0.4),
            overlayWidgetBuilder: (progress) {
              return Center(
                child: CircularProgressIndicator(color: appColors.primary),
              );
            },
            child: MaterialApp(
              navigatorKey: navState,
              home: BlocConsumer<AuthBloc, AuthState>(
                bloc: _authBloc,
                listener: (context, state) {
                  if (state is AuthError) {
                    SnackbarHelper.error(message: state.message);
                  }

                  if (state is AuthLoading) {
                    context.loaderOverlay.show();
                  } else {
                    context.loaderOverlay.hide();
                  }
                },
                builder: (context, state) {
                  return Scaffold(
                    body:
                        state is LoggedIn
                            ? const HomeScreen()
                            : const LoginScreen(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<RepositoryProvider> _repositories() {
    return [
      RepositoryProvider<SignupRepository>(
        create: (context) => SignupRepository(datasource: SignupDatasource()),
      ),
      RepositoryProvider<LoginRepository>(
        create: (context) => LoginRepository(datasource: LoginDatasource()),
      ),
      RepositoryProvider<TaskRepository>(
        create: (context) => TaskRepository(datasource: TaskDatasource()),
      ),
    ];
  }

  List<RepositoryProvider> _usecases() {
    return [
      RepositoryProvider<SignupFirebase>(
        create: (context) => SignupFirebase(context.read<SignupRepository>()),
      ),
      RepositoryProvider<LoginFirebase>(
        create: (context) => LoginFirebase(context.read<LoginRepository>()),
      ),
      RepositoryProvider<GetAllGroups>(
        create: (context) => GetAllGroups(context.read<TaskRepository>()),
      ),
      RepositoryProvider<AddGroup>(
        create: (context) => AddGroup(context.read<TaskRepository>()),
      ),
      RepositoryProvider<UpdateGroup>(
        create: (context) => UpdateGroup(context.read<TaskRepository>()),
      ),
      RepositoryProvider<DeleteGroup>(
        create: (context) => DeleteGroup(context.read<TaskRepository>()),
      ),
    ];
  }

  List<BlocProvider> _blocs() {
    return [BlocProvider<AuthBloc>.value(value: _authBloc)];
  }
}
