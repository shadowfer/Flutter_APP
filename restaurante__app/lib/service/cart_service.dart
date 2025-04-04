import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurante__app/model/cart_item_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener el ID del usuario actual
  String? get _userId => _auth.currentUser?.uid;

  // Referencia a la colección de carritos
  CollectionReference get _cartsRef => _firestore.collection('carts');

  // Obtener el carrito del usuario actual
  Future<List<CartItemModel>> getUserCart() async {
    if (_userId == null) return [];

    try {
      DocumentSnapshot cartDoc = await _cartsRef.doc(_userId).get();

      if (!cartDoc.exists) return [];

      Map<String, dynamic> cartData = cartDoc.data() as Map<String, dynamic>;
      List<dynamic> items = cartData['items'] ?? [];

      return items.map((item) => CartItemModel.fromMap(item)).toList();
    } catch (e) {
      print('Error al obtener el carrito: $e');
      return [];
    }
  }

  // Añadir un item al carrito
  Future<void> addToCart(CartItemModel item) async {
    if (_userId == null) return;

    try {
      // Obtener el carrito actual
      List<CartItemModel> currentCart = await getUserCart();

      // Verificar si el item ya existe en el carrito
      int existingIndex = currentCart.indexWhere((i) => i.id == item.id);

      if (existingIndex >= 0) {
        // Si existe, incrementar la cantidad
        currentCart[existingIndex].quantity += item.quantity;
      } else {
        // Si no existe, añadirlo
        currentCart.add(item);
      }

      // Guardar el carrito actualizado
      await _cartsRef.doc(_userId).set({
        'items': currentCart.map((item) => item.toMap()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error al añadir al carrito: $e');
    }
  }

  // Actualizar cantidad de un item
  Future<void> updateItemQuantity(String itemId, int newQuantity) async {
    if (_userId == null) return;

    try {
      // Obtener el carrito actual
      List<CartItemModel> currentCart = await getUserCart();

      // Encontrar el item
      int itemIndex = currentCart.indexWhere((item) => item.id == itemId);

      if (itemIndex >= 0) {
        if (newQuantity <= 0) {
          // Si la cantidad es 0 o menos, eliminar el item
          currentCart.removeAt(itemIndex);
        } else {
          // Actualizar la cantidad
          currentCart[itemIndex].quantity = newQuantity;
        }

        // Guardar el carrito actualizado
        await _cartsRef.doc(_userId).set({
          'items': currentCart.map((item) => item.toMap()).toList(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error al actualizar cantidad: $e');
    }
  }

  // Eliminar un item del carrito
  Future<void> removeFromCart(String itemId) async {
    await updateItemQuantity(itemId, 0);
  }

  // Vaciar el carrito
  Future<void> clearCart() async {
    if (_userId == null) return;

    try {
      await _cartsRef.doc(_userId).set({
        'items': [],
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error al vaciar el carrito: $e');
    }
  }

// Calcular el total del carrito
  Future<double> getCartTotal() async {
    List<CartItemModel> cart = await getUserCart();
    double total = 0.0;
    for (var item in cart) {
      total += item.subtotal;
    }
    return total;
  }

// Obtener la cantidad de items en el carrito
  Future<int> getCartItemCount() async {
    List<CartItemModel> cart = await getUserCart();
    int count = 0;
    for (var item in cart) {
      count += item.quantity;
    }
    return count;
  }
}
