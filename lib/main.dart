import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_app/data/repository_impl/local__store_repository.dart';
import 'package:math_app/data/repository_impl/repository_impl.dart';
import 'package:math_app/presentation/screen/home_screen.dart';
import 'package:math_app/presentation/utils/const.dart';
import 'package:math_app/provider/active_theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = LocalStoreRepository(ref: await SharedPreferences.getInstance());
  runApp(ProviderScope(child: MyApp(pref: pref)));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key, required this.pref});
  final LocalStoreRepository pref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(activeThemeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MathTest',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: activeTheme == Themes.dark ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(repository: Repository(), pref: pref),
    );
  }
}
