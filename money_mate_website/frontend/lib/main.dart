import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // WAJIB: Inisialisasi Firebase dulu
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBMnZhaaB5rg-MPeBzas8o-8JTlyWzToZ8",
      authDomain: "money-mate-mobile.firebaseapp.com",
      projectId: "money-mate-mobile",
      storageBucket: "money-mate-mobile.firebasestorage.app",
      messagingSenderId: "782965043473",
      appId: "1:782965043473:web:8e8f9269958539dc0b5cb0",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Tambahkan designSize, ini WAJIB
      designSize: Size(360, 690), // atau sesuai ukuran rancangmu
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: "Application",
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
