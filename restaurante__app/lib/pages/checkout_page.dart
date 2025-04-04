import 'package:flutter/material.dart';
import 'package:restaurante__app/model/cart_item_model.dart';
import 'package:restaurante__app/model/payment_method_model.dart';
import 'package:restaurante__app/model/transaction_model.dart';
import 'package:restaurante__app/service/cart_service.dart';
import 'package:restaurante__app/service/database_service.dart';
import 'package:restaurante__app/service/wallet_service.dart';
import 'package:restaurante__app/service/widget_support.dart';
import 'package:uuid/uuid.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItemModel> cartItems;
  final double total;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.total,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final WalletService _walletService = WalletService();
  final CartService _cartService = CartService();
  final DatabaseService _databaseService = DatabaseService();

  List<PaymentMethodModel> _paymentMethods = [];
  PaymentMethodModel? _selectedPaymentMethod;
  bool _isLoading = true;
  bool _isProcessing = false;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadPaymentMethods() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<PaymentMethodModel> methods =
          await _walletService.getPaymentMethods();

      setState(() {
        _paymentMethods = methods;

        // Seleccionar el método predeterminado o el primero si existe
        if (methods.isNotEmpty) {
          // Buscar un método predeterminado
          var defaultMethods = methods.where((method) => method.isDefault);
          if (defaultMethods.isNotEmpty) {
            _selectedPaymentMethod = defaultMethods.first;
          } else {
            // Si no hay método predeterminado, usar el primero
            _selectedPaymentMethod = methods.first;
          }
        } else {
          // Si no hay métodos, _selectedPaymentMethod será null
          _selectedPaymentMethod = null;
        }

        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar métodos de pago: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _placeOrder() async {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor selecciona un método de pago')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Crear la orden
      String? orderId = await _databaseService.createOrder(
        items: widget.cartItems,
        total: widget.total,
        paymentMethodId: _selectedPaymentMethod!.id,
        address: _addressController.text.trim(),
        notes: _notesController.text.trim(),
      );

      if (orderId != null) {
        // Registrar la transacción
        await _walletService.createOrderTransaction(
          orderId: orderId,
          amount: widget.total,
          paymentMethodId: _selectedPaymentMethod!.id,
        );

        // Vaciar el carrito
        await _cartService.clearCart();

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Pedido realizado con éxito!')),
        );

        // Volver a la pantalla anterior
        Navigator.pop(context);
      } else {
        throw Exception('Error al crear la orden');
      }
    } catch (e) {
      print('Error al procesar el pedido: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al procesar el pedido: $e')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: AppWidget.boldTextFeildStyle()),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _paymentMethods.isEmpty
              ? _buildNoPaymentMethods()
              : _buildCheckoutForm(),
      bottomNavigationBar:
          _isLoading || _paymentMethods.isEmpty ? null : _buildOrderButton(),
    );
  }

  Widget _buildNoPaymentMethods() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card,
            size: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            'No tienes métodos de pago',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Añade un método de pago en la sección Billetera',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffef2b39),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Volver al Carrito',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resumen del pedido
          Text(
            'Resumen del Pedido',
            style: AppWidget.HeadLineTextFieldStyle(),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Lista de productos
                  ...widget.cartItems.map((item) => Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Text(
                              '${item.quantity}x',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                  Divider(),
                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '\$${widget.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xffef2b39),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),

          // Dirección de entrega
          Text(
            'Dirección de Entrega',
            style: AppWidget.HeadLineTextFieldStyle(),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFececf8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _addressController,
              maxLines: 3,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Ingresa tu dirección de entrega',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 15, right: 10),
                  child: Icon(Icons.home_outlined),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
            ),
          ),
          SizedBox(height: 24),

          // Notas adicionales
          Text(
            'Notas Adicionales',
            style: AppWidget.HeadLineTextFieldStyle(),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFececf8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Instrucciones especiales para la entrega',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 15, right: 10),
                  child: Icon(Icons.note_outlined),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
            ),
          ),
          SizedBox(height: 24),

          // Método de pago
          Text(
            'Método de Pago',
            style: AppWidget.HeadLineTextFieldStyle(),
          ),
          SizedBox(height: 16),
          ...List.generate(_paymentMethods.length, (index) {
            PaymentMethodModel method = _paymentMethods[index];
            bool isSelected = _selectedPaymentMethod?.id == method.id;

            return Card(
              margin: EdgeInsets.only(bottom: 12),
              elevation: isSelected ? 2 : 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: isSelected ? Color(0xffef2b39) : Colors.transparent,
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = method;
                  });
                },
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Image.asset(
                        method.icon,
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '•••• •••• •••• ${method.cardNumber.substring(method.cardNumber.length - 4)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Radio(
                        value: method.id,
                        groupValue: _selectedPaymentMethod?.id,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = method;
                          });
                        },
                        activeColor: Color(0xffef2b39),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderButton() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _isProcessing ? null : _placeOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xffef2b39),
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: _isProcessing
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Procesando...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : Text(
                  'Realizar Pedido',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
