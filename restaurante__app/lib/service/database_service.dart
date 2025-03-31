import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurante__app/model/burger_model.dart';
import 'package:restaurante__app/model/category_model.dart';
import 'package:restaurante__app/model/chinese_model.dart';
import 'package:restaurante__app/model/mexican_model.dart';
import 'package:restaurante__app/model/pizza_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener categorías desde Firestore
  Future<List<CategoryModel>> getFirestoreCategories() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('categories').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CategoryModel(
          name: data['name'] ?? '',
          image: data['image'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error al obtener categorías: $e');
      return [];
    }
  }

  // Obtener pizzas desde Firestore
  Future<List<PizzaModel>> getFirestorePizzas() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('pizzas').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return PizzaModel(
          name: data['name'] ?? '',
          image: data['image'] ?? '',
          price: data['price'] ?? '',
          description: data['description'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error al obtener pizzas: $e');
      return [];
    }
  }

  // Obtener hamburguesas desde Firestore
  Future<List<BurgerModel>> getFirestoreBurgers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('burgers').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return BurgerModel(
          name: data['name'] ?? '',
          image: data['image'] ?? '',
          price: data['price'] ?? '',
          description: data['description'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error al obtener hamburguesas: $e');
      return [];
    }
  }

  // Obtener comida china desde Firestore
  Future<List<ChineseModel>> getFirestoreChinese() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('chinese').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ChineseModel(
          name: data['name'] ?? '',
          image: data['image'] ?? '',
          price: data['price'] ?? '',
          description: data['description'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error al obtener comida china: $e');
      return [];
    }
  }

  // Obtener comida mexicana desde Firestore
  Future<List<MexicanModel>> getFirestoreMexican() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('mexican').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return MexicanModel(
          name: data['name'] ?? '',
          image: data['image'] ?? '',
          price: data['price'] ?? '',
          description: data['description'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error al obtener comida mexicana: $e');
      return [];
    }
  }

  // Guardar un pedido en Firestore
  Future<void> saveOrder(String userId, Map<String, dynamic> orderData) async {
    try {
      await _firestore.collection('orders').add({
        'userId': userId,
        'orderData': orderData,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error al guardar el pedido: $e');
      rethrow;
    }
  }
}