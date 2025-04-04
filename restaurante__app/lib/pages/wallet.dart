import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurante__app/model/payment_method_model.dart';
import 'package:restaurante__app/model/transaction_model.dart';
import 'package:restaurante__app/service/wallet_service.dart';
import 'package:restaurante__app/service/widget_support.dart';
import 'package:uuid/uuid.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> with SingleTickerProviderStateMixin {
  final WalletService _walletService = WalletService();

  late TabController _tabController;
  List<PaymentMethodModel> _paymentMethods = [];
  List<TransactionModel> _transactions = [];
  bool _isLoading = true;

  // Controladores para el formulario de método de pago
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<PaymentMethodModel> methods =
          await _walletService.getPaymentMethods();
      List<TransactionModel> transactions =
          await _walletService.getTransactionHistory();

      setState(() {
        _paymentMethods = methods;
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar datos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddPaymentMethodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Añadir Método de Pago'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del titular',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Número de tarjeta',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _expiryDateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de expiración (MM/AA)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _addPaymentMethod();
              Navigator.pop(context);
            },
            child: Text('Añadir'),
          ),
        ],
      ),
    );
  }

  Future<void> _addPaymentMethod() async {
    if (_nameController.text.isEmpty ||
        _cardNumberController.text.isEmpty ||
        _expiryDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    try {
      PaymentMethodModel newMethod = PaymentMethodModel(
        type: 'card',
        name: _nameController.text.trim(),
        cardNumber: _cardNumberController.text.trim(),
        expiryDate: _expiryDateController.text.trim(),
        icon: 'images/card.png',
        isDefault:
            _paymentMethods.isEmpty, // Si es el primero, hacerlo predeterminado
      );

      await _walletService.addPaymentMethod(newMethod);

      // Limpiar los campos
      _nameController.clear();
      _cardNumberController.clear();
      _expiryDateController.clear();

      // Recargar los datos
      _loadData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Método de pago añadido correctamente')),
      );
    } catch (e) {
      print('Error al añadir método de pago: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al añadir método de pago')),
      );
    }
  }

  Future<void> _setDefaultPaymentMethod(String methodId) async {
    try {
      await _walletService.setDefaultPaymentMethod(methodId);
      _loadData();
    } catch (e) {
      print('Error al establecer método predeterminado: $e');
    }
  }

  Future<void> _deletePaymentMethod(String methodId) async {
    try {
      await _walletService.deletePaymentMethod(methodId);
      _loadData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Método de pago eliminado correctamente')),
      );
    } catch (e) {
      print('Error al eliminar método de pago: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Billetera', style: AppWidget.boldTextFeildStyle()),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xffef2b39),
          labelColor: Color(0xffef2b39),
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: 'Métodos de Pago'),
            Tab(text: 'Transacciones'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPaymentMethodsTab(),
                _buildTransactionsTab(),
              ],
            ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _showAddPaymentMethodDialog,
              backgroundColor: Color(0xffef2b39),
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildPaymentMethodsTab() {
    return _paymentMethods.isEmpty
        ? Center(
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
                  'Añade un método de pago para comenzar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showAddPaymentMethodDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffef2b39),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Añadir Método de Pago',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _paymentMethods.length,
            itemBuilder: (context, index) {
              PaymentMethodModel method = _paymentMethods[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Image.asset(
                    method.icon,
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    method.name,
                    style: AppWidget.boldTextFeildStyle(),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        '•••• •••• •••• ${method.cardNumber.substring(method.cardNumber.length - 4)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Expira: ${method.expiryDate}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (method.isDefault)
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xffef2b39),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Predeterminado',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        )
                      else
                        IconButton(
                          icon: Icon(Icons.check_circle_outline),
                          onPressed: () => _setDefaultPaymentMethod(method.id),
                        ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deletePaymentMethod(method.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildTransactionsTab() {
    return _transactions.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 100,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 20),
                Text(
                  'No tienes transacciones',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Tus transacciones aparecerán aquí',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              TransactionModel transaction = _transactions[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: transaction.type == 'payment'
                        ? Colors.red[100]
                        : Colors.green[100],
                    child: Icon(
                      transaction.type == 'payment'
                          ? Icons.shopping_bag_outlined
                          : Icons.attach_money,
                      color: transaction.type == 'payment'
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                  title: Text(
                    transaction.title,
                    style: AppWidget.boldTextFeildStyle(),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        transaction.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(transaction.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    '${transaction.type == 'payment' ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: transaction.type == 'payment'
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
  }
}
