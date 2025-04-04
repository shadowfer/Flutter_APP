// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:restaurante__app/model/cart_item_model.dart';
import 'package:restaurante__app/service/cart_service.dart';
import 'package:restaurante__app/service/widget_support.dart';

// Widget con estado para la página de detalles del producto
class DetailPage extends StatefulWidget {
  // Propiedades requeridas para mostrar la información del producto
  final String id;
  final String image;
  final String name;
  final String price;
  final String description;
  final String category;

  // Constructor que requiere imagen, nombre y precio
  DetailPage(
      {required this.id,
      required this.image,
      required this.name,
      required this.price,
      this.description =
          "Enjoy our delicious food, made with fresh ingredients. Perfect for any occasion, it's a classic choice that never goes out of style!",
      this.category = "food"});

  @override
  State<DetailPage> createState() =>
      _DetailPageState(); // Crea el estado asociado
}

// Estado para la página de detalles
class _DetailPageState extends State<DetailPage> {
  final CartService _cartService = CartService();
  int quantity = 1; // Cantidad inicial del producto
  int totalprice = 0; // Precio total inicial
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    // Convierte el precio de string a int al inicializar
    totalprice = int.parse(widget.price);
  }

  Future<void> _addToCart() async {
    setState(() {
      _isAddingToCart = true;
    });

    try {
      // Crear el item del carrito
      CartItemModel cartItem = CartItemModel(
        id: widget.id,
        name: widget.name,
        image: widget.image,
        price: double.parse(widget.price),
        category: widget.category,
        quantity: quantity,
      );

      // Añadir al carrito
      await _cartService.addToCart(cartItem);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.name} añadido al carrito'),
          action: SnackBarAction(
            label: 'Ver Carrito',
            onPressed: () {
              // Navegar a la página del carrito (índice 1 en bottomnav)
              Navigator.pop(context,
                  1); // Devolver el índice para cambiar a la página del carrito
            },
          ),
        ),
      );
    } catch (e) {
      print('Error al añadir al carrito: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al añadir al carrito')),
      );
    } finally {
      setState(() {
        _isAddingToCart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Botón de regreso
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Regresa a la pantalla anterior
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Color(0xffef2b39), // Color rojo
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10), // Espacio vertical

            // Imagen del producto
            Center(
              child: Image.asset(
                widget.image,
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),

            // Nombre del producto
            Text(
              widget.name,
              style: AppWidget.HeadLineTextFieldStyle(),
            ),

            // Precio del producto
            Text(
              "\$${widget.price}",
              style: AppWidget.priceTextFeildStyle(),
            ),
            SizedBox(height: 30),

            // Descripción del producto
            Padding(
              padding: const EdgeInsets.only(right: 19.0),
              child: Text(widget.description),
            ),
            SizedBox(height: 30),

            // Sección de cantidad
            Text("Quantity", style: AppWidget.simpleTextFieldStyle()),
            SizedBox(height: 10),
            Row(
              children: [
                // Botón para reducir cantidad
                GestureDetector(
                  onTap: () {
                    if (quantity > 1) {
                      // Evita valores negativos
                      quantity = quantity - 1;
                      totalprice = totalprice - int.parse(widget.price);
                      setState(() {}); // Actualiza la UI
                    }
                  },
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xffef2b39),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),

                // Muestra la cantidad actual
                Text(
                  "$quantity",
                  style: AppWidget.HeadLineTextFieldStyle(),
                ),
                SizedBox(width: 20.0),

                // Botón para aumentar cantidad
                GestureDetector(
                  onTap: () {
                    quantity = quantity + 1;
                    totalprice = totalprice + int.parse(widget.price);
                    setState(() {}); // Actualiza la UI
                  },
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xffef2b39),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
              ],
            ),
            SizedBox(height: 40),

            // Sección de botones de acción (precio total y ordenar)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Muestra el precio total
                Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 60,
                    width: 130,
                    decoration: BoxDecoration(
                        color: Color(0xffef2b39),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        "\$" + totalprice.toString(),
                        style: AppWidget.boldwhiteTextFieldStyle(),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 30.0),

                // Botón de añadir al carrito (antes "ORDER NOW")
                GestureDetector(
                  onTap: _isAddingToCart ? null : _addToCart,
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 70,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: _isAddingToCart
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "ADD TO CART",
                                style: AppWidget.whiteTextFieldStyle(),
                              ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
