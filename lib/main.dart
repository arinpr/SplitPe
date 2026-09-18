import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_info.dart';
import 'theme/app_theme.dart';
import 'views/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const SplitPeeApp());
}

class SplitPeeApp extends StatelessWidget {
  const SplitPeeApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: AppInfo.name,
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    themeMode: ThemeMode.light,
    home: const HomeScreen(),
  );
}
