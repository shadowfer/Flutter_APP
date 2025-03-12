// burger_data.dart

import 'package:restaurante__app/model/burger_model.dart';

// Función que retorna una lista de burgers
List<BurgerModel> getburger() {
  List<BurgerModel> burger = [];

  // Crear la primera burger con los parámetros requeridos
  BurgerModel burgerModel = BurgerModel(
    name: "Cheese burger", // Nombre de la burger
    image: "images/burger1.png", // Ruta de la imagen de la burger
    price: "80", // Precio de la burger
  );
  burger.add(burgerModel); // Añadir la burger a la lista

  // Crear la segunda burger con los parámetros requeridos
  burgerModel = BurgerModel(
    name: "Vegan", // Nombre de la burger
    image: "images/burger2.png", // Ruta de la imagen de la burger
    price: "75", // Precio de la burger
  );
  burger.add(burgerModel); // Añadir la burger a la lista

  burgerModel = BurgerModel(
    name: "Chicken", // Nombre de la burger
    image: "images/burger2.png", // Ruta de la imagen de la burger
    price: "85", // Precio de la burger
  );
  burger.add(burgerModel); // Añadir la burger a la lista

  burgerModel = BurgerModel(
    name: "BQQ", // Nombre de la burger
    image: "images/burger2.png", // Ruta de la imagen de la burger
    price: "95", // Precio de la burger
  );
  burger.add(burgerModel); // Añadir la burger a la lista

  return burger; // Retornar la lista de burgers
}
