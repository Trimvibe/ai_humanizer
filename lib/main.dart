import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'screens/splash_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/credit_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await CreditService.init();
  
  await Supabase.initialize(
    url: 'https://hugzvgxwmzohuhtvvncj.supabase.co',
    anonKey: 'sb_publishable_AUDro0WSRwBg8-Dqy8a4KA_xynRhXoD',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const HumanFlowApp(),
    ),
  );
}

class HumanFlowApp extends StatelessWidget {
  const HumanFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'HumanFlow AI',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: const SplashScreen(),
        );
      },
    );
  }
}
