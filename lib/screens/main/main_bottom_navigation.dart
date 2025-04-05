import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:mozaic_app/screens/auth/login_page.dart';
import 'package:mozaic_app/screens/main/main_page.dart';
import 'package:mozaic_app/screens/profile/profile_page.dart';
import 'package:mozaic_app/widget/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard/dashboard_page.dart';
import '../expenditure/expenditure_page.dart';

class MainBottomNavigation extends StatefulWidget {
  const MainBottomNavigation({super.key});

  @override
  State<MainBottomNavigation> createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> with TickerProviderStateMixin {
  late TabController _bottomTabController;
  int _currentIndex = 0;
  String userId = '';
  String userName = '';
  String userGroupName = '';
  String? token;

  @override
  void initState() {
    super.initState();
    _bottomTabController = TabController(length: 4, vsync: this);
    getLoginState(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => loadSharedPreference());
  }

  loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartitems');
    await prefs.remove('descriptionitems');
    var dataJson = [];
    await prefs.setString('cartitems', json.encode(dataJson));
    await prefs.setString('descriptionitems', json.encode(dataJson));
    DateTime dateNow = DateTime.now();
    await prefs.setString('start_date', dateNow.toString());
    await prefs.setString('end_date', dateNow.toString());
    prefs.setString('print_status', "0");
    setState(() {
      userId = prefs.getString('user_id') ?? '';
      userName = prefs.getString('username') ?? '';
      userGroupName = prefs.getString('user_group_name') ?? '';
      token = prefs.getString('token') ?? '';
      fetchItemAll(context);
    });
  }

  deleteSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _bottomTabController.animateTo( 
          index,
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease
      );
    });
  } //

  List<Widget> listPage = [
    const MainPage(),
    const ExpenditurePage(),
    const DashboardPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape ? Scaffold(
          body: TabBarView(
            controller: _bottomTabController,
            physics: const NeverScrollableScrollPhysics(),
            children: listPage,
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              selectedIconTheme: const IconThemeData(
                color: Colors.white,
            ),
            elevation: 40,
            type: BottomNavigationBarType.fixed,
            iconSize: 18,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            selectedFontSize: 16,
            unselectedFontSize: 14,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                activeIcon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 35, 128, 220),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: const Icon(Icons.menu_rounded)
                ),
                icon: const Icon(Icons.menu_rounded),
                label: 'Menu Utama',
                tooltip: 'Halaman Utama',
              ),
              BottomNavigationBarItem(
                  activeIcon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 35, 128, 220),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: const Icon(Icons.payments_rounded)
                  ),
                  icon: const Icon(Icons.payments_rounded),
                  label: 'Pengeluaran',
                  tooltip: 'Pengeluaran'
              ),
              BottomNavigationBarItem(
                  activeIcon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 35, 128, 220),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: const Icon(Icons.dashboard_rounded)
                  ),
                  icon: const Icon(Icons.dashboard_rounded),
                  label: 'Dashboard',
                  tooltip: 'DashBoard'
              ),
              BottomNavigationBarItem(
                  activeIcon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 35, 128, 220),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: const Icon(Icons.person_rounded)
                  ),
                  icon: const Icon(Icons.person_rounded),
                  label: 'Akun',
                  tooltip: 'Halaman Pengaturan Akun'
              ),
            ],
          ),
        ) : Scaffold(
          body: TabBarView(
            controller: _bottomTabController,
            physics: const NeverScrollableScrollPhysics(),
            children: listPage,
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              selectedIconTheme: const IconThemeData(
                color: Colors.white
            ),
            elevation: 8,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color.fromARGB(255, 73, 71, 71),
            unselectedItemColor: Color.fromARGB(255, 73, 71, 71),
            selectedFontSize: 14,
            unselectedFontSize: 12,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                activeIcon: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 35, 128, 220),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: const Icon(Icons.menu_rounded)
                ),
                icon: const Icon(Icons.menu_rounded),
                label: 'Menu Utama',
                tooltip: 'Halaman Utama',
              ),
              BottomNavigationBarItem(
                  activeIcon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 35, 128, 220),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: const Icon(Icons.payments_rounded)
                  ),
                  icon: const Icon(Icons.payments_rounded),
                  label: 'Pengeluaran',
                  tooltip: 'Pengeluaran'
              ),
              BottomNavigationBarItem(
                  activeIcon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 35, 128, 220),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: const Icon(Icons.dashboard_rounded)
                  ),
                  icon: const Icon(Icons.dashboard_rounded),
                  label: 'Dashboard',
                  tooltip: 'Dashboard'
              ),
              BottomNavigationBarItem(
                  activeIcon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 35, 128, 220),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: const Icon(Icons.person_rounded)
                  ),
                  icon: const Icon(Icons.person_rounded),
                  label: 'Akun',
                  tooltip: 'Halaman Pengaturan Akun'
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> fetchItemAll(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    // showLoaderDialog(context);
    token = prefs.getString('token') ?? '';
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.itemAll,
        data: {
          'user_id': userId,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        // hideLoaderDialog(context);
        String item = json.encode(response.data['data']);
        await prefs.setString('item', item);
        // print(item);
        //Messsage
      }
    } on DioException catch (e) {
      /*print(e);*/
      // hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        // print(e.message);
      }
    }
  }

  Future<void> getLoginState(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.loginState,
        data: {},
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Berhasil
        // Main Page
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        // Gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        // deleteSharedPreferences();
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const LoginPage()));
      }
    }
  }
}