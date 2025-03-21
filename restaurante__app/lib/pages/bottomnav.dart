import 'package:flutter/material.dart';
import 'package:restaurante__app/pages/home.dart';
import 'package:restaurante__app/pages/order.dart';
import 'package:restaurante__app/pages/profile.dart';
import 'package:restaurante__app/pages/wallet.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homePage;
  late Profile profilePage;
  late Order orderPage;
  late Wallet walletPage;

  @override
  void initState() {
    homePage = const Home();
    profilePage = const Profile();
    orderPage = const Order();
    walletPage = const Wallet();
    pages = [homePage, orderPage, walletPage, profilePage];
    currentPage = homePage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
            currentPage = pages[index];
          });
        },
        items: [
          Icon(
            Icons.home,
            color: Colors.white,
            size: 30,
          ),
          Icon(
            Icons.shopping_bag,
            color: Colors.white,
            size: 30,
          ),
          Icon(
            Icons.wallet,
            color: Colors.white,
            size: 30,
          ),
          Icon(
            Icons.person,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
