import 'package:flutter/material.dart';
import '../models/clearance_invoice.dart';
import '../services/database_service.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final ClearanceInvoice invoice;

  InvoiceDetailScreen({required this.invoice});

  @override
  _InvoiceDetailScreenState createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  late TextEditingController _amountController;
  final DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.invoice.amount.toString());
  }

  void _updateInvoice() async {
    double? newAmount = double.tryParse(_amountController.text);
    if (newAmount != null) {
      await _dbService.updateInvoice(widget.invoice.id, newAmount, widget.invoice.invoiceType);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تحديث الفاتورة بنجاح')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تعديل فاتورة ${widget.invoice.clientName}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('نوع الفاتورة: ${widget.invoice.invoiceType}'),
            SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'المبلغ'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateInvoice,
              child: Text('حفظ التعديلات'),
            )
          ],
        ),
      ),
    );
  }
}

