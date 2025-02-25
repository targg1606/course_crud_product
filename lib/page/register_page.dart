import 'dart:convert';

import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final controllerUsername = TextEditingController();

  final controllerPassword = TextEditingController();

  Register(BuildContext context) async {
    String url = 'http://192.168.1.6/course_api_crud_product/user/register.php';
    var response = await http.post(Uri.parse(url), body: {
      'username': controllerUsername.text,
      'password': controllerPassword.text,
    });
    Map responseBody = jsonDecode(response.body);
    if (responseBody['success']) {
      DInfo.toastSuccess('Success Register');
    } else {
      if (responseBody['message'] == 'username') {
        DInfo.toastError('Username has already exist');
      } else {
        DInfo.toastError('Failed Register');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DView.textTitle('Register Page'),
            SizedBox(height: 20),
            DInput(controller: controllerUsername, hint: 'Username'),
            SizedBox(height: 20),
            DInput(controller: controllerPassword, hint: 'Password'),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Register(context),
                child: Text('Register'),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
