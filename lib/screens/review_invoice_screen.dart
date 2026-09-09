import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/clearance_invoice.dart';

class ReviewInvoiceScreen extends StatelessWidget {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('اعتماد الفواتير المعلقة')),
      body: StreamBuilder<List<ClearanceInvoice>>(
        stream: _dbService.getPendingInvoices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final invoices = snapshot.data ?? [];
          if (invoices.isEmpty) {
            return Center(child: Text('لا توجد فواتير معلقة حالياً'));
          }

          return ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('العميل: ${invoice.clientName}'),
                  subtitle: Text('النوع: ${invoice.invoiceType} | المبلغ: ${invoice.amount}'),
                  trailing: ElevatedButton.icon(
                    icon: Icon(Icons.check, color: Colors.white),
                    label: Text('اعتماد'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      await _dbService.approveInvoiceAndClient(invoice);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم اعتماد الفاتورة وتنسيق العميل بنجاح')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

