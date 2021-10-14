import 'package:flutter/material.dart';
import 'package:rider_app/app/routes/routes.dart';
import 'package:rider_app/app/ui/pages/home_page.dart';

Map<String, Widget Function(BuildContext)> get appRoutes => {
      Routes.home: (_) => const HomePage(),
      /*Routes.splash: (_) => const SplashPage(),
      Routes.login: (_) => const LoginPage(),
      Routes.register: (_) => RegisterPage(),*/
    };
