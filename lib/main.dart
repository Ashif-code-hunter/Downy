import 'package:downy/core/services/injection_container.dart';
import 'package:downy/features/home/presentation/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/const/go_routing_routes.dart';
import 'core/providers/bloc_providers.dart';
import 'features/home/data/datasources/local_datasource/video_data_local_datasource.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await VideoDataDao.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providersList,
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp.router(
          routerConfig: goRoute,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity
          ),
        ),
      ),
    );
  }
}

