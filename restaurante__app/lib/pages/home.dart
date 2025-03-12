import 'package:flutter/material.dart';
import 'package:restaurante__app/model/category_model.dart';
import 'package:restaurante__app/service/category_data.dart';
import 'package:restaurante__app/service/widget_support.dart';

// Clase Home, representa la pantalla principal
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// Estado de la pantalla principal
class _HomeState extends State<Home> {
  // Lista de categorías cargadas desde `category_data.dart`
  List<CategoryModel> categories = [];

  // Variable para rastrear la categoría seleccionada
  String track = "0";

  @override
  void initState() {
    // Carga las categorías al inicializar la pantalla
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
            left: 10.0, top: 10.0), // Margen para no pegarse a los bordes
        child: Column(
          children: [
            // Sección de encabezado con el logo y la imagen de usuario
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo de la app
                    Image.asset(
                      "images/logo.png",
                      width: 100,
                      fit: BoxFit.contain,
                      height: 50.0,
                    ),
                    // Texto debajo del logo
                    Text(
                      "Order your favorite food",
                      style: AppWidget.simpleTextFieldStyle(),
                    ),
                  ],
                ),
                // Imagen del usuario en la esquina superior derecha
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      "images/boy.jpg",
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0), // Espaciado entre secciones

            // Sección de barra de búsqueda
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0),
                    margin: EdgeInsets.only(right: 20.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "¿Qué se te antoja?", // Texto de búsqueda
                      ),
                    ),
                  ),
                ),
                // Icono de búsqueda a la derecha de la barra
                Container(
                  margin: EdgeInsets.only(right: 10.0),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xffef2b39),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0), // Espaciado entre secciones

            // Sección de categorías (horizontal)
            Container(
              height: 70, // Altura del contenedor de categorías
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection:
                    Axis.horizontal, // Para desplazamiento horizontal
                itemCount:
                    categories.length, // Número de categorías disponibles
                itemBuilder: (context, index) {
                  return CategoryTile(
                    categories[index].name!, // Nombre de la categoría
                    categories[index].image!, // Imagen de la categoría
                    index.toString(), // Índice de la categoría
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget que representa cada categoría en la lista
  Widget CategoryTile(String name, String image, String categoryindex) {
    return GestureDetector(
      onTap: () {
        // Actualiza la categoría seleccionada y redibuja el widget
        track = categoryindex.toString();
        setState(() {});
      },
      child: track == categoryindex
          ? Container(
              margin: EdgeInsets.only(right: 10.0, bottom: 10.0),
              child: Material(
                elevation: 3.0, // Agrega sombra para un efecto elevado
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: BoxDecoration(
                    color: Color(0xffef2b39), // Rojo cuando está seleccionada
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      // Imagen de la categoría
                      Image.asset(
                        image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10.0), // Espaciado entre imagen y texto
                      // Nombre de la categoría
                      Text(
                        name,
                        style: AppWidget.whiteTextFieldStyle(),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              margin: EdgeInsets.only(right: 20.0, bottom: 10.0),
              decoration: BoxDecoration(
                color: Color(
                    0xFFececf8), // Color de fondo cuando NO está seleccionada
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: [
                  // Imagen de la categoría
                  Image.asset(
                    image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10.0), // Espaciado entre imagen y texto
                  // Nombre de la categoría
                  Text(
                    name,
                    style: AppWidget.simpleTextFieldStyle(),
                  ),
                ],
              ),
            ),
    );
  }
}

//Continuando con el proyecto 
//No encontre Motivacion , mañana continuo con el proyecto