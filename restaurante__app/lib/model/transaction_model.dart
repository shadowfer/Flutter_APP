import 'package:uuid/uuid.dart';

class TransactionModel {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final String type; // 'payment', 'refund', etc.
  final String status; // 'completed', 'pending', 'failed'
  final String? orderId;
  final String? paymentMethodId;

  TransactionModel({
    String? id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
    this.orderId,
    this.paymentMethodId,
  }) : id = id ?? const Uuid().v4();

  // Método para convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
      'status': status,
      'orderId': orderId,
      'paymentMethodId': paymentMethodId,
    };
  }

  // Método para crear desde Map de Firestore
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      amount: (map['amount'] is num) ? map['amount'].toDouble() : 0.0,
      date: map['date'] != null
          ? (map['date'] is String
              ? DateTime.parse(map['date'])
              : (map['date'] as DateTime))
          : DateTime.now(),
      type: map['type'] ?? '',
      status: map['status'] ?? '',
      orderId: map['orderId'],
      paymentMethodId: map['paymentMethodId'],
    );
  }
}
