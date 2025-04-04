// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:restaurante__app/pages/bottomnav.dart'; // Para navegación a la página principal
import 'package:restaurante__app/pages/signup.dart'; // Para navegación al registro
import 'package:restaurante__app/service/auth_service.dart'; // Servicio de autenticación
import 'package:restaurante__app/service/widget_support.dart'; // Estilos de texto

// Widget con estado para la pantalla de inicio de sesión
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

// Estado para la pantalla de inicio de sesión
class _LoginState extends State<Login> {
  // Controladores para los campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Instancia del servicio de autenticación
  final AuthService _authService = AuthService();

  // Variables para controlar estado de carga y errores
  bool _isLoading = false;
  String? _errorMessage;

  // Método para iniciar sesión
  void _login() async {
    setState(() {
      _isLoading = true; // Activa indicador de carga
      _errorMessage = null; // Limpia mensajes de error anteriores
    });

    try {
      // Intenta iniciar sesión con el servicio de autenticación
      await _authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Navegar a la pantalla principal después del inicio de sesión exitoso
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

  // Método para restablecer contraseña
  void _resetPassword() async {
    // Verifica que se haya proporcionado un email
    if (_emailController.text.isEmpty) {
      setState(() {
        _errorMessage =
            "Por favor, ingresa tu email para restablecer la contraseña";
      });
      return;
    }

    try {
      // Envía el correo de restablecimiento
      await _authService.resetPassword(_emailController.text.trim());

      // Muestra mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Se ha enviado un correo para restablecer tu contraseña"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString(); // Guarda el mensaje de error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            // Contenedor superior con color de fondo y logo
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              padding: EdgeInsets.only(top: 30),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xffffefbf), // Color amarillo claro
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
              ),
              child: Column(
                children: [
                  // Logo e imágenes
                  Image.asset("images/pan.png",
                      height: 180, fit: BoxFit.fill, width: 240),
                  Image.asset(
                    "images/logo.png",
                    width: 170,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),

            // Tarjeta con formulario de inicio de sesión
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 3.2,
                  left: 20.0,
                  right: 20.0),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  height: MediaQuery.of(context).size.height / 1.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),

                      // Título del formulario
                      Center(
                        child: Text(
                          "Iniciar Sesión",
                          style: AppWidget.HeadLineTextFieldStyle(),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Campo de email
                      Text(
                        "Email",
                        style: AppWidget.SignUpTextFeildStyle(),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFececf8), // Color gris claro
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Ingresa tu email",
                              prefixIcon: Icon(Icons.mail_outline)),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Campo de contraseña
                      Text(
                        "Contraseña",
                        style: AppWidget.SignUpTextFeildStyle(),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFececf8),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          controller: _passwordController,
                          obscureText:
                              true, // Oculta el texto para la contraseña
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Ingresa tu contraseña",
                              prefixIcon: Icon(Icons.lock_outline)),
                        ),
                      ),
                      SizedBox(height: 10),

                      // Enlace para recuperar contraseña
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap:
                                _resetPassword, // Llama al método de recuperación
                            child: Text("¿Olvidaste tu contraseña?",
                                style: AppWidget.simpleTextFieldStyle()),
                          )
                        ],
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
                      SizedBox(height: 20),

                      // Botón de iniciar sesión
                      GestureDetector(
                        onTap: _isLoading
                            ? null
                            : _login, // Desactivado durante carga
                        child: Center(
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Color(0xffef2b39), // Color rojo
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white) // Indicador de carga
                                  : Text(
                                      "Iniciar Sesión",
                                      style:
                                          AppWidget.boldwhiteTextFieldStyle(),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Enlace para registrarse
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "¿No tienes una cuenta?",
                            style: AppWidget.simpleTextFieldStyle(),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signup()));
                            },
                            child: Text(
                              "Regístrate",
                              style: AppWidget.boldTextFeildStyle(),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
