import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_finder/pages/main_page.dart';
import 'package:movie_finder/pages/splash_page.dart';

void main() {
  runApp(
    SplashPage(
      onInitializationComplete: () {
        return runApp(
          ProviderScope(
            child: MyApp(),
          ),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Movie Finder",
      initialRoute: 'home',
      routes: {
        'home': ((context) => MainPage()),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
