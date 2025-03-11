import 'package:flutter/material.dart';
import 'package:restaurante__app/service/widget_support.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4, // Reducido para que el texto y botón tengan más espacio
              child: Center(
                child: Image.asset(
                  "images/onboard.png",
                  width: MediaQuery.of(context).size.width * 0.85,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              flex: 4, // Aumentado para dar más espacio al texto y botón
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Subir contenido
                children: [
                  Text(
                    "The Fastest\nFood Delivery",
                    textAlign: TextAlign.center,
                    style: AppWidget.HeadLineTextFieldStyle(),
                  ),
                  SizedBox(height: 15.0), // Más espacio entre textos
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Craving something delicious?\nOrder now and get your favorites\ndelivered fast!",
                      textAlign: TextAlign.center,
                      style: AppWidget.simpleTextFieldStyle(),
                    ),
                  ),
                  Spacer(), // Empuja el botón hacia abajo pero sin overflow
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: 50, // Altura fija para que el botón no se aplaste
                    child: ElevatedButton(
                      onPressed: () {}, // Acción del botón
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff8c592a),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          30.0), // Espacio final para que no se vea apretado
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
