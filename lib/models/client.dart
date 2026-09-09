class Client {
  final String id;
  final String name;
  final String phone;
  final bool isApproved; // false: مسودة معلقة, true: معتمد

  Client({
    required this.id,
    required this.name,
    required this.phone,
    this.isApproved = false,
  });

  factory Client.fromMap(Map<String, dynamic> map, String id) {
    return Client(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      isApproved: map['isApproved'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'isApproved': isApproved,
    };
  }
}

