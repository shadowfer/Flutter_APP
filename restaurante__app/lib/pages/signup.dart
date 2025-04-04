// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:restaurante__app/pages/bottomnav.dart'; // Para navegación a la página principal
import 'package:restaurante__app/pages/login.dart'; // Para navegación a inicio de sesión
import 'package:restaurante__app/service/auth_service.dart'; // Servicio de autenticación
import 'package:restaurante__app/service/widget_support.dart'; // Estilos de texto

// Widget con estado para la página de registro
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

// Estado para la página de registro
class _SignupState extends State<Signup> {
  // Controladores para los campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService(); // Servicio de autenticación

  // Variables para controlar estado de carga y errores
  bool _isLoading = false;
  String? _errorMessage;

  // Método para crear una nueva cuenta
  void _signUp() async {
    setState(() {
      _isLoading = true; // Activa el indicador de carga
      _errorMessage = null; // Limpia mensajes de error anteriores
    });

    try {
      // Intenta registrar al usuario con el servicio de autenticación
      await _authService.signUpWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
      );

      // Navegar a la pantalla principal después del registro exitoso
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Bottomnav()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString(); // Guarda el mensaje de error
      });
    } finally {
      setState(() {
        _isLoading = false; // Desactiva el indicador de carga
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            // Contenedor superior con color de fondo
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xffffefbf), // Color amarillo claro
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  // Logo
                  Image.asset(
                    "images/logo.png",
                    width: 170,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),

            // Tarjeta con formulario de registro
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 3.5,
                left: 20.0,
                right: 20.0,
              ),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),

                      // Título del formulario
                      Center(
                        child: Text(
                          "Registro",
                          style: AppWidget.HeadLineTextFieldStyle(),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Campo de nombre
                      Text(
                        "Nombre",
                        style: AppWidget.SignUpTextFeildStyle(),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFececf8), // Color gris claro
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Ingresa tu nombre",
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      // Campo de email
                      Text(
                        "Email",
                        style: AppWidget.SignUpTextFeildStyle(),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFececf8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Ingresa tu email",
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      // Campo de contraseña
                      Text(
                        "Contraseña",
                        style: AppWidget.SignUpTextFeildStyle(),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFececf8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText:
                              true, // Oculta el texto para la contraseña
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Ingresa tu contraseña",
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                      ),

                      // Mensaje de error si existe
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      SizedBox(height: 30),

                      // Botón de registro
                      GestureDetector(
                        onTap: _isLoading
                            ? null
                            : _signUp, // Desactivado durante carga
                        child: Center(
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Color(0xffef2b39), // Color rojo
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white) // Indicador de carga
                                  : Text(
                                      "Registrarse",
                                      style:
                                          AppWidget.boldwhiteTextFieldStyle(),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Enlace para ir a inicio de sesión
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "¿Ya tienes una cuenta?",
                            style: AppWidget.simpleTextFieldStyle(),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              );
                            },
                            child: Text(
                              "Iniciar sesión",
                              style: AppWidget.boldTextFeildStyle(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
