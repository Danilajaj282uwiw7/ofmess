import 'package:flutter/material.dart';
import '../api_service.dart';
import 'chats_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _isLogin = true;

  void _submit() async {
    try {
      if (_isLogin) {
        await ApiService.login(_userCtrl.text.trim(), _passCtrl.text);
      } else {
        await ApiService.register(_userCtrl.text.trim(), _passCtrl.text, _nameCtrl.text.trim());
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatsScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_isLogin ? 'Вход в OFMess' : 'Регистрация',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(controller: _userCtrl, decoration: const InputDecoration(labelText: 'Логин')),
              TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Пароль')),
              if (!_isLogin) TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Имя')),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text(_isLogin ? 'Войти' : 'Зарегистрироваться')),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin ? 'Создать аккаунт' : 'Уже есть аккаунт'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
