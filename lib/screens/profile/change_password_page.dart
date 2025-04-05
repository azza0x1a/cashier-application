import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:mozaic_app/widget/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style/app_properties.dart';
import '../../widget/custom_loading.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String userId = '';
  String userName = '';
  String userGroupName = '';
  String token = '';
  String oldPassword = '';
  String newPassword = '';
  late FocusNode myFocusNode;
  late FocusNode myFocusNodeTwo;
  late bool obscureOldPassword;
  late bool obscureNewPassword;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    myFocusNode = FocusNode();
    myFocusNodeTwo = FocusNode();
    obscureOldPassword = true;
    obscureNewPassword = true;
  }

  Future<void> loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id')!;
      userName = prefs.getString('username')!;
      userGroupName = prefs.getString('user_group_name')!;
      token = prefs.getString('token')!;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Mobile View
    Widget changePasswordButton = ElevatedButton.icon(
      onPressed: () {
        changePasswordValidation(context);
      },
      icon: const Icon(
        Icons.save,
        color: Colors.white,
        size: 16,
      ),
      label: const Text(
        'Simpan',
        style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat'
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 0, 130, 198),
        foregroundColor: Colors.white,
        shadowColor: Colors.orangeAccent,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape ? LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double columnWidth = screenWidth / 2;
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                scrolledUnderElevation: 0,
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                backgroundColor: Colors.transparent,
                title: const Text(
                  'Ganti Password',
                  style: TextStyle(
                      color: darkGrey,
                      fontSize: 28
                  ),
                ),
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: columnWidth,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/mozaic/logo-baru-set-07.png'),
                          fit: BoxFit.contain,
                        )
                    ),
                  ),
                  SizedBox(
                    width: columnWidth,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Card(
                            elevation: 2,
                            shadowColor: Colors.grey,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Password Lama',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.15),
                                                  blurRadius: 6,
                                                )
                                              ],
                                            ),
                                            child: TextFormField(
                                              controller: oldPasswordController,
                                              onChanged: (text) {
                                                oldPassword = text;
                                              },
                                              cursorColor: Colors.orange,
                                              obscureText: obscureOldPassword,
                                              keyboardType: TextInputType.text,
                                              textInputAction: TextInputAction.next,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding: const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 15
                                                  ),
                                                  hintText: 'Masukkan password lama anda',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      !obscureOldPassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                                                      color: Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        obscureOldPassword = !obscureOldPassword;
                                                      });
                                                    },
                                                  )
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 2,
                            shadowColor: Colors.grey,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Password Baru',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.15),
                                                  blurRadius: 6,
                                                )
                                              ],
                                            ),
                                            child: TextFormField(
                                              controller: newPasswordController,
                                              onChanged: (text) {
                                                newPassword = text;
                                              },
                                              obscureText: obscureNewPassword,
                                              cursorColor: Colors.orange,
                                              keyboardType: TextInputType.text,
                                              textInputAction: TextInputAction.done,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding: const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 15
                                                  ),
                                                  hintText: 'Masukkan password baru anda',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      !obscureNewPassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                                                      color: Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        obscureNewPassword = !obscureNewPassword;
                                                      });
                                                    },
                                                  )
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          changePasswordButton
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ) : Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Color.fromARGB(255, 0, 130, 198),
            title: const Text(
              'Setting Password',
              style: TextStyle(
                  color: darkGrey,
                  fontSize: 18
              ),
            ),
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          body: SafeArea(
              bottom: true,
              child: LayoutBuilder(
                builder: (b, constraints) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Card(
                            elevation: 2,
                            shadowColor: Colors.grey,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Password Lama',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.15),
                                                  blurRadius: 6,
                                                )
                                              ],
                                            ),
                                            child: TextFormField(
                                              controller: oldPasswordController,
                                              onChanged: (text) {
                                                oldPassword = text;
                                              },
                                              cursorColor: Colors.orange,
                                              obscureText: obscureOldPassword,
                                              keyboardType: TextInputType.text,
                                              textInputAction: TextInputAction.next,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding: const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 15
                                                  ),
                                                  hintText: 'Masukkan password lama anda',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.normal
                                                   ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      !obscureOldPassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                                                      color: Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        obscureOldPassword = !obscureOldPassword;
                                                      });
                                                    },
                                                  )
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 2,
                            shadowColor: Colors.grey,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Password Baru',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.15),
                                                  blurRadius: 6,
                                                )
                                              ],
                                            ),
                                            child: TextFormField(
                                              controller: newPasswordController,
                                              onChanged: (text) {
                                                newPassword = text;
                                              },
                                              obscureText: obscureNewPassword,
                                              cursorColor: Colors.orange,
                                              keyboardType: TextInputType.text,
                                              textInputAction: TextInputAction.done,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding: const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 15
                                                  ),
                                                  hintText: 'Masukkan password baru anda',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      !obscureNewPassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                                                      color: Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        obscureNewPassword = !obscureNewPassword;
                                                      });
                                                    },
                                                  )
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          changePasswordButton
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ),
        );
      },
    );
  }

  void changePasswordValidation(context) async {
    bool isLoginValid = true;
    FocusScope.of(context).requestFocus(FocusNode());

    if (oldPasswordController.text.isEmpty && newPasswordController.text.isEmpty) {
      isLoginValid = false;
      CustomSnackbar.show(context, 'Semua Form Harus Diisi', backgroundColor: Colors.red);
    } else if (oldPasswordController.text.isEmpty) {
      isLoginValid = false;
      CustomSnackbar.show(context, 'Password Lama Harus Diisi', backgroundColor: Colors.red);
    } else if (newPasswordController.text.isEmpty) {
      isLoginValid = false;
      CustomSnackbar.show(context, 'Password Baru Harus Diisi', backgroundColor: Colors.red);
    }
    if (isLoginValid) {
      fetchChangePassword(context);
    }
  }

  void fetchChangePassword(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.changePassword,
        data: {
          'user_id': userId,
          'old_password': oldPassword,
          'new_password': newPassword,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        //Messsage
        CustomSnackbar.show(context, 'Password Berhasil Diganti');
      }
    } on DioException catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        // print(e.message);
      }
    }
  }
}