// Importaciones para autenticación y base de datos de Firebase
import 'package:firebase_auth/firebase_auth.dart'; // Para autenticación de usuarios
import 'package:cloud_firestore/cloud_firestore.dart'; // Para almacenamiento de datos

// Clase que maneja todas las operaciones de autenticación
class AuthService {
  // Instancia del servicio de autenticación de Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Instancia de Firestore para almacenar datos adicionales del usuario
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream que proporciona actualizaciones sobre el estado de autenticación del usuario
  Stream<User?> get user => _auth.authStateChanges();

  // Método para registrar un nuevo usuario con email y contraseña
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      // Crea el usuario en Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guarda información adicional del usuario en Firestore
      // Crea un documento con el ID del usuario y añade sus datos
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': Timestamp.now(), // Añade timestamp de creación
      });

      return userCredential; // Devuelve las credenciales del usuario
    } on FirebaseAuthException catch (e) {
      // Manejo de errores de Firebase Auth
      print('Error en el registro: ${e.message}');
      rethrow; // Relanza la excepción para manejarla en la UI
    }
  }

  // Método para iniciar sesión con email y contraseña
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Intenta autenticar al usuario con Firebase
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Manejo de errores de inicio de sesión
      print('Error en el inicio de sesión: ${e.message}');
      rethrow; // Relanza la excepción para manejarla en la UI
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Método para enviar email de recuperación de contraseña
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
