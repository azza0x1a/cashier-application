import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../widget/custom_loading.dart';
import '../../widget/custom_snackbar.dart';

class PrinterKitchenAddressPage extends StatefulWidget {
  const PrinterKitchenAddressPage({super.key});

  @override
  State<PrinterKitchenAddressPage> createState() => _PrinterKitchenAddressPageState();
}

class _PrinterKitchenAddressPageState extends State<PrinterKitchenAddressPage> {
  String userId = '';
  String userName = '';
  String userGroupName = '';
  String token = '';
  String printerKitchenAddress = '';

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    fetchPrinterKitchenAddress(context);
  }

  Future<void> loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id')!;
      userName = prefs.getString('username')!;
      userGroupName = prefs.getString('user_group_name')!;
      token = prefs.getString('token')!;
      printerKitchenAddress = prefs.getString('printer_kitchen_address')!;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Tablet View
    Widget printButtonTablet = ElevatedButton.icon(
      onPressed: () {
        updatePrinterAddress(context);
      },
      icon: const Icon(
        Icons.save,
        color: Colors.white,
        size: 18,
      ),
      label: const Text(
        'Simpan',
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat'
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        shadowColor: Colors.orangeAccent,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      snap: true,
      snapSizes: const [0.6, 1],
      minChildSize: 0.6,
      expand: false,
      shouldCloseOnMinExtent: false,
      builder: (context, scrollController) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.9),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)
              )
          ),
          padding: const EdgeInsets.symmetric(
              vertical: 24
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    bottom: 10
                ),
                height: 4,
                width: double.infinity,
                child: SvgPicture.asset(
                  'assets/icons/divider-icon.svg',
                  height: 4,
                  width: 50,
                ),
              ),
              const Center(
                child: Text(
                  "Setting Printer Dapur",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 40),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40
                                  ),
                                  child: Card(
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
                                            'Mac Address Printer Dapur',
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
                                                      key: Key(printerKitchenAddress),
                                                      initialValue: printerKitchenAddress,
                                                      onChanged: (text) {
                                                        printerKitchenAddress = text;
                                                      },
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F:]')),
                                                        TextInputFormatter.withFunction((oldValue, newValue) {
                                                          final newText = newValue.text.replaceAllMapped(
                                                            RegExp(r'([0-9a-fA-F]{2})(?!:)'),
                                                                (match) => '${match.group(0)}:',
                                                          );
                                                          return TextEditingValue(
                                                            text: newText,
                                                            selection: TextSelection.collapsed(offset: newText.length),
                                                          );
                                                        }),
                                                      ],
                                                      cursorColor: Colors.orange,
                                                      keyboardType: TextInputType.text,
                                                      textInputAction: TextInputAction.done,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.normal
                                                      ),
                                                      decoration: const InputDecoration(
                                                        hintText: '00:11:22:33:44:55',
                                                        border: InputBorder.none,
                                                        contentPadding: EdgeInsets.symmetric(
                                                            vertical: 15,
                                                            horizontal: 15
                                                        ),
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
                                ),
                                const SizedBox(height: 20),
                                printButtonTablet
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> updatePrinterAddress(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.printerKitchenUpdate,
        data: {
          'user_id': userId,
          'printer_kitchen_address': printerKitchenAddress
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        String prefPrinterKitchenAddress = printerKitchenAddress;
        await prefs.setString('printer_kitchen_address', prefPrinterKitchenAddress);
        Navigator.pop(context);
        // Message
        CustomSnackbar.show(context, 'Printer Berhasil Disimpan');
      }
    } on DioException catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        // Message
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
        Navigator.pop(context);
      } else {
        /*print(e.message);*/
      }
    }
  }

  Future<void> fetchPrinterKitchenAddress(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
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
        //berhasil
        String prefPrinterKitchenAddress = response.data['data'];
        await prefs.setString('printer_kitchen_address', prefPrinterKitchenAddress);
        printerKitchenAddress = prefPrinterKitchenAddress;
        //Messsage
        //SettingsPage
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        // Message
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        /*print(e.message);*/
      }
    }
  }
}