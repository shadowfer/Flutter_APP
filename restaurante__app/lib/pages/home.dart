// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:restaurante__app/model/burger_model.dart'; // Modelo para hamburguesas
import 'package:restaurante__app/model/category_model.dart'; // Modelo para categorías
import 'package:restaurante__app/model/chinese_model.dart'; // Modelo para comida china
import 'package:restaurante__app/model/mexican_model.dart'; // Modelo para comida mexicana
import 'package:restaurante__app/model/pizza_model.dart'; // Modelo para pizzas
import 'package:restaurante__app/pages/detail_page.dart'; // Página de detalles
import 'package:restaurante__app/service/burger_data.dart'; // Datos locales de hamburguesas
import 'package:restaurante__app/service/category_data.dart'; // Datos locales de categorías
import 'package:restaurante__app/service/chinese_data.dart'; // Datos locales de comida china
import 'package:restaurante__app/service/database_service.dart'; // Servicio de base de datos
import 'package:restaurante__app/service/mexican_data.dart'; // Datos locales de comida mexicana
import 'package:restaurante__app/service/pizza_data.dart'; // Datos locales de pizzas
import 'package:restaurante__app/service/widget_support.dart'; // Estilos de texto

// Widget con estado para la página de inicio
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// Estado para la página de inicio
class _HomeState extends State<Home> {
  // Listas para almacenar los datos de comida
  List<CategoryModel> categories = [];
  List<PizzaModel> pizzas = [];
  List<BurgerModel> burgers = [];
  List<ChineseModel> chinese = [];
  List<MexicanModel> mexican = [];

  String track =
      "0"; // Control de la categoría seleccionada (0 = Pizza por defecto)
  bool _isLoading = true; // Estado de carga
  final DatabaseService _databaseService =
      DatabaseService(); // Servicio de base de datos

  @override
  void initState() {
    super.initState();
    _loadData(); // Carga los datos al inicializar
  }

