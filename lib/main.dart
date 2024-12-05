import 'package:flutter/material.dart';
import './screens/sign_in_screen.dart';


GlobalKey<FormState> singupFormKey = GlobalKey<FormState>();
GlobalKey<FormState> singinFormKey = GlobalKey<FormState>();

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Повідомлення'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Закриває діалогове вікно
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}


void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      home:  SignInScreen(),
    );
  }
}

