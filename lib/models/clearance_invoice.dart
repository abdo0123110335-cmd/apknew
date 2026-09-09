class ClearanceInvoice {
  final String id;
  final String clientId;
  final String clientName;
  final double amount;
  final String invoiceType; // 'موانئ', 'جمارك', إلخ
  final String status; // 'draft' أو 'approved'
  final String createdByUid;
  final DateTime createdAt;

  ClearanceInvoice({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.amount,
    required this.invoiceType,
    required this.status,
    required this.createdByUid,
    required this.createdAt,
  });

  factory ClearanceInvoice.fromMap(Map<String, dynamic> map, String id) {
    return ClearanceInvoice(
      id: id,
      clientId: map['clientId'] ?? '',
      clientName: map['clientName'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      invoiceType: map['invoiceType'] ?? 'عام',
      status: map['status'] ?? 'draft',
      createdByUid: map['createdByUid'] ?? '',
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'clientName': clientName,
      'amount': amount,
      'invoiceType': invoiceType,
      'status': status,
      'createdByUid': createdByUid,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

