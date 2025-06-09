import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timiplan/Widgets/bottom_navigation.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor:
          Colors
              .transparent, // Set to transparent if you want your app bar or background to show
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(ExpensesAppTracker());
}

class ExpensesAppTracker extends StatelessWidget {
  const ExpensesAppTracker({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TimiPlan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MainNavigation(),
    );   
  }
}
