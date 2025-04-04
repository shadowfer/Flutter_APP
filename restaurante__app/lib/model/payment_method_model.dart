import 'package:uuid/uuid.dart';

class PaymentMethodModel {
  final String id;
  final String type; // 'card', 'paypal', etc.
  final String name;
  final String cardNumber;
  final String expiryDate;
  final bool isDefault;
  final String icon;

  PaymentMethodModel({
    String? id,
    required this.type,
    required this.name,
    required this.cardNumber,
    required this.expiryDate,
    this.isDefault = false,
    required this.icon,
  }) : id = id ?? const Uuid().v4();

  // Método para convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'isDefault': isDefault,
      'icon': icon,
    };
  }

  // Método para crear desde Map de Firestore
  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      id: map['id'],
      type: map['type'] ?? '',
      name: map['name'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      isDefault: map['isDefault'] ?? false,
      icon: map['icon'] ?? 'images/card.png',
    );
  }

  // Método para crear una copia con cambios
  PaymentMethodModel copyWith({
    String? id,
    String? type,
    String? name,
    String? cardNumber,
    String? expiryDate,
    bool? isDefault,
    String? icon,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      isDefault: isDefault ?? this.isDefault,
      icon: icon ?? this.icon,
    );
  }
}
