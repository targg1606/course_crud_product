import 'dart:convert';

import 'package:course_crud_product/page/home_page.dart';
import 'package:course_crud_product/page/register_page.dart';
import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();

  Login(BuildContext context) async {
    String url = 'http://192.168.1.6/course_api_crud_product/user/login.php';
    var response = await http.post(Uri.parse(url), body: {
      'username': controllerUsername.text,
      'password': controllerPassword.text,
    });
    Map responseBody = jsonDecode(response.body);
    if (responseBody['success']) {
      DInfo.toastSuccess('Success Login');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      DInfo.toastError('Failed Login');
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
            DView.textTitle('Login Page'),
            SizedBox(height: 20),
            DInput(controller: controllerUsername, hint: 'Username'),
            SizedBox(height: 20),
            DInput(controller: controllerPassword, hint: 'Password'),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Login(context),
                child: Text('Login'),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
