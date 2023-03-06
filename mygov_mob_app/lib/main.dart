import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mygov_mob_app/component/Transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyGov Login',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
        // style the backgroud color of the app
      home:  LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Login to MyGov',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              const SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await authentication(context,_emailController.text, _passwordController.text);

                  },
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  // TODO: Implement forgot password logic
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> authentication(BuildContext context,String email,String password) async {
  // Do some async work that requires the BuildContext
  final result = await login(email, password);

  // Use the context
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Result: $result'),
  ));
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TransactionScreen()),
  );

  return result;
}

Future<dynamic> login(String email, String password) async {
  final url = Uri.parse('http://192.168.9.104:8081/api/auth/login');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );
  Map<String, dynamic> data = jsonDecode(response.body);
  return data;
}

