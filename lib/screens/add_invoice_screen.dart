import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/app_user.dart';

class AddInvoiceScreen extends StatefulWidget {
  final AppUser currentUser;

  AddInvoiceScreen({required this.currentUser});

  @override
  _AddInvoiceScreenState createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbService = DatabaseService();

  String clientName = '';
  String clientPhone = '';
  double amount = 0.0;
  String invoiceType = 'موانئ';
  bool isLoading = false;

  void _saveInvoice() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);

    try {
      await _dbService.addInvoice(
        clientName: clientName,
        clientPhone: clientPhone,
        amount: amount,
        invoiceType: invoiceType,
        userUid: widget.currentUser.uid,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم رفع الفاتورة كمسودة، بانتظار موافقة المدير')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء الرفع: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('رفع فاتورة جديدة')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'اسم العميل'),
                validator: (val) => val!.isEmpty ? 'يرجى إدخال اسم العميل' : null,
                onSaved: (val) => clientName = val!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'رقم هاتف العميل'),
                keyboardType: TextInputType.phone,
                onSaved: (val) => clientPhone = val ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'المبلغ'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'يرجى إدخال المبلغ' : null,
                onSaved: (val) => amount = double.parse(val!),
              ),
              DropdownButtonFormField<String>(
                value: invoiceType,
                decoration: InputDecoration(labelText: 'نوع الفاتورة'),
                items: ['موانئ', 'جمارك', 'خدمات أخرى'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (val) => setState(() => invoiceType = val!),
              ),
              SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveInvoice,
                      child: Text('حفظ ورفع الفاتورة'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

