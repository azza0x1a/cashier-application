import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widget/custom_loading.dart';
import '../../../widget/custom_snackbar.dart';

class ExpenditureFormPageTablet extends StatefulWidget {
  const ExpenditureFormPageTablet({super.key});

  @override
  State<ExpenditureFormPageTablet> createState() => _ExpenditureFormPageTabletState();
}

class _ExpenditureFormPageTabletState extends State<ExpenditureFormPageTablet> {
  String userName = '';
  String userId = '';
  String userGroupName = '';
  String token = '';
  DateTime date = DateTime.now();
  int expenditureAmount = 0;
  String expenditureRemark = '';
  var expenditureAccountJson = [];
  int? accountId;

  final remarkController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    fetchExpenditureAccount(context);
  }

  loadSharedPreference() async {
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
    Widget confirmButton = ElevatedButton.icon(
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
      onPressed: () {
        expenditureValidation(context);
      },
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
      initialChildSize: 0.8,
      snap: true,
      snapSizes: const [0.8, 1],
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
              vertical: 24,
              horizontal: 10
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
                  "Pengeluaran",
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
                                          'Pilih Jenis Pengeluaran',
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
                                                    child: DropdownButtonHideUnderline(
                                                      child: DropdownButton<int>(
                                                        borderRadius: BorderRadius.circular(10),
                                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                                        focusColor: Colors.grey,
                                                        menuMaxHeight: 400,
                                                        isExpanded: true,
                                                        elevation: 2,
                                                        value: accountId,
                                                        hint: const Text('Pilih jenis pengeluaran'),
                                                        items: expenditureAccountJson.map((item) {
                                                          return DropdownMenuItem<int>(
                                                            value: item['account_id'],
                                                            child: Text(item['account_name']),
                                                          );
                                                        }).toList(),
                                                        onChanged: (newVal) {
                                                          setState(() {
                                                            accountId = newVal as int;
                                                          });
                                                        },
                                                      ),
                                                    )
                                                )
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
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
                                          'Keterangan',
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
                                                    controller: remarkController,
                                                    cursorColor: Colors.orange,
                                                    keyboardType: TextInputType.text,
                                                    textInputAction: TextInputAction.next,
                                                    key: Key(expenditureRemark),
                                                    onChanged: (value) {
                                                      expenditureRemark = value;
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.normal
                                                    ),
                                                    decoration: const InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 15, horizontal: 15),
                                                      hintText: 'Masukkan keterangan',
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
                                const SizedBox(height: 4),
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
                                                    controller: amountController,
                                                    cursorColor: Colors.orange,
                                                    keyboardType: TextInputType.number,
                                                    textInputAction: TextInputAction.done,
                                                    key: Key(expenditureAmount.toString()),
                                                    onChanged: (value) {
                                                      expenditureAmount = int.parse(value);
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.normal
                                                    ),
                                                    decoration: const InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 15, horizontal: 15),
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
                                const SizedBox(height: 20),
                                Center(
                                  child: confirmButton,
                                )
                              ],
                            )
                          ],
                        )
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

  void expenditureValidation(context) async {
    bool isLoginValid = true;
    FocusScope.of(context).requestFocus(FocusNode());

    if (remarkController.text.isEmpty && amountController.text.isEmpty) {
      isLoginValid = false;
      Navigator.pop(context);
      CustomSnackbar.show(context, 'Semua Form Harus Diisi', backgroundColor: Colors.red);
    } else if (remarkController.text.isEmpty) {
      isLoginValid = false;
      Navigator.pop(context);
      CustomSnackbar.show(context, 'Keterangan Harus Diisi', backgroundColor: Colors.red);
    } else if (amountController.text.isEmpty) {
      isLoginValid = false;
      Navigator.pop(context);
      CustomSnackbar.show(context, 'Jumlah Harus Diisi', backgroundColor: Colors.red);
    }
    if (isLoginValid) {
      insertExpenditure(context);
    }
  }

  void fetchExpenditureAccount(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.expenditureGetAccount,
        data: {},
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        //Messsage
        setState(() {
          expenditureAccountJson = response.data['expenditureaccount'];
          accountId = expenditureAccountJson[0]['account_id'];
        });
        //NewItemPage
      }
    } on DioException catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];

        Navigator.pop(context, true);
        // Message
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        // print(e.message);
        Navigator.pop(context, true);
      }
    }
  }

  void insertExpenditure(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.expenditure,
        data: {
          'user_id': userId,
          'account_id': accountId,
          'expenditure_remark': expenditureRemark,
          'expenditure_amount': expenditureAmount,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        hideLoaderDialog(context);

        Navigator.pop(context, true);
        // Message
        CustomSnackbar.show(context, 'Pengeluaran Berhasil Disimpan');
      }
    } on DioException catch (e) {
      /*print(e);*/
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        // Message
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
        Navigator.pop(context, true);
      } else {
        // print(e.message);
        Navigator.pop(context, true);
      }
    }
  }
}
