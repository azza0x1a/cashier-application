import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:mozaic_app/screens/main/main_bottom_navigation.dart';
import 'package:mozaic_app/widget/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style/app_properties.dart';

class CapitalMoneyPage extends StatefulWidget {
  const CapitalMoneyPage({super.key});

  @override
  State<CapitalMoneyPage> createState() => _CapitalMoneyPageState();
}

class _CapitalMoneyPageState extends State<CapitalMoneyPage> {
  String userId = '';
  String userName = '';
  String userGroupName = '';
  String token = '';
  late FocusNode myFocusNode;
  late FocusNode myFocusNodeTwo;
  late bool obscureText;
  DateTime date = DateTime.now();
  int capitalAmount = 0;

  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    myFocusNode = FocusNode();
    myFocusNodeTwo = FocusNode();
    obscureText = true;
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
    Widget capitalMoneyButton = ElevatedButton.icon(
      onPressed: () {
        capitalMoneyValidation(context);
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
                  'Uang Modal',
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
                  Expanded(
                    child: VerticalDivider(
                      width: 1,
                      color: Colors.grey.withOpacity(0.4),
                    ),
                  ),
                  Container(
                    width: columnWidth,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20
                    ),
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
                                    'Tanggal',
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
                                              readOnly: true,
                                              initialValue: date.toString().substring(0, 10),
                                              key: Key(date.toString().substring(0, 10)),
                                              onTap: () {
                                                // FocusScope.of(context).requestFocus(FocusNode());
                                                // _selectDate();
                                              },
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 15
                                                ),
                                                hintText: 'Set tanggal awal',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.normal
                                                ),
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
                                    'Jumlah',
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
                                              key: Key(capitalAmount.toString()),
                                              onChanged: (value) {
                                                capitalAmount = int.parse(value);
                                              },
                                              cursorColor: Colors.orange,
                                              keyboardType: TextInputType.number,
                                              textInputAction: TextInputAction.done,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 15
                                                ),
                                                hintText: 'Masukkan jumlah',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.normal
                                                ),
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
                          capitalMoneyButton
                        ],
                      ),
                    ),
                  )
                ],
              )
            );
          },
        ) : Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: darkGrey),
            backgroundColor: Color.fromARGB(255, 0, 130, 198),
            title: const Text(
              'Uang Modal',
              style: TextStyle(
                color: darkGrey,
                fontSize: 18,
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
                                    'Tanggal',
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
                                              readOnly: true,
                                              initialValue: date.toString().substring(0, 10),
                                              key: Key(date.toString().substring(0, 10)),
                                              onTap: () {
                                                // FocusScope.of(context).requestFocus(FocusNode());
                                                // _selectDate();
                                              },
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 15
                                                ),
                                                hintText: 'Set tanggal awal',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.normal
                                                ),
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
                                    'Jumlah',
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
                                              key: Key(capitalAmount.toString()),
                                              onChanged: (value) {
                                                capitalAmount = int.parse(value);
                                              },
                                              cursorColor: Colors.orange,
                                              keyboardType: TextInputType.number,
                                              textInputAction: TextInputAction.done,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 15
                                                ),
                                                hintText: 'Masukkan jumlah',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.normal
                                                ),
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
                          capitalMoneyButton
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

  /*void _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2016),
        lastDate: DateTime(2069));
    if (picked != null) setState(() => date = picked);
    print(date);
  }*/

  void capitalMoneyValidation(context) async {
    bool isLoginValid = true;
    FocusScope.of(context).requestFocus(FocusNode());

    if (amountController.text.isEmpty) {
      isLoginValid = false;
      CustomSnackbar.show(context, 'Masukkan Jumlah Uang Modal', backgroundColor: Colors.red);
    }
    if (isLoginValid) {
      insertCapitalMoney(context);
    }
  }

  void insertCapitalMoney(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    // showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.capitalMoney,
        data: {
          'user_id': userId,
          'capital_money_amount': capitalAmount,
          'capital_money_date': date.toString(),
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        // hideLoaderDialog(context);
        //SalesPage
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainBottomNavigation()));
        //Messsage
        CustomSnackbar.show(context, 'Uang Modal Berhasil Disimpan');
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
}