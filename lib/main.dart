import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_checker/features/checker/view/homepage.dart';
import 'package:ticket_checker/features/checker/view_model/checker_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CheckerViewModel>(
              create: (context) => CheckerViewModel()),
        ],
        builder: (context, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const HomePage(),
          );
        });
  }
}
