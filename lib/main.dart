import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_application/provider/theme_provider.dart';
import 'package:weather_application/splash_screen.dart';
import 'package:weather_application/theme/theme.dart';


void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode=ref.watch(themenotifierprovider);
    return MaterialApp(
      theme: lighttheme,
      darkTheme: darktheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      
      home: const SplashScreen(),
    );
  }
}


//api:1f135bb660eb45d28da91507261003
