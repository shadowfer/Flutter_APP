import 'package:restaurante__app/model/chinese_model.dart';

List<ChineseModel> getChinese() {
  List<ChineseModel> chinese = [];

  // Crear la primera comida china con los parámetros requeridos
  ChineseModel chineseModel = ChineseModel(
    name: "Chow Mein", // Nombre de la comida china
    image: "images/pan.png", // Ruta de la imagen
    price: "80", description: null, // Precio
  );
  chinese.add(chineseModel);

  // Crear la segunda comida china
  chineseModel = ChineseModel(
    name: "Kung Pao", // Nombre de la comida china
    image: "images/pan.png", // Ruta de la imagen
    price: "90", description: null, // Precio
  );
  chinese.add(chineseModel);

  // Crear más comidas chinas si es necesario
  chineseModel = ChineseModel(
    name: "Pork",
    image: "images/pan.png",
    price: "100",
    description: null,
  );
  chinese.add(chineseModel);

  // Crear más comidas chinas si es necesario
  chineseModel = ChineseModel(
    name: "Pork",
    image: "images/pan.png",
    price: "110",
    description: null,
  );
  chinese.add(chineseModel);

  return chinese;
}