  // Método para cargar datos desde Firestore o datos locales
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true; // Activa el indicador de carga
    });

    try {
      // Intenta cargar datos desde Firestore
      List<CategoryModel> firestoreCategories =
          await _databaseService.getFirestoreCategories();
      List<PizzaModel> firestorePizzas =
          await _databaseService.getFirestorePizzas();
      List<BurgerModel> firestoreBurgers =
          await _databaseService.getFirestoreBurgers();
      List<ChineseModel> firestoreChinese =
          await _databaseService.getFirestoreChinese();
      List<MexicanModel> firestoreMexican =
          await _databaseService.getFirestoreMexican();

      // Si hay datos en Firestore, los usa; de lo contrario, usa datos locales
      setState(() {
        categories = firestoreCategories.isNotEmpty
            ? firestoreCategories
            : getCategories();
        pizzas = firestorePizzas.isNotEmpty ? firestorePizzas : getPizza();
        burgers = firestoreBurgers.isNotEmpty ? firestoreBurgers : getburger();
        chinese = firestoreChinese.isNotEmpty ? firestoreChinese : getChinese();
        mexican = firestoreMexican.isNotEmpty ? firestoreMexican : getMexican();
        _isLoading = false; // Desactiva el indicador de carga
      });
    } catch (e) {
      print('Error al cargar datos: $e');
      // Si hay un error, carga datos locales
      setState(() {
        categories = getCategories();
        pizzas = getPizza();
        burgers = getburger();
        chinese = getChinese();
        mexican = getMexican();
        _isLoading = false; // Desactiva el indicador de carga
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator()) // Muestra indicador de carga
          : Container(
              margin: EdgeInsets.only(left: 10.0, top: 10.0),
              child: Column(
                children: [
                  // Encabezado con logo y perfil
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "images/logo.png",
                            width: 100,
                            fit: BoxFit.contain,
                            height: 50.0,
                          ),
                          Text(
                            "Order your favorite food",
                            style: AppWidget.simpleTextFieldStyle(),
                          ),
                        ],
                      ),
                      // Imagen de perfil
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            "images/boy1.png",
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),

                  // Barra de búsqueda
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0),
                          margin: EdgeInsets.only(right: 20.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFececf8),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "¿Qué se te antoja?",
                            ),
                          ),
                        ),
                      ),
                      // Botón de búsqueda
                      Container(
                        margin: EdgeInsets.only(right: 10.0),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xffef2b39),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),

                  // Lista horizontal de categorías
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return CategoryTile(
                          categories[index].name,
                          categories[index].image,
                          index.toString(),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),

                  // Grids de productos según la categoría seleccionada
                  track == "0" // Pizza
                      ? Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10.0),
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.69,
                                mainAxisSpacing: 20.0,
                                crossAxisSpacing: 15.0,
                              ),
                              itemCount: pizzas.length,
                              itemBuilder: (context, index) {
                                return FoodTile(
                                  pizzas[index].name,
                                  pizzas[index].image,
                                  pizzas[index].price,
                                );
                              },
                            ),
                          ),
                        )
                      : track == "1" // Hamburguesas
                          ? Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: GridView.builder(
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.69,
                                    mainAxisSpacing: 20.0,
                                    crossAxisSpacing: 15.0,
                                  ),
                                  itemCount: burgers.length,
                                  itemBuilder: (context, index) {
                                    return FoodTile(
                                      burgers[index].name,
                                      burgers[index].image,
                                      burgers[index].price,
                                    );
                                  },
                                ),
                              ),
                            )
                          : track == "2" // Comida china
                              ? Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10.0),
                                    child: GridView.builder(
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 0.49,
                                        mainAxisSpacing: 10.0,
                                        crossAxisSpacing: 1.0,
                                      ),
                                      itemCount: chinese.length,
                                      itemBuilder: (context, index) {
                                        return FoodTile(
                                          chinese[index].name,
                                          chinese[index].image,
                                          chinese[index].price,
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : track == "3" // Comida mexicana
                                  ? Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        child: GridView.builder(
                                          padding: EdgeInsets.zero,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.69,
                                            mainAxisSpacing: 20.0,
                                            crossAxisSpacing: 15.0,
                                          ),
                                          itemCount: mexican.length,
                                          itemBuilder: (context, index) {
                                            return FoodTile(
                                              mexican[index].name,
                                              mexican[index].image,
                                              mexican[index].price,
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : Container(), // En caso de categoría desconocida
                ],
              ),
            ),
    );
  }

  // Widget para mostrar un producto de comida
  Widget FoodTile(String name, String image, String price) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          // Imagen del producto
          Center(
            child: Image.asset(
              image,
              width: MediaQuery.of(context).size.width * 0.30,
              height: MediaQuery.of(context).size.height * 0.14,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 25),
          // Nombre del producto
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: AppWidget.boldTextFeildStyle(),
            ),
          ),
          SizedBox(height: 20),
          // Precio del producto
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "\$$price",
              style: AppWidget.priceTextFeildStyle(),
            ),
          ),
          Spacer(),
          // Botón de acción (navegar a detalles)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(image: image, name: name, price: price),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Color(0xffef2b39),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget para mostrar una categoría
  Widget CategoryTile(String name, String image, String categoryindex) {
    return GestureDetector(
      onTap: () {
        track = categoryindex.toString(); // Actualiza la categoría seleccionada
        setState(() {}); // Actualiza la UI
      },
      child: track == categoryindex
          ? Container(
              // Estilo para categoría seleccionada
              margin: EdgeInsets.only(right: 10.0, bottom: 10.0),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: BoxDecoration(
                    color: Color(0xffef2b39), // Color rojo
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        name,
                        style: AppWidget.whiteTextFieldStyle(),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              // Estilo para categoría no seleccionada
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              margin: EdgeInsets.only(right: 20.0, bottom: 10.0),
              decoration: BoxDecoration(
                color: Color(0xFFececf8), // Color gris claro
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: [
                  Image.asset(
                    image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    name,
                    style: AppWidget.simpleTextFieldStyle(),
                  ),
                ],
              ),
            ),
    );
  }
}
