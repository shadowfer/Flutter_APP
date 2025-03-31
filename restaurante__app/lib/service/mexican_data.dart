import 'package:restaurante__app/model/mexican_model.dart';

List<MexicanModel> getMexican() {
  List<MexicanModel> mexican = [];

  // Crear la primera comida mexicana con los parámetros requeridos
  MexicanModel mexicanModel = MexicanModel(
    name: "Tacos", // Nombre de la comida mexicana
    image: "images/tacos.png", // Ruta de la imagen
    price: "50", description: null, // Precio
  );
  mexican.add(mexicanModel);

  // Crear la segunda comida mexicana
  mexicanModel = MexicanModel(
    name: "Burritos", // Nombre de la comida mexicana
    image: "images/tacos.png", // Ruta de la imagen
    price: "70", description: null, // Precio
  );
  mexican.add(mexicanModel);

  // Crear más comidas mexicanas si es necesario
  mexicanModel = MexicanModel(
    name: "Enchiladas",
    image: "images/tacos.png",
    price: "80",
    description: null,
  );
  mexican.add(mexicanModel);

  mexicanModel = MexicanModel(
    name: "Enchiladas",
    image: "images/tacos.png",
    price: "80",
    description: null,
  );
  mexican.add(mexicanModel);

  return mexican;
}
