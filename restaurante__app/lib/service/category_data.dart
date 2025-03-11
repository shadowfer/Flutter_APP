import 'package:restaurante__app/model/category_model.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> category = [];
  CategoryModel categoryModel;

  categoryModel = CategoryModel(name: "Pizza", image: "images/pizza.png");
  category.add(categoryModel);

  categoryModel = CategoryModel(name: "Burger", image: "images/burger.png");
  category.add(categoryModel);

  categoryModel = CategoryModel(name: "Chinese", image: "images/chinese.png");
  category.add(categoryModel);

  categoryModel = CategoryModel(name: "Mexican", image: "images/tacos.png");
  category.add(categoryModel);

  return category; // ✅ Ahora devuelve una lista válida sin errores
}
