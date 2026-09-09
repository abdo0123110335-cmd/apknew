import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/client.dart';

class ClientsScreen extends StatelessWidget {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('قائمة العملاء المعتمدين')),
      body: StreamBuilder<List<Client>>(
        stream: _dbService.getApprovedClients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final clients = snapshot.data ?? [];
          if (clients.isEmpty) {
            return Center(child: Text('لا يوجد عملاء معتمدون حتى الآن'));
          }

          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];
              return ListTile(
                leading: CircleAvatar(child: Text(client.name[0])),
                title: Text(client.name),
                subtitle: Text('الهاتف: ${client.phone}'),
              );
            },
          );
        },
      ),
    );
  }
}

