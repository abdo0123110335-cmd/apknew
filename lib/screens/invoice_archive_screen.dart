import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/clearance_invoice.dart';
import 'invoice_detail_screen.dart';

class InvoiceArchiveScreen extends StatelessWidget {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('أرشيف الفواتير المعتمدة')),
      body: StreamBuilder<List<ClearanceInvoice>>(
        stream: _dbService.getApprovedInvoices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final invoices = snapshot.data ?? [];
          if (invoices.isEmpty) {
            return Center(child: Text('لا توجد فواتير معتمدة حتى الآن'));
          }

          return ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return ListTile(
                title: Text(invoice.clientName),
                subtitle: Text('${invoice.invoiceType} - المبلغ: ${invoice.amount}'),
                trailing: Icon(Icons.edit),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InvoiceDetailScreen(invoice: invoice),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

