import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/app/routes/app_routes.dart';
import 'package:rider_app/app/routes/routes.dart';
import 'package:rider_app/app/ui/controllers/widgets_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CambiaVisible()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conecta Firestore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      initialRoute: Routes.home,
      routes: appRoutes,
    );
  }
}
