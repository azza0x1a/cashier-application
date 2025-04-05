import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../widget/custom_snackbar.dart';

class ModalItemPage extends StatefulWidget {
  const ModalItemPage({super.key});

  @override
  State<ModalItemPage> createState() => _ModalItemPageState();
}

class _ModalItemPageState extends State<ModalItemPage> {
  String userId = '';
  String userName = '';
  String userGroupName = '';
  String token = '';
  String itemCode = '';
  String itemName = '';
  String itemRemark = '';
  String itemUnitCost = '';
  String itemUnitPrice = '';
  String itemDefaultQuantity = '';
  String itemCategory = '';
  var itemCategoryJson = [];
  String itemUnit = '';
  var itemUnitJson = [];
  int? itemCategoryId;
  int? itemUnitId;

  final productCodeController = TextEditingController();
  final productNameController = TextEditingController();
  final productRemarkController = TextEditingController();
  final productStandardController = TextEditingController();
  final productPurchaseController = TextEditingController();
  final productSellingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    fetchItemUnit(context);
  }

  void rebuild() {
    loadSharedPreference();
    fetchItemUnit(context);
  }

  Future<void> loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id')!;
      userName = prefs.getString('username')!;
      userGroupName = prefs.getString('user_group_name')!;
      itemCategory = prefs.getString('itemcategory')!;
      itemCategoryJson = json.decode(itemCategory);
      itemCategoryId = itemCategoryJson[0]['item_category_id'];
      token = prefs.getString('token')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget confirmButton = ElevatedButton.icon(
      onPressed: () {
        addProductValidation(context);
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
      initialChildSize: 1,
      snap: true,
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
                  "Tambah Produk",
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
                      bottom: MediaQuery.of(context).viewInsets.bottom,
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
                                          'Pilih Kategori Produk',
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
                                                        value: itemCategoryId,
                                                        hint: const Text('Pilih kategori produk'),
                                                        items: itemCategoryJson.map((item) {
                                                          return DropdownMenuItem<int>(
                                                            value: item['item_category_id'],
                                                            child: Text(item['item_category_name']),
                                                          );
                                                        }).toList(),
                                                        onChanged: (newVal) {
                                                          setState(() {
                                                            itemCategoryId = newVal as int;
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
                                          'Kode Produk',
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
                                                    controller: productCodeController,
                                                    cursorColor: Colors.orange,
                                                    keyboardType: TextInputType.text,
                                                    textInputAction: TextInputAction.next,
                                                    onChanged: (text) {
                                                      itemCode = text;
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
                                                      hintText: 'Masukkan kode produk',
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
                                          'Nama Produk',
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
                                                    controller: productNameController,
                                                    cursorColor: Colors.orange,
                                                    keyboardType: TextInputType.text,
                                                    textInputAction: TextInputAction.next,
                                                    onChanged: (text) {
                                                      itemName = text;
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
                                                      hintText: 'Masukkan nama produk',
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
                                                    controller: productRemarkController,
                                                    cursorColor: Colors.orange,
                                                    keyboardType: TextInputType.text,
                                                    textInputAction: TextInputAction.done,
                                                    onChanged: (text) {
                                                      itemRemark = text;
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
                                          'Pilih Jenis Satuan',
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
                                                        value: itemUnitId,
                                                        hint: const Text('Pilih jenis satuan'),
                                                        items: itemUnitJson.map((item) {
                                                          return DropdownMenuItem<int>(
                                                            value: item['item_unit_id'],
                                                            child: Text(item['item_unit_name']),
                                                          );
                                                        }).toList(),
                                                        onChanged: (newVal) {
                                                          setState(() {
                                                            itemUnitId = newVal as int;
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
                                /*Card(
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
                                          'Kuantitas Standar',
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
                                                    cursorColor: Colors.orange,
                                                    keyboardType: TextInputType.text,
                                                    textInputAction: TextInputAction.next,
                                                    onChanged: (text) {
                                                      item_default_quantity = text;
                                                    },
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.normal
                                                    ),
                                                    decoration: const InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding: EdgeInsets.symmetric(
                                                          vertical: 15, horizontal: 15),
                                                      hintText: 'Masukkan kuantitas standar',
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
                                ),*/
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
                                          'Harga Beli',
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
                                                    controller: productPurchaseController,
                                                    cursorColor: Colors.orange,
                                                    keyboardType: TextInputType.number,
                                                    textInputAction: TextInputAction.next,
                                                    onChanged: (text) {
                                                      itemUnitCost = text;
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
                                                      hintText: 'Masukkan harga beli',
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
                                          'Harga Jual',
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
                                                    controller: productSellingController,
                                                    cursorColor: Colors.orange,
                                                    keyboardType: TextInputType.number,
                                                    textInputAction: TextInputAction.done,
                                                    onChanged: (text) {
                                                      itemUnitPrice = text;
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
                                                      hintText: 'Masukkan harga jual',
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

  void addProductValidation(context) async {
    bool isLoginValid = true;
    FocusScope.of(context).requestFocus(FocusNode());

    if (productCodeController.text.isEmpty && productNameController.text.isEmpty && productPurchaseController.text.isEmpty && productSellingController.text.isEmpty) {
      isLoginValid = false;
      Navigator.pop(context);
      CustomSnackbar.show(context, 'Semua Form Harus Diisi', backgroundColor: Colors.red);
    } else if (productCodeController.text.isEmpty) {
      isLoginValid = false;
      Navigator.pop(context);
      CustomSnackbar.show(context, 'Kode Produk Harus Diisi', backgroundColor: Colors.red);
    } else if (productNameController.text.isEmpty) {
      isLoginValid = false;
      Navigator.pop(context);
      CustomSnackbar.show(context, 'Nama Produk Harus Diisi', backgroundColor: Colors.red);
    } else if (productPurchaseController.text.isEmpty) {
      isLoginValid = false;
      Navigator.pop(context);
      CustomSnackbar.show(context, 'Harga Beli Harus Diisi', backgroundColor: Colors.red);
    } else if (productSellingController.text.isEmpty) {
      isLoginValid = false;
      Navigator.pop(context);
      CustomSnackbar.show(context, 'Harga Jual Harus Diisi', backgroundColor: Colors.red);
    }
    if (isLoginValid) {
      insertItem(context);
    }
  }

  Future<void> fetchItemUnit(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.itemUnit,
        data: {
          'user_id': userId
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        setState(() {
          itemUnit = json.encode(response.data['data']);
          itemUnitJson = response.data['data'];
          itemUnitId = itemUnitJson[0]['item_unit_id'];
        });
        //NewItemPage
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

  Future<void> insertItem(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.itemAdd,
        data: {
          'user_id': userId,
          'item_category_id': itemCategoryId,
          'item_unit_id': itemUnitId,
          'item_code': itemCode,
          'item_name': itemName,
          'item_remark': itemRemark,
          /*'item_default_quantity': item_default_quantity,*/
          'item_default_quantity': 1,
          'item_unit_cost': itemUnitCost,
          'item_unit_price': itemUnitPrice,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        Navigator.pop(context, true);
        // Message
        CustomSnackbar.show(context, 'Produk Berhasil Ditambah');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        // Message
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
        Navigator.pop(context, true);
      } else {
        /*print(e.message);*/
        Navigator.pop(context, true);
      }
    }
  }
}
