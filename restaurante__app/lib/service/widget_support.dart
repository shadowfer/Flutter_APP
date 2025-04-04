// Importa la biblioteca Material para acceder a los widgets y estilos
import 'package:flutter/material.dart';

// Clase que contiene estilos de texto predefinidos para usar en toda la app
class AppWidget {
  // Estilo para títulos principales (headline)
  // Texto negro, tamaño grande y en negrita
  static TextStyle HeadLineTextFieldStyle() {
    return TextStyle(
        color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold);
  }

  // Estilo para texto simple o regular
  // Texto negro con tamaño estándar
  static TextStyle simpleTextFieldStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 18.0,
    );
  }

  // Estilo para texto blanco
  // Útil para botones o sobre fondos oscuros, con negrita
  static TextStyle whiteTextFieldStyle() {
    return TextStyle(
        color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold);
  }

  // Estilo para texto en negrita
  // Negro, tamaño mediano y en negrita
  static TextStyle boldTextFeildStyle() {
    return TextStyle(
        color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold);
  }

  // Estilo para mostrar precios
  // Negro semi-transparente, grande y en negrita
  static TextStyle priceTextFeildStyle() {
    return TextStyle(
        color: const Color.fromARGB(174, 0, 0, 0),
        fontSize: 24.0,
        fontWeight: FontWeight.bold);
  }

  // Estilo para texto blanco grande y en negrita
  // Útil para títulos sobre fondos oscuros
  static TextStyle boldwhiteTextFieldStyle() {
    return TextStyle(
        color: Colors.white, fontSize: 29.0, fontWeight: FontWeight.bold);
  }

  // Estilo específico para formularios de registro
  // Negro semi-transparente, mediano y en negrita
  static TextStyle SignUpTextFeildStyle() {
    return TextStyle(
        color: const Color.fromARGB(174, 0, 0, 0),
        fontSize: 20.0,
        fontWeight: FontWeight.bold);
  }

  // Añade esta función estática
  static String normalizeImagePath(String path) {
    if (path.isEmpty) return '';

    // Reemplaza barras invertidas por barras normales
    String normalized = path.replaceAll('\\', '/');

    // Si la ruta incluye el nombre del proyecto, quítalo
    if (normalized.startsWith('restaurante__app/')) {
      normalized = normalized.replaceFirst('restaurante__app/', '');
    }

    return normalized;
  }
}
