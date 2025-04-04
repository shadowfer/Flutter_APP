// Importaciones necesarias
import 'package:cloud_firestore/cloud_firestore.dart'; // Para interactuar con Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Para autenticación
import 'package:restaurante__app/model/burger_model.dart'; // Modelo de hamburguesas
import 'package:restaurante__app/model/cart_item_model.dart'; // Modelo de carrito
import 'package:restaurante__app/model/category_model.dart'; // Modelo de categorías
import 'package:restaurante__app/model/chinese_model.dart'; // Modelo de comida china
import 'package:restaurante__app/model/mexican_model.dart'; // Modelo de comida mexicana
import 'package:restaurante__app/model/pizza_model.dart'; // Modelo de pizzas
import 'package:restaurante__app/service/burger_data.dart';
import 'package:restaurante__app/service/category_data.dart';
import 'package:restaurante__app/service/chinese_data.dart';
import 'package:restaurante__app/service/mexican_data.dart';
import 'package:restaurante__app/service/pizza_data.dart';
import 'package:uuid/uuid.dart'; // Para generar IDs únicos

// Clase para manejar todas las operaciones de base de datos
class DatabaseService {
  // Instancia de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Instancia de Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  // Método para crear una nueva orden (para checkout)
  Future<String?> createOrder({
    required List<CartItemModel> items,
    required double total,
    required String paymentMethodId,
    String? address,
    String? notes,
  }) async {
    if (_auth.currentUser == null) return null;

    try {
      // Generar un ID único para la orden
      String orderId = const Uuid().v4();

      // Crear el mapa de datos de la orden
      Map<String, dynamic> orderData = {
        'id': orderId,
        'userId': _auth.currentUser!.uid,
        'items': items.map((item) => item.toMap()).toList(),
        'total': total,
        'paymentMethodId': paymentMethodId,
        'address': address ?? '',
        'notes': notes ?? '',
        'status': 'pending', // pending, processing, delivered, cancelled
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Guardar la orden en Firestore
      await _firestore.collection('orders').doc(orderId).set(orderData);

      // Actualizar el historial de órdenes del usuario
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('orders')
          .doc(orderId)
          .set(orderData);

      return orderId;
    } catch (e) {
      print('Error al crear la orden: $e');
      return null;
    }
  }

  // Método para inicializar la base de datos con datos locales
  Future<void> initializeFirestoreWithLocalData() async {
    try {
      print('Iniciando la carga de datos locales a Firestore...');

      // Obtener datos locales
      final localCategories = getCategories();
      final localPizzas = getPizza();
      final localBurgers = getburger();
      final localChinese = getChinese();
      final localMexican = getMexican();

      // Verificar si las colecciones ya tienen datos
      final pizzasSnapshot =
          await _firestore.collection('pizzas').limit(1).get();
      final burgersSnapshot =
          await _firestore.collection('burgers').limit(1).get();
      final chineseSnapshot =
          await _firestore.collection('chinese').limit(1).get();
      final mexicanSnapshot =
          await _firestore.collection('mexican').limit(1).get();
      final categoriesSnapshot =
          await _firestore.collection('categories').limit(1).get();

      // Subir categorías si no existen
      if (categoriesSnapshot.docs.isEmpty) {
        print('Subiendo categorías a Firestore...');
        for (var category in localCategories) {
          await _firestore.collection('categories').add({
            'name': category.name,
            'image': category.image,
          });
        }
        print('Categorías subidas exitosamente.');
      } else {
        print('Las categorías ya existen en Firestore.');
      }

      // Subir pizzas si no existen
      if (pizzasSnapshot.docs.isEmpty) {
        print('Subiendo pizzas a Firestore...');
        for (var pizza in localPizzas) {
          await _firestore.collection('pizzas').add({
            'name': pizza.name,
            'image': pizza.image,
            'price': pizza.price,
            'description': pizza.description ?? 'Deliciosa pizza',
            'available': true,
          });
        }
        print('Pizzas subidas exitosamente.');
      } else {
        print('Las pizzas ya existen en Firestore.');
      }

      // Subir hamburguesas si no existen
      if (burgersSnapshot.docs.isEmpty) {
        print('Subiendo hamburguesas a Firestore...');
        for (var burger in localBurgers) {
          await _firestore.collection('burgers').add({
            'name': burger.name,
            'image': burger.image,
            'price': burger.price,
            'description': burger.description ?? 'Deliciosa hamburguesa',
            'available': true,
          });
        }
        print('Hamburguesas subidas exitosamente.');
      } else {
        print('Las hamburguesas ya existen en Firestore.');
      }

      // Subir comida china si no existe
      if (chineseSnapshot.docs.isEmpty) {
        print('Subiendo comida china a Firestore...');
        for (var item in localChinese) {
          await _firestore.collection('chinese').add({
            'name': item.name,
            'image': item.image,
            'price': item.price,
            'description': item.description ?? 'Deliciosa comida china',
            'available': true,
          });
        }
        print('Comida china subida exitosamente.');
      } else {
        print('La comida china ya existe en Firestore.');
      }

      // Subir comida mexicana si no existe
      if (mexicanSnapshot.docs.isEmpty) {
        print('Subiendo comida mexicana a Firestore...');
        for (var item in localMexican) {
          await _firestore.collection('mexican').add({
            'name': item.name,
            'image': item.image,
            'price': item.price,
            'description': item.description ?? 'Deliciosa comida mexicana',
            'available': true,
          });
        }
        print('Comida mexicana subida exitosamente.');
      } else {
        print('La comida mexicana ya existe en Firestore.');
      }

      print('Inicialización de Firestore completada.');
    } catch (e) {
      print('Error al inicializar Firestore con datos locales: $e');
    }
  }
}
