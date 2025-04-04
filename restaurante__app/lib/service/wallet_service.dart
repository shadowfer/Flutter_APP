import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurante__app/model/payment_method_model.dart';
import 'package:restaurante__app/model/transaction_model.dart';
import 'package:uuid/uuid.dart';

class WalletService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener el ID del usuario actual
  String? get _userId => _auth.currentUser?.uid;

  // Obtener todos los métodos de pago del usuario
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    if (_userId == null) return [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('paymentMethods')
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return PaymentMethodModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error al obtener métodos de pago: $e');
      return [];
    }
  }

  // Añadir un nuevo método de pago
  Future<void> addPaymentMethod(PaymentMethodModel method) async {
    if (_userId == null) return;

    try {
      // Si este es el primer método de pago, hacerlo predeterminado
      bool isDefault = false;
      List<PaymentMethodModel> existingMethods = await getPaymentMethods();
      if (existingMethods.isEmpty) {
        isDefault = true;
      }

      // Crear el método de pago con el ID generado
      PaymentMethodModel newMethod = PaymentMethodModel(
        id: method.id,
        type: method.type,
        name: method.name,
        cardNumber: method.cardNumber,
        expiryDate: method.expiryDate,
        isDefault: isDefault || method.isDefault,
        icon: method.icon,
      );

      // Guardar en Firestore
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('paymentMethods')
          .doc(method.id)
          .set(newMethod.toMap());

      // Si este método es predeterminado, actualizar los demás
      if (method.isDefault) {
        await setDefaultPaymentMethod(method.id);
      }
    } catch (e) {
      print('Error al añadir método de pago: $e');
    }
  }

  // Establecer un método de pago como predeterminado
  Future<void> setDefaultPaymentMethod(String methodId) async {
    if (_userId == null) return;

    try {
      // Obtener todos los métodos de pago
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('paymentMethods')
          .get();

      // Actualizar cada método de pago
      for (var doc in snapshot.docs) {
        await doc.reference.update({
          'isDefault': doc.id == methodId,
        });
      }
    } catch (e) {
      print('Error al establecer método predeterminado: $e');
    }
  }

  // Eliminar un método de pago
  Future<void> deletePaymentMethod(String methodId) async {
    if (_userId == null) return;

    try {
      // Verificar si es el método predeterminado
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('paymentMethods')
          .doc(methodId)
          .get();

      bool isDefault =
          (doc.data() as Map<String, dynamic>)['isDefault'] ?? false;

      // Eliminar el método
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('paymentMethods')
          .doc(methodId)
          .delete();

      // Si era el predeterminado, establecer otro como predeterminado
      if (isDefault) {
        QuerySnapshot snapshot = await _firestore
            .collection('users')
            .doc(_userId)
            .collection('paymentMethods')
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          await setDefaultPaymentMethod(snapshot.docs.first.id);
        }
      }
    } catch (e) {
      print('Error al eliminar método de pago: $e');
    }
  }

  // Obtener el historial de transacciones
  Future<List<TransactionModel>> getTransactionHistory() async {
    if (_userId == null) return [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('transactions')
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return TransactionModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error al obtener historial de transacciones: $e');
      return [];
    }
  }

  // Registrar una nueva transacción
  Future<void> addTransaction(TransactionModel transaction) async {
    if (_userId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('transactions')
          .doc(transaction.id)
          .set(transaction.toMap());
    } catch (e) {
      print('Error al añadir transacción: $e');
    }
  }

  // Crear una transacción para un pedido
  Future<TransactionModel> createOrderTransaction({
    required String orderId,
    required double amount,
    required String paymentMethodId,
  }) async {
    // Obtener información del método de pago
    DocumentSnapshot methodDoc = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('paymentMethods')
        .doc(paymentMethodId)
        .get();

    Map<String, dynamic> methodData = methodDoc.data() as Map<String, dynamic>;
    String methodName = methodData['name'] ?? 'Tarjeta';

    // Crear la transacción
    TransactionModel transaction = TransactionModel(
      title: 'Pago de Pedido',
      description: 'Pago realizado con $methodName',
      amount: amount,
      date: DateTime.now(),
      type: 'payment',
      status: 'completed',
      orderId: orderId,
      paymentMethodId: paymentMethodId,
    );

    // Guardar la transacción
    await addTransaction(transaction);

    return transaction;
  }
}
