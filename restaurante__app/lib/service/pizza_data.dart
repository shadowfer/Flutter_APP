// pizza_data.dart
import 'package:flutter/foundation.dart';
import 'package:restaurante__app/model/pizza_model.dart';

List<PizzaModel> getPizza() {
  List<PizzaModel> pizza = [];

  // Crear la primera pizza con los parámetros requeridos
  PizzaModel pizzaModel = PizzaModel(
    name: "Cheese pizza", // Nombre de la pizza
    image: "images/pizza1.png", // Imagen de la pizza
    price: "50", // Precio de la pizza
  );
  pizza.add(pizzaModel);

  // Crear la segunda pizza con los parámetros requeridos
  pizzaModel = PizzaModel(
    name: "Margarita", // Nombre de la pizza
    image: "images/pizza2.png", // Imagen de la pizza
    price: "65", // Precio de la pizza
  );
  pizza.add(pizzaModel);

  // Crear más pizzas si es necesario
  pizzaModel = PizzaModel(
    name: "Fungus pizza",
    image: "images/pizza3.png",
    price: "60",
  );
  pizza.add(pizzaModel);

  pizzaModel = PizzaModel(
    name: "Pepperoni",
    image: "images/pizza4.png",
    price: "75",
  );
  pizza.add(pizzaModel);

  return pizza;
}
