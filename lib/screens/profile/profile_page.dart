import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';  
import 'package:flutter/material.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:mozaic_app/constant/app_constant.dart';
import 'package:mozaic_app/screens/category/category_page.dart';
import 'package:mozaic_app/screens/printer/printer_address_page.dart';
import 'package:mozaic_app/screens/profile/capital_money_page.dart';
import 'package:mozaic_app/screens/profile/change_password_page.dart';
import 'package:mozaic_app/screens/profile/help_page.dart';
import 'package:mozaic_app/style/app_properties.dart';
import 'package:mozaic_app/screens/profile/about_page.dart';
import 'package:mozaic_app/widget/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widget/custom_loading.dart';
import '../auth/login_page.dart';
import '../printer/printer_kitchen_address_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<ProfilePage> {
  String userId = '';
  String userName = '';
  String fullName = '';
  String userGroupName = '';
  String token = '';
  int? guestState;

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
  }

  void rebuild() {
    loadSharedPreference();
  }

  Future<void> loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id')!;
      userName = prefs.getString('username')!;
      fullName = prefs.getString('full_name')!;
      userGroupName = prefs.getString('user_group_name')!;
      guestState = int.parse(prefs.getString('guest_state')!);
      token = prefs.getString('token')!;
    });

    if (guestState == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Akun Percobaan"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text("username : $userName"),
                  const Text("password : 123456"),
                  const Text("*jika belum diubah",
                    style: TextStyle(fontSize: 10),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Akun percobaan hanya berlaku 7 hari !",
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                      "Untuk mendapatkan akses penuh silahkan hubungi kontak kami pada halaman 'Tentang Aplikasi' ",
                      style:
                      TextStyle(color: Color.fromARGB(255, 26, 189, 211))),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape ? Scaffold(
          backgroundColor: const Color(0xffF9F9F9),
          appBar: AppBar(
            title: const Text(
                'Profil & Pengaturan',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                )
            ),
            backgroundColor: const Color.fromARGB(255, 35, 128, 220),
            shadowColor: Colors.black,
            elevation: 6,
          ),
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: kToolbarHeight,
                  left: 32,
                  right: 32,
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      maxRadius: 60,
                      backgroundImage:
                      AssetImage('assets/mozaic/logo-baru-set-07.png'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        fullName,
                        style: const TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold, fontSize: 30
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 80
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: transparentYellow,
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(0, 1),
                            )
                          ]
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Material(
                              color: Colors.white,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Future.delayed(const Duration(milliseconds: 600), () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChangePasswordPage()));
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/wallet.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                    const Column(
                                      children: [
                                        Text(
                                          'Ganti',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),
                                        ),
                                        Text(
                                          'Password',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.white,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Future.delayed(const Duration(milliseconds: 600), () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CapitalMoneyPage()));
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/truck.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                    const Column(
                                      children: [
                                        Text(
                                          'Uang',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),
                                        ),
                                        Text(
                                          'Modal',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.white,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Future.delayed(const Duration(milliseconds: 600), () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CategoryPage()));
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/card.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                    const Column(
                                      children: [
                                        Text(
                                          'Menu',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),
                                        ),
                                        Text(
                                          'Baru',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.white,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Future.delayed(const Duration(milliseconds: 600), () {
                                    _launchWhatsapp(context);
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/contact_us.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                    const Column(
                                      children: [
                                        Text(
                                          'Bantuan',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),
                                        ),
                                        Text(
                                          'Vendor',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        fetchPrinterAddress(context);
                      },
                      title: const Text(
                        'Printer Kasir',
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                      subtitle: const Text(
                        'Setting nama printer Kasir',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      leading: const Icon(
                        Icons.print,
                        color: Colors.grey,
                        size: 30,
                      ),
                      trailing: const Icon(Icons.chevron_right, color: yellow),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () {
                        fetchPrinterKitchenAddress(context);
                      },
                      title: const Text(
                        'Printer Dapur',
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                      subtitle: const Text(
                        'Setting nama printer Dapur',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      leading: const Icon(
                        Icons.print,
                        color: Colors.orange,
                        size: 30,
                      ),
                      trailing: const Icon(Icons.chevron_right, color: yellow),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () {
                        fetchNewMenu(context);
                      },
                      title: const Text(
                        'Bantuan',
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                      subtitle: const Text(
                        'Bantuan pemakaian aplikasi',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      leading: const Icon(
                        Icons.help,
                        color: Colors.blue,
                        size: 30,
                      ),
                      trailing: const Icon(Icons.chevron_right, color: yellow),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutPage())),
                      title: const Text(
                        'Tentang Aplikasi',
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                      subtitle: const Text(
                        'Tentang Aplikasi dan Copyright',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      leading: const Icon(
                        Icons.copyright,
                        color: Colors.greenAccent,
                        size: 30,
                      ),
                      trailing: const Icon(Icons.chevron_right, color: yellow),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () {
                        fetchLogout(context);
                      },
                      title: const Text(
                        'Keluar',
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                      subtitle: const Text(
                        'Keluar Aplikasi',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 30,
                      ),
                      trailing: const Icon(Icons.chevron_right, color: yellow),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ) : Scaffold(
          backgroundColor: const Color(0xffF9F9F9),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: const Text(
                'Profil & Pengaturan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                )
            ),
            backgroundColor: const Color.fromARGB(255, 35, 128, 220),
            shadowColor: Colors.black,
            elevation: 6,
          ),
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: kToolbarHeight),
                child: Column(
                  children: [
                    const CircleAvatar(
                      maxRadius: 50,
                      backgroundImage:
                      AssetImage('assets/mozaic/logo-vc.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        fullName,
                        style: const TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: transparentYellow,
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: Offset(0, 1))
                          ]),
                      height: 150,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                    'assets/icons/wallet.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) =>
                                          const ChangePasswordPage())),
                                ),
                                const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Ganti',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                      ),
                                    ),
                                    Text(
                                      'Password',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                    'assets/icons/truck.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) =>
                                          const CapitalMoneyPage())),
                                ),
                                const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Uang',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                      ),
                                    ),
                                    Text(
                                      'Modal',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    icon: Image.asset(
                                      'assets/icons/card.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    onPressed: () {
                                      fetchCategories(context);
                                    }
                                ),
                                const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Menu',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                      ),
                                    ),
                                    Text(
                                      'Baru',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                    'assets/icons/contact_us.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                  onPressed: () {
                                    _launchWhatsapp(context);
                                  },
                                ),
                                const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Bantuan',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                      ),
                                    ),
                                    Text(
                                      'Vendor',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                        minTileHeight: 1,
                        title: const Text(
                          'Printer Kasir',
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                        subtitle: const Text(
                          'Setting nama printer Kasir',
                          style: TextStyle(
                              fontSize: 12
                          ),
                        ),
                        leading: const Icon(
                          Icons.print,
                          color: Colors.grey,
                          size: 25,
                        ),
                        trailing: const Icon(Icons.chevron_right, color: yellow),
                        onTap: () {
                          fetchPrinterAddress(context);
                        }
                    ),
                    const Divider(),
                    ListTile(
                        minTileHeight: 1,
                        title: const Text(
                          'Printer Dapur',
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                        subtitle: const Text(
                          'Setting nama printer Dapur',
                          style: TextStyle(
                              fontSize: 12
                          ),
                        ),
                        leading: const Icon(
                          Icons.print,
                          color: Colors.orange,
                          size: 25,
                        ),
                        trailing: const Icon(Icons.chevron_right, color: yellow),
                        onTap: () {
                          fetchPrinterKitchenAddress(context);
                        }
                    ),
                    const Divider(),
                    ListTile(
                        minTileHeight: 1,
                        title: const Text(
                          'Bantuan',
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                        subtitle: const Text(
                          'Bantuan pemakaian aplikasi',
                          style: TextStyle(
                              fontSize: 12
                          ),
                        ),
                        leading: const Icon(
                          Icons.help,
                          color: Colors.blue,
                          size: 25,
                        ),
                        trailing: const Icon(Icons.chevron_right, color: yellow),
                        onTap: () {
                          fetchNewMenu(context);
                        }
                    ),
                    const Divider(),
                    ListTile(
                      minTileHeight: 1,
                      title: const Text(
                        'Tentang Aplikasi',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      subtitle: const Text(
                        'Tentang Aplikasi dan Copyright',
                        style: TextStyle(
                            fontSize: 12
                        ),
                      ),
                      leading: const Icon(
                        Icons.copyright,
                        color: Colors.greenAccent,
                        size: 25,
                      ),
                      trailing: const Icon(Icons.chevron_right, color: yellow),
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AboutPage())),
                    ),
                    const Divider(),
                    ListTile(
                        minTileHeight: 1,
                        title: const Text(
                          'Keluar',
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                        subtitle: const Text(
                          'Keluar Aplikasi',
                          style: TextStyle(
                              fontSize: 12
                          ),
                        ),
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.red,
                          size: 25,
                        ),
                        trailing: const Icon(Icons.chevron_right, color: yellow),
                        onTap: () {
                          fetchLogout(context);
                        }),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void fetchLogout(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.logout,
        data: {},
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        //setSharedPreference
        await prefs.remove('username');
        await prefs.remove('user_group_name');
        await prefs.remove('created_at');
        await prefs.remove('token');
        await prefs.remove('itemcategory');
        //Messsage
        CustomSnackbar.show(context, 'Logout Berhasil');
        //SettingsPage
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    } on DioException catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        // print(e.message);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    }
  }

  Future <void> fetchPrinterAddress(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.printerAddress,
        data: {
          'user_id': userId
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        String prefPrinterAddress = response.data['data'].toString();
        await prefs.setString('printer_address', prefPrinterAddress);
        //SettingsPage
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const PrinterAddressPage(),
        ).then((value) => rebuild());
        //Messsage
      }
    } on DioException catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        // Message
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        /*print(e.message);*/
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const PrinterAddressPage(),
        ).then((value) => rebuild());
      }
    }
  }

  Future <void> fetchPrinterKitchenAddress(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.printerKitchenAddress,
        data: {
          'user_id': userId
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        hideLoaderDialog(context);
        String prefPrinterKitchenAddress = response.data['data'].toString();
        await prefs.setString('printer_kitchen_address', prefPrinterKitchenAddress);
        //SettingsPage
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const PrinterKitchenAddressPage(),
        ).then((value) => rebuild());
      }
    } on DioException catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        // Message
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        /*print(e.message);*/
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const PrinterKitchenAddressPage(),
        ).then((value) => rebuild());
      }
    }
  }

  void _launchWhatsapp(context) async {
    var contact = companyPhone;
    var androidUrl = "whatsapp://send?phone=$contact&text=Halo, saya tertarik dengan produk Cipta Solutindo Tech";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Halo, saya tertarik dengan produk Cipta Solutindo Tech')}";

    try{
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      }
      else{
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception{
      CustomSnackbar.show(context, 'WhatsApp belum terinstall di perangkat anda', backgroundColor: Colors.red);
    }
  }

  fetchCategories(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.itemCategoryNewMenu,
        data: {
          'user_id': userId
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        String itemCategory = json.encode(response.data['data']);
        await prefs.setString('itemcategory', itemCategory);
        // print(itemCategory[0]);
        //SettingsPage
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CategoryPage()));
      }
    } on DioException catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {}
    }
  }

  void fetchNewMenu(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    // showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.itemCategoryNewMenu,
        data: {
          'user_id': userId
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        // hideLoaderDialog(context);
        String itemCategory = json.encode(response.data['data']);
        await prefs.setString('itemcategory', itemCategory);
        // print(itemCategory[0]);
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HelpPage()));
        /*setState(() {
          itemCategoryJson = response.data['data'];
        });*/
      }
    } on DioException catch (e) {
      // hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {

      }
    }
  }
}
