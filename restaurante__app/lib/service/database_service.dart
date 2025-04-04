// Importaciones necesarias
import 'package:cloud_firestore/cloud_firestore.dart'; // Para interactuar con Firestore
import 'package:restaurante__app/model/burger_model.dart'; // Modelo de hamburguesas
import 'package:restaurante__app/model/category_model.dart'; // Modelo de categorías
import 'package:restaurante__app/model/chinese_model.dart'; // Modelo de comida china
import 'package:restaurante__app/model/mexican_model.dart'; // Modelo de comida mexicana
import 'package:restaurante__app/model/pizza_model.dart'; // Modelo de pizzas

// Clase para manejar todas las operaciones de base de datos
class DatabaseService {
  // Instancia de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener categorías desde Firestore
  Future<List<CategoryModel>> getFirestoreCategories() async {
    try {
      // Consulta la colección 'categories'
      QuerySnapshot snapshot = await _firestore.collection('categories').get();

      // Mapea los documentos a objetos CategoryModel
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CategoryModel(
          name: data['name'] ?? '', // Usa valor vacío si no existe
          image: data['image'] ?? '',
        );
      }).toList();
    } catch (e) {
      // Manejo de errores
      print('Error al obtener categorías: $e');
      return []; // Retorna lista vacía en caso de error
    }
  }

  // Método para obtener pizzas desde Firestore
  Future<List<PizzaModel>> getFirestorePizzas() async {
    try {
      // Consulta la colección 'pizzas'
      QuerySnapshot snapshot = await _firestore.collection('pizzas').get();

      // Mapea los documentos a objetos PizzaModel
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
      // Manejo de errores
      print('Error al obtener pizzas: $e');
      return [];
    }
  }

  // Método para obtener hamburguesas desde Firestore
  Future<List<BurgerModel>> getFirestoreBurgers() async {
    try {
      // Consulta la colección 'burgers'
      QuerySnapshot snapshot = await _firestore.collection('burgers').get();

      // Mapea los documentos a objetos BurgerModel
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
      // Manejo de errores
      print('Error al obtener hamburguesas: $e');
      return [];
    }
  }

  // Método para obtener comida china desde Firestore
  Future<List<ChineseModel>> getFirestoreChinese() async {
    try {
      // Consulta la colección 'chinese'
      QuerySnapshot snapshot = await _firestore.collection('chinese').get();

      // Mapea los documentos a objetos ChineseModel
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
      // Manejo de errores
      print('Error al obtener comida china: $e');
      return [];
    }
  }

  // Método para obtener comida mexicana desde Firestore
  Future<List<MexicanModel>> getFirestoreMexican() async {
    try {
      // Consulta la colección 'mexican'
      QuerySnapshot snapshot = await _firestore.collection('mexican').get();

      // Mapea los documentos a objetos MexicanModel
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
      // Manejo de errores
      print('Error al obtener comida mexicana: $e');
      return [];
    }
  }

  // Método para guardar un pedido en Firestore
  Future<void> saveOrder(String userId, Map<String, dynamic> orderData) async {
    try {
      // Guarda el pedido en la colección 'orders' con un ID autogenerado
      await _firestore.collection('orders').add({
        'userId': userId, // ID del usuario que hace el pedido
        'orderData': orderData, // Datos del pedido
        'timestamp': FieldValue.serverTimestamp(), // Timestamp del servidor
      });
    } catch (e) {
      // Manejo de errores
      print('Error al guardar el pedido: $e');
      rethrow; // Relanza la excepción para manejarla en la UI
    }
  }
}
