import 'package:flutter/material.dart';
import '../models/app_user.dart';
import 'add_invoice_screen.dart';
import 'review_invoice_screen.dart';
import 'invoice_archive_screen.dart';
import 'clients_screen.dart';
import 'add_user_screen.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final AppUser currentUser;

  HomeScreen({required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الرئيسية - ${currentUser.name}'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // 1. رفع فاتورة جديدة (متاح لجميع المستخدمين)
          Card(
            child: ListTile(
              leading: Icon(Icons.note_add, color: Colors.blue),
              title: Text('رفع فاتورة جديدة (موانئ / جمارك)'),
              subtitle: Text('تُحفظ كمسودة بانتظار اعتماد المدير'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddInvoiceScreen(currentUser: currentUser)),
                );
              },
            ),
          ),

          // 2. أدوات المدير (اعتماد العمليات وإنشاء الموظفين)
          if (currentUser.role == 'manager') ...[
            Divider(),
            Text('صلاحيات المدير', style: TextStyle(fontWeight: FontWeight.bold)),
            Card(
              color: Colors.amber.shade50,
              child: ListTile(
                leading: Icon(Icons.verified_user, color: Colors.orange),
                title: Text('اعتماد الفواتير والعملاء المعلقين'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReviewInvoiceScreen()),
                  );
                },
              ),
            ),
            Card(
              color: Colors.blue.shade50,
              child: ListTile(
                leading: Icon(Icons.person_add, color: Colors.blue),
                title: Text('إضافة موظف / يوزر جديد'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddUserScreen()),
                  );
                },
              ),
            ),
          ],

          // 3. أدوات قسم الفواتير والمدير (استعراض وتعديل الأرشيف والعملاء)
          if (currentUser.role == 'billing_user' || currentUser.role == 'manager') ...[
            Divider(),
            Text('قسم الفواتير والعملاء', style: TextStyle(fontWeight: FontWeight.bold)),
            Card(
              child: ListTile(
                leading: Icon(Icons.inventory, color: Colors.green),
                title: Text('أرشيف الفواتير المعتمدة والتعديل'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => InvoiceArchiveScreen()),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.people, color: Colors.purple),
                title: Text('قائمة العملاء المعتمدين'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ClientsScreen()),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

