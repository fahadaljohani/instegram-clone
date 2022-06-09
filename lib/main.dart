import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instegram_clone/providers/user_provider.dart';
import 'package:instegram_clone/responsive_layout/responsive_layout_screen.dart';
import 'package:instegram_clone/screens/login_screen.dart';
import 'package:instegram_clone/screens/sign_up.dart';
import 'package:instegram_clone/utils/colors.dart';
import 'package:instegram_clone/utils/utils.dart';
import 'package:provider/provider.dart';
import 'responsive_layout/mobile_layout_screen.dart';
import 'responsive_layout/web_layout_screen.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAMPkTA_Q1RD5wXWotkkGsP9wwHzFxM1uE',
          appId: '1:640928929230:web:d0cb77876b8aa8c7dac79f',
          messagingSenderId: '640928929230',
          projectId: 'flutterinstegramclone',
          storageBucket: 'flutterinstegramclone.appspot.com'),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileLayout: MobileScreenLayouts(),
                  webLayout: WebScreenLayout(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
