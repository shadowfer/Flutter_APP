/*
 * Archivo principal de la aplicación Flutter para restaurante (FoodGo)
 * Este archivo contiene el punto de entrada de la aplicación y la configuración inicial
 */

// Importaciones necesarias para la aplicación
import 'package:flutter/material.dart'; // Material Design widgets y estilos
import 'package:firebase_core/firebase_core.dart'; // Configuración básica de Firebase
import 'package:restaurante__app/firebase_options.dart'; // Opciones específicas de Firebase para esta app
import 'package:restaurante__app/pages/bottomnav.dart'; // Barra de navegación inferior
import 'package:restaurante__app/pages/detail_page.dart'; // Página de detalles del producto
import 'package:restaurante__app/pages/home.dart'; // Página principal
import 'package:restaurante__app/pages/login.dart'; // Página de inicio de sesión
import 'package:restaurante__app/pages/signup.dart'; // Página de registro
import 'package:restaurante__app/firebase_options.dart'; // Duplicada, podría eliminarse
import 'package:shared_preferences/shared_preferences.dart';

// Función principal que inicia la aplicación
void main() async {
  // Asegura que Flutter esté inicializado antes de usar plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones específicas para la plataforma actual
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Ejecuta la aplicación comenzando con el widget MyApp
  runApp(const MyApp());
}

// Clase principal de la aplicación, define el tema y la navegación inicial
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor que acepta una key opcional

  // Este método construye la interfaz de usuario principal
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          'Flutter Demo', // Título de la aplicación (aparece en el task switcher)
      debugShowCheckedModeBanner:
          false, // Oculta el banner de debug en la esquina
      theme: ThemeData(
        // Define el tema de la aplicación con un esquema de colores morado
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Activa el diseño Material 3
      ),
      home:
          Bottomnav(), // Define la pantalla inicial como la barra de navegación
      // Comentario: Se puede cambiar entre Bottomnav() y HOME/ONBOARDING para pruebas
    );
  }
}

// Clase para una página de inicio con contador (ejemplo incluido por defecto en Flutter)
class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.title}); // Constructor que requiere un título

  // Este widget es la página de inicio de la aplicación
  // Es stateful, lo que significa que tiene un objeto State asociado
  // que contiene los campos que afectan su apariencia

  // Esta clase es la configuración del estado
  // Contiene los valores proporcionados por el widget padre (en este caso, App)
  // y es utilizada por el método build del State

  final String title; // Título de la página, proporcionado por el widget padre

  @override
  State<MyHomePage> createState() =>
      _MyHomePageState(); // Crea el estado asociado a este widget
}

// Estado asociado a MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; // Variable que almacena el contador

  // Método para incrementar el contador
  void _incrementCounter() {
    setState(() {
      // Esta llamada a setState le dice al framework Flutter que algo ha cambiado
      // en este State, lo que causa que se vuelva a ejecutar el método build
      // para que la pantalla refleje los valores actualizados
      _counter++;
    });
  }

  // Método que construye la interfaz de usuario de esta página
  @override
  Widget build(BuildContext context) {
    // Este método se ejecuta cada vez que se llama a setState
    // El framework Flutter ha sido optimizado para hacer que la ejecución
    // de los métodos build sea rápida
    return Scaffold(
      appBar: AppBar(
        // La barra superior de la aplicación
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title), // Muestra el título proporcionado
      ),
      body: Center(
        // Center es un widget de diseño que posiciona su hijo en el centro
        child: Column(
          // Column es un widget de diseño que organiza sus hijos verticalmente
          // Por defecto, se adapta al ancho de sus hijos y trata de ser
          // tan alto como su padre
          mainAxisAlignment:
              MainAxisAlignment.center, // Centra los hijos verticalmente
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:', // Texto estático
            ),
            Text(
              '$_counter', // Muestra el valor actual del contador
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium, // Estilo de texto desde el tema
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter, // Llama a incrementar cuando se presiona
        tooltip: 'Increment', // Texto que aparece al mantener presionado
        child: const Icon(Icons.add), // Icono de suma
      ),
    );
  }
}
