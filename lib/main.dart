import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:wpp/Views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      title: 'Waifu Wallpaper',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
