import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_frame/device_frame.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/app/routes/app_router.dart';
import 'package:pupilica_hackathon/core/helpers/local_storage_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize LocalStorageHelper
  await LocalStorageHelper.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp.router(
      title: 'Pupilica AI Hackathon',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: OsmeaColors.nordicBlue),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );

    // Show iPhone frame only on web
    if (kIsWeb) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: DeviceFrame(device: Devices.ios.iPhone13, screen: app),
      );
    }

    return app;
  }
}
