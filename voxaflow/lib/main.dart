import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxflow/app_provider.dart';
import 'package:voxflow/bloc_providers.dart';
import 'package:voxflow/core/theme/app_theme.dart';
import 'package:voxflow/injection.dart' as di;
import 'package:voxflow/routes/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setUpLocator();

  runApp(
    ProviderScope(
      child: MultiBlocProvider(
        providers: appBlocProviders,
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Vox Flow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
      //  builder: (context, child) {
      //     return DeviceFrame(
      //       device: Devices.android.samsungGalaxyNote20,
      //       screen: child!, // GoRouter already generates this child
      //     );
      //   },
    );
  }
}