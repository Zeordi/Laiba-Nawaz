


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxflow/feature/admin/presentation/state/admin_bloc.dart';
import 'package:voxflow/feature/auth/presentation/state/auth_bloc.dart';
import 'package:voxflow/feature/home/presentation/state/home_bloc.dart';
import 'package:voxflow/feature/profile/presentation/state/profile_bloc.dart';
import 'package:voxflow/feature/submit_task/presentation/state/submit_task_bloc.dart';
import 'package:voxflow/feature/task/presentation/state/task_bloc.dart';
import 'package:voxflow/injection.dart' as di;

final List<BlocProvider> appBlocProviders = [
  BlocProvider<AuthBloc>(create: (context) => di.locator<AuthBloc>(),),
  BlocProvider<ProfileBloc>(create: (context) => di.locator<ProfileBloc>(),),
  BlocProvider<HomeBloc>(create: (context) => di.locator<HomeBloc>(),),
  BlocProvider<TaskBloc>(create: (context) => di.locator<TaskBloc>(),),
  BlocProvider<AdminBloc>(create: (context) => di.locator<AdminBloc>(),),
  BlocProvider<SubmitTaskBloc>(create: (context) => di.locator<SubmitTaskBloc>(),),
];