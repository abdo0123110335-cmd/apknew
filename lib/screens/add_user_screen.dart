import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  String name = '';
  String email = '';
  String password = '';
  String selectedRole = 'entry_user';
  bool isLoading = false;

  final Map<String, String> roles = {
    'entry_user': 'موظف رفع (إدخال فواتير)',
    'billing_user': 'قسم الفواتير (إدارة وتعديل)',
    'manager': 'مدير النظام (اعتماد وإدارة)',
  };

  void _createUser() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);

    try {
      await _authService.createNewUserByManager(
        name: name,
        email: email,
        password: password,
        role: selectedRole,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إنشاء الحساب بنجاح')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء الإنشاء: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إضافة مستخدم جديد')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'اسم الموظف'),
                validator: (val) => val!.isEmpty ? 'يرجى إدخال الاسم' : null,
                onSaved: (val) => name = val!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
                validator: (val) => val!.isEmpty ? 'يرجى إدخال البريد' : null,
                onSaved: (val) => email = val!,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'كلمة المرور'),
                validator: (val) => val!.length < 6 ? 'كلمة المرور 6 أحرف على الأقل' : null,
                onSaved: (val) => password = val!,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: InputDecoration(labelText: 'الصلاحية / القسم'),
                items: roles.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedRole = val!),
              ),
              SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _createUser,
                      child: Text('إنشاء الحساب'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

