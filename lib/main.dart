import 'package:flutter/material.dart';
import 'package:math_app/data/repository_impl/local__store_repository.dart';
import 'package:math_app/data/repository_impl/repository_impl.dart';
import 'package:math_app/presentation/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = LocalStoreRepository(ref: await SharedPreferences.getInstance());
  runApp(MyApp(pref: pref));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.pref});
  final LocalStoreRepository pref;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(repository: Repository(), pref: pref),
    );
  }
}
