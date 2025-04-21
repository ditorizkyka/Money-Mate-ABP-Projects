import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:money_mate_mobile/app/data/model/user.dart';
import 'package:money_mate_mobile/app/shared/constanta.dart';
import 'package:money_mate_mobile/app/data/model/user.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // var appDocumentDirectory = await getApplicationDocumentsDirectory();
  // Hive.init(appDocumentDirectory.path);
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  box = await Hive.openBox('userBox');

  bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);
  await dotenv.load(fileName: "assets/config/.env");
  var initialRoute = isLoggedIn ? '/dashboard' : '/signin';
  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Application",
            initialRoute: initialRoute,
            getPages: AppPages.routes,
          ),
    ),
  );
}
