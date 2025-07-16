import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'core/data/repos/services/hive_storage_service.dart';
import 'core/utils/app_theme.dart';
import 'core/utils/get_it_instance.dart';
import 'firebase_options.dart';
import 'presentation/router/router.dart';
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDependencies();
  await HiveStorageService.init();
//   getIt.get<SharedPrefRepository>().clearAllData();
  /* getIt.get<SharedPrefRepository>().clearAllData();
  Hive.deleteBoxFromDisk(HiveConstants.partyBox);
  Hive.deleteBoxFromDisk(HiveConstants.companyBox);
  Hive.deleteBoxFromDisk(HiveConstants.userBox);
  Hive.deleteBoxFromDisk(HiveConstants.dayBookBox);
  Hive.deleteBoxFromDisk(HiveConstants.invoiceBox);
  Hive.deleteBoxFromDisk(HiveConstants.receiptBox);
  Hive.deleteBoxFromDisk(HiveConstants.notesBox);
  Hive.deleteBoxFromDisk(HiveConstants.itemBox);
  Hive.deleteBoxFromDisk(HiveConstants.dashboardDataBox);
  Hive.deleteBoxFromDisk(HiveConstants.fileMetadataBox); */
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, mode, __) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling,
              ),
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                themeMode: mode,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                routeInformationParser: AppRouter.router.routeInformationParser,
                routerDelegate: AppRouter.router.routerDelegate,
                routeInformationProvider:
                AppRouter.router.routeInformationProvider,
              ),
            );
          },
        );
      },
    );
  }
}
