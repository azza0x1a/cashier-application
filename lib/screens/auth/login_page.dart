import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:mozaic_app/widget/custom_snackbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../style/app_properties.dart';
import '../../widget/custom_loading.dart';
import '../main/main_bottom_navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late bool obscureText;
  late bool obscureText2;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    obscureText = true;
    obscureText2 = true;
    // loadSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    //Mobile View
    Widget appName = const Text(
      'Aplikasi Cashion',
      style: TextStyle(
          color: Colors.black,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10,
            )
          ]
      ),
    );

    Widget appProduct = const Align(
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          Text(
            'Point',
            style: TextStyle(
                color: secondaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                shadows: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    offset: Offset(0, 5),
                    blurRadius: 10,
                  )
                ]
            ),
          ),
          SizedBox(width: 5),
          Text(
            'of',
            style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                shadows: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    offset: Offset(0, 5),
                    blurRadius: 10,
                  )
                ]
            ),
          ),
          SizedBox(width: 5),
          Text(
            'Sales',
            style: TextStyle(
                color: secondaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                shadows: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    offset: Offset(0, 5),
                    blurRadius: 10,
                  )
                ]
            ),
          ),
        ],
      ),
    );

    Widget subTitle = const Padding(
        padding: EdgeInsets.only(right: 56),
        child: Text(
          'Silahkan Login menggunakan\nAkun yang sudah terdaftar',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        )
    );

    Widget loginButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 46,
      child: InkWell(
        onTap: () {
          loginValidation(context);
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 60,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(236, 60, 3, 1),
                    Color.fromRGBO(234, 60, 3, 1),
                    Color.fromRGBO(216, 78, 16, 1),
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10,
                )
              ],
              borderRadius: BorderRadius.circular(9)
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.login,
                color: Colors.white,
                size: 26,
              ),
              Text(
                'Login',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.normal
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget loginForm = SizedBox(
      height: 220,
      child: Stack(
        children: [
          Container(
            height: 145,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 32, right: 12),
            decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)
                )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Username',
                      hintStyle: TextStyle(
                          color: Color.fromARGB(255, 143, 143, 143)
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                          child: TextField(
                            controller: passwordController,
                            obscureText: obscureText,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 143, 143, 143)
                              ),
                            ),
                          )
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        !obscureText ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          loginButton,
        ],
      ),
    );

    Widget trialButton = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            registerGuest(context);
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: 30,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(236, 60, 3, 1),
                      Color.fromRGBO(234, 60, 3, 1),
                      Color.fromRGBO(216, 78, 16, 1),
                    ],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.16),
                    offset: Offset(0, 5),
                    blurRadius: 10,
                  )
                ],
                borderRadius: BorderRadius.circular(9.0)
            ),
            child: const Center(
              child: Text(
                'Buat Akun Percobaan',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal
                ),
              ),
            ),
          ),
        ),
      ],
    );

    Widget appVersion = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'App Version: ',
            style: TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          ),
          InkWell(
            onTap: () {
              _launchInBrowser();
            },
            child: Text(
              _packageInfo.version,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );

    // Tablet View
    Widget appNameLandscape = const Text(
      'Aplikasi Mozaic',
      style: TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10,
            )
          ]
      ),
    );

    Widget appProductLandscape = const Align(
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          Text(
            'Point',
            style: TextStyle(
                color: Colors.red,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                shadows: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    offset: Offset(0, 5),
                    blurRadius: 10,
                  )
                ]
            ),
          ),
          SizedBox(width: 10),
          Text(
            'of',
            style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                shadows: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    offset: Offset(0, 5),
                    blurRadius: 10,
                  )
                ]
            ),
          ),
          SizedBox(width: 10),
          Text(
            'Sales',
            style: TextStyle(
                color: Colors.red,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                shadows: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    offset: Offset(0, 5),
                    blurRadius: 10,
                  )
                ]
            ),
          ),
        ],
      ),
    );

    Widget subTitleLandscape = const Padding(
        padding: EdgeInsets.only(right: 112),
        child: Text(
          'Silahkan Login menggunakan\nAkun yang sudah terdaftar',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        )
    );

    Widget loginButtonLandscape = ElevatedButton.icon(
      icon: const Icon(
        Icons.login,
        size: 16,
      ),
      label: const Text(
        'Masuk',
        style: TextStyle(
            color: Colors.white,
            fontSize: 16
        ),
      ),
      onPressed: () {
        loginValidation(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        shadowColor: Colors.deepOrangeAccent,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );

    Widget loginFormLandscape = SizedBox(
      height: 160,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 64, right: 24),
            decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1.0),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)
                ),
                boxShadow: shadow
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Color.fromARGB(255, 143, 143, 143)),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                          child: TextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            obscureText: obscureText,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Color.fromARGB(255, 143, 143, 143)),
                            ),
                          )
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        !obscureText ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget appVersionLandscape = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'App Version: ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          InkWell(
            onTap: () {
              _launchInBrowser();
            },
            child: Text(
              _packageInfo.version,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.landscape ? Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                decoration: const BoxDecoration(
                    color: transparentYellow,
                    image: DecorationImage(
                      image: AssetImage('assets/mozaic/logo-baru-set-07.png'),
                      fit: BoxFit.contain,
                    )
                ),
              ),
              VerticalDivider(
                width: 1,
                color: Colors.grey.withOpacity(0.4),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 56),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      appNameLandscape,
                      appProductLandscape,
                      const SizedBox(height: 10),
                      subTitleLandscape,
                      const SizedBox(height: 20),
                      loginFormLandscape,
                      const SizedBox(height: 20),
                      Center(child: loginButtonLandscape),
                      const SizedBox(height: 40),
                      appVersionLandscape
                    ],
                  ),
                ),
              )
            ],
          ) : Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/back2.jpg'),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(flex: 2),
                      appName,
                      appProduct,
                      const SizedBox(height: 20),
                      subTitle,
                      const Spacer(),
                      loginForm,
                      trialButton,
                      const Spacer(flex: 1),
                      appVersion
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _launchInBrowser() async {
    Uri url = Uri.parse('http://www.ciptasolutindo.id');
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  void loginValidation(context) async {
    bool isLoginValid = true;
    FocusScope.of(context).requestFocus(FocusNode());

    if (emailController.text.isEmpty) {
      isLoginValid = false;
      CustomSnackbar.show(context, 'Username Tidak Boleh Kosong', backgroundColor: Colors.red);
    }

    if (passwordController.text.isEmpty) {
      isLoginValid = false;
      CustomSnackbar.show(context, 'Password Tidak Boleh Kosong', backgroundColor: Colors.red);
    }
    if (isLoginValid) {
      fetchLogin(context, emailController.text, passwordController.text);
    }
  }

  Future<void> fetchLogin(context, String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    try {
      Response response;
      var dio = Dio();
      response = await dio.post(
        Api.login,
        data: {'username': username, 'password': password},
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        //
        String prefUserId = response.data['data']['user_id'].toString();
        String prefUsername = response.data['data']['name'];
        String prefFullname = response.data['data']['full_name'];
        String prefUserGroup = response.data['data']['user_group_name'];
        String prefCreated = response.data['data']['created_at'];
        String prefGuestState = response.data['data']['guest_state'].toString();
        String prefToken = response.data['token'];

        await prefs.setString('username', prefUsername);
        await prefs.setString('full_name', prefFullname);
        await prefs.setString('user_id', prefUserId);
        await prefs.setString('user_group_name', prefUserGroup);
        await prefs.setString('created_at', prefCreated);
        await prefs.setString('guest_state', prefGuestState);
        await prefs.setString('token', prefToken);

        if (int.parse(prefGuestState) == 1 ) {
          final dateCreated = DateTime.parse(response.data['data']['created_at']);
          final dateNow = DateTime.now();
          final dateDifference = dateNow.difference(dateCreated).inDays;

          if (dateDifference >= 7) {
            expiredGuest(context);
            return;
          }
        }

        //Message
        CustomSnackbar.show(context, 'Login Berhasil');
        // homePage
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const MainBottomNavigation() ));
      }
    } on DioException catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        print(e.message);
        CustomSnackbar.show(context, 'Terjadi Kesalahan', backgroundColor: Colors.red);
      }
    }
  }

  registerGuest(context) async {
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    try {
      Response response;
      var dio = Dio();
      response = await dio.get(
        Api.register,
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        //setSharedPreference
        String prefUsername = response.data['data']['name'];
        String prefFullname = response.data['data']['full_name'];
        String prefUserId = response.data['data']['user_id'].toString();
        String prefUserGroup = response.data['data']['user_group_name'];
        String prefCreated = response.data['data']['created_at'];
        String prefGuestState = response.data['data']['guest_state'].toString();
        String prefToken = response.data['token'];
        await prefs.setString('username', prefUsername);
        await prefs.setString('full_name', prefFullname);
        await prefs.setString('user_id', prefUserId);
        await prefs.setString('user_group_name', prefUserGroup);
        await prefs.setString('created_at', prefCreated);
        await prefs.setString('guest_state', prefGuestState);
        await prefs.setString('token', prefToken);
        //Messsage
        CustomSnackbar.show(context, 'Register Berhasil');
        // homePage
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const MainBottomNavigation()));
      }
    } on DioException catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        print(e.message);
        CustomSnackbar.show(context, 'Terjadi Kesalahan', backgroundColor: Colors.red);
      }
    }
  }

  expiredGuest(context) {
    AlertDialog alert = const AlertDialog(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(
              "Akun percobaan telah berakhir !",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Untuk mendapatkan akses penuh silahkan hubungi : ",
              style: TextStyle(
                color: Color.fromARGB(255, 26, 189, 211),
                fontSize: 12,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "+62-812-2612-4600",
              style: TextStyle(
                  color: Color.fromARGB(255, 26, 189, 211),
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(
              "admin@ciptasolutindo.id",
              style: TextStyle(
                color: Color.fromARGB(255, 26, 189, 211),
                fontSize: 12,
              ),
            ),
            Text(
              "www.ciptasolutindo.id",
              style: TextStyle(
                color: Color.fromARGB(255, 26, 189, 211),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }
}