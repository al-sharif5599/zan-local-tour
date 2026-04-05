import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  UserRole? _role = UserRole.local;
  String _language = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            DropdownButton<UserRole>(
              value: _role,
              items: UserRole.values
                  .map(
                    (r) => DropdownMenuItem(
                      value: r,
                      child: Text(r.toString().split('.').last.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _role = v!),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _language,
              items: ['en', 'sw']
                  .map(
                    (l) => DropdownMenuItem(
                      value: l,
                      child: Text(l.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _language = v!),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                Provider.of<AuthProvider>(context, listen: false).register(
                  _emailController.text,
                  _passController.text,
                  _role!.toString().split('.').last,
                  _language,
                );
                Navigator.pop(context);
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
