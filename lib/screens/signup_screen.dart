import 'package:flutter/material.dart';
import 'package:kursova/main.dart';
import 'package:kursova/services/database_helper.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(children: [
                Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Google-flutter-logo.svg/1024px-Google-flutter-logo.svg.png",
                  width: 200,
                ),
                const SizedBox(height: 16,),
                Text('Sing up',
                    style: Theme.of(context).textTheme.bodyLarge)]
              ),
            ),
            const SizedBox(height: 16),


            Form(
              key: singupFormKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Name:',
                      style: Theme.of(context).textTheme.bodyLarge
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    validator: (value) => value != null && value.length >= 3 ? null : 'Name must be at least 3 characters',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Email:',
                      style: Theme.of(context).textTheme.bodyLarge
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: emailController,
                    validator: (value) => value != null && value.contains('@') ? null : 'Enter a valid email',
                  ),
                  const SizedBox(height: 16),
                  Text(
                      'Password:',
                      style: Theme.of(context).textTheme.bodyLarge
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    validator: (value) => value != null && value.length >= 7 ? null : 'Password must be at least 7 characters',

                  ),
                  const SizedBox(height: 16),
                ]
            )),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (singupFormKey.currentState?.validate() ?? false) {
                    // Перевіряємо, чи існує користувач з таким email
                    final existingUser = await DatabaseHelper().getUser(emailController.text, passwordController.text);

                    if (existingUser != null) {
                      // Якщо користувач з таким email вже є в базі
                      showErrorDialog(context, 'Цей користувач вже існує');
                    } else {
                      // Якщо користувач не існує, додаємо нового
                      await DatabaseHelper().addUser(nameController.text, emailController.text, passwordController.text);
                      showErrorDialog(context, 'Форма валідна. Користувач доданий.');
                      // Ви можете тут також перенаправити на інший екран чи виконати додаткові дії
                    }
                  } else {
                    // Якщо форма не валідна
                    showErrorDialog(context, 'Будь ласка, заповніть усі поля коректно.');
                  }
                }
                ,

                child: const Text("Sing up"),
              )
            ),
            SizedBox(height: 16,),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => {
                  Navigator.pop(context)
                },
                child: const Text("Back"),
              ),
            )
          ],
        )
      )
    );
  }

}
