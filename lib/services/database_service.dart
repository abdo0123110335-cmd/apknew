import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client.dart';
import '../models/clearance_invoice.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. رفع فاتورة جديدة (تحفظ كـ draft مع العميل إن كان جديداً)
  Future<void> addInvoice({
    required String clientName,
    required String clientPhone,
    required double amount,
    required String invoiceType,
    required String userUid,
  }) async {
    QuerySnapshot clientQuery = await _db
        .collection('clients')
        .where('name', isEqualTo: clientName.trim())
        .limit(1)
        .get();

    String clientId;
    if (clientQuery.docs.isNotEmpty) {
      clientId = clientQuery.docs.first.id;
    } else {
      DocumentReference newClient = await _db.collection('clients').add({
        'name': clientName.trim(),
        'phone': clientPhone.trim(),
        'isApproved': false, // عميل جديد غير معتمد
      });
      clientId = newClient.id;
    }

    await _db.collection('invoices').add({
      'clientId': clientId,
      'clientName': clientName.trim(),
      'amount': amount,
      'invoiceType': invoiceType,
      'status': 'draft', // مسودة بانتظار المدير
      'createdByUid': userUid,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  // 2. جلب الفواتير المعلقة بانتظار موافقة المدير
  Stream<List<ClearanceInvoice>> getPendingInvoices() {
    return _db
        .collection('invoices')
        .where('status', isEqualTo: 'draft')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ClearanceInvoice.fromMap(doc.data(), doc.id))
            .toList());
  }

  // 3. اعتماد الفاتورة والعميل بواسطة المدير
  Future<void> approveInvoiceAndClient(ClearanceInvoice invoice) async {
    await _db.collection('invoices').doc(invoice.id).update({'status': 'approved'});
    await _db.collection('clients').doc(invoice.clientId).update({'isApproved': true});
  }

  // 4. جلب الفواتير المعتمدة (خاص لقسم الفواتير والمدير)
  Stream<List<ClearanceInvoice>> getApprovedInvoices() {
    return _db
        .collection('invoices')
        .where('status', isEqualTo: 'approved')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ClearanceInvoice.fromMap(doc.data(), doc.id))
            .toList());
  }

  // 5. جلب قائمة العملاء المعتمدين فقط
  Stream<List<Client>> getApprovedClients() {
    return _db
        .collection('clients')
        .where('isApproved', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Client.fromMap(doc.data(), doc.id))
            .toList());
  }

  // 6. تعديل الفاتورة (حصرياً لقسم الفواتير والمدير)
  Future<void> updateInvoice(String invoiceId, double newAmount, String invoiceType) async {
    await _db.collection('invoices').doc(invoiceId).update({
      'amount': newAmount,
      'invoiceType': invoiceType,
    });
  }
}

