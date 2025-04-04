// Importa el modelo de categoría
import 'package:restaurante__app/model/category_model.dart';

// Función que crea y devuelve una lista de objetos CategoryModel
// Estos datos se utilizan como datos iniciales/locales si no se pueden obtener de Firestore
List<CategoryModel> getCategories() {
  // Crea una lista vacía para almacenar las categorías
  List<CategoryModel> category = [];
  // Variable para crear cada objeto CategoryModel
  CategoryModel categoryModel;

  // Crea y añade la categoría Pizza
  categoryModel = CategoryModel(name: "Pizza", image: "images/pizza.png");
  category.add(categoryModel);

  // Crea y añade la categoría Burger
  categoryModel = CategoryModel(name: "Burger", image: "images/burger.png");
  category.add(categoryModel);

  // Crea y añade la categoría Chinese
  categoryModel = CategoryModel(name: "Chinese", image: "images/chinese.png");
  category.add(categoryModel);

  // Crea y añade la categoría Mexican
  categoryModel = CategoryModel(name: "Mexican", image: "images/tacos.png");
  category.add(categoryModel);

  // Devuelve la lista completa de categorías
  return category;
}
