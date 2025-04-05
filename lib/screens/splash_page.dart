import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:mozaic_app/screens/main/main_bottom_navigation.dart';
import 'package:mozaic_app/style/app_properties.dart';
import 'package:mozaic_app/screens/auth/login_page.dart';
import 'package:mozaic_app/widget/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? token;
  Timer? timer;

  startSplashScreen() async {
    var duration = const Duration(milliseconds: 2500);
    return Timer(duration, () {
      if (token != null) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              return const MainBottomNavigation();
            },
          ), (_) => false,
        );
      } else {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              return const LoginPage();
            },
          ), (_) => false,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loginState(context);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    DateTime dateNow = DateTime.now();
    await prefs.setString('start_date', dateNow.toString());
    await prefs.setString('end_date', dateNow.toString());
  }

  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape ? LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double columnWidth = screenWidth / 2;
            return Scaffold(
              backgroundColor: yellow,
              body: Row(
                children: [
                  Center(
                    child: SizedBox(
                      width: columnWidth,
                      child: Image.asset(
                        'assets/mozaic/logo-baru-set-07.png',
                        width: 300,
                        height: 300,
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: columnWidth,
                      child: Image.asset(
                        'assets/mozaic/logo-vc.png',
                        width: 300,
                        height: 300,
                      ),
                    ),
                  ),
                ],
              )
            );
          },
        ) : Scaffold(
          backgroundColor: transparentYellow,
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/background.jpg'),
                        fit: BoxFit.cover
                    )
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: transparentYellow,
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/mozaic/logo-baru-set-07.png',
                        height: 250,
                        width: 250,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: RichText(
                      text: const TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(text: 'Powered by '),
                            TextSpan(
                                text: 'AHN Studio ',
                                 style: TextStyle(fontWeight: FontWeight.bold)
                            )
                          ]
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> loginState(context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
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
          // Token is valid, fetch user data and navigate to home screen
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) {
                return const MainBottomNavigation();
              },
            ),
                (_) => false,
          );
          CustomSnackbar.show(context, 'Selamat datang kembali');
        } else {
          // Token is invalid, clear token and navigate to login screen
          await prefs.remove('token');
          startTimer(context);
          CustomSnackbar.show(context, 'Sesi login habis! silahkan login kembali', backgroundColor: Colors.red);
        }
      } catch (e) {
        // Handle errors
        /*print(e);*/
        // Consider clearing token and navigating to login screen
        await prefs.remove('token');
        startTimer(context);
      }
    } else {
      startTimer(context);
    }
  }

  void startTimer(context) {
    timer = Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }
}
