import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mackbike/features/navigation/screens/navigation_screen.dart';
import 'package:flutter_mackbike/features/navigation/view_models/navigation_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationViewModel(),
      child: MaterialApp(
        title: 'MackBike',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const NavigationScreen(),
      ),
    );
  }
}
