import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _authService.addListener(_onAuthChange);
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthChange);
    super.dispose();
  }

  void _onAuthChange() {
    setState(() {});
  }

  void _showLoginDialog() {
    final TextEditingController passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Admin Login'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              hintText: 'Enter admin password',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final success = _authService.login(passwordController.text);
                Navigator.of(context).pop();
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged in as Admin')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid Password')),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Ronde Yan',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('Inquiry'),
        ),
        const SizedBox(width: 8),
        if (_authService.isAdmin)
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cms');
            },
            child: const Text('CMS'),
          ),
        if (_authService.isAdmin) const SizedBox(width: 8),
        TextButton(
          onPressed: () {
            if (_authService.isAdmin) {
              _authService.logout();
            } else {
              _showLoginDialog();
            }
          },
          child: Text(_authService.isAdmin ? 'Sign Out' : 'Sign In'),
        ),
        const SizedBox(width: 8),
        if (!_authService.isAdmin)
          ElevatedButton(
            onPressed: () {},
            child: const Text('Register'),
          ),
        const SizedBox(width: 16),
      ],
    );
  }
}
