import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:mozaic_app/screens/category/category_page.dart';
import 'package:mozaic_app/widget/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style/app_properties.dart';
import '../../widget/custom_loading.dart';

class EditItemPage extends StatefulWidget {
  final Map<String, dynamic> itemDetailJson;
  const EditItemPage({super.key, required this.itemDetailJson});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
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
  var itemUnitJson = [];
  String itemUnit = '';
  String itemDetail = '';

  late FocusNode myFocusNode;
  late FocusNode myFocusNodeTwo;
  late FocusNode myFocusNodeThree;
  late FocusNode myFocusNodeFour;
  late FocusNode myFocusNodeFive;
  late FocusNode myFocusNodeSix;
  late bool obscureText;

  int? itemCategoryId;
  int? itemUnitId;
  int? itemId;

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    myFocusNode = FocusNode();
    myFocusNodeTwo = FocusNode();
    myFocusNodeThree = FocusNode();
    myFocusNodeFour = FocusNode();
    myFocusNodeFive = FocusNode();
    myFocusNodeSix = FocusNode();
    obscureText = true;
    fetchItemUnit(context);
  }

  Future<void> loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id')!;
      userName = prefs.getString('username')!;
      userGroupName = prefs.getString('user_group_name')!;
      token = prefs.getString('token')!;
      itemCategory = prefs.getString('itemcategory')!;
      itemCategoryJson = json.decode(itemCategory);
      itemId = widget.itemDetailJson['item_id'];
      itemUnitId = widget.itemDetailJson['item_unit_id'];
      itemCategoryId = widget.itemDetailJson['item_category_id'];
      itemCode = widget.itemDetailJson['item_code'];
      itemName = widget.itemDetailJson['item_name'];
      itemRemark = widget.itemDetailJson['item_remark'] ?? "";
      itemDefaultQuantity = widget.itemDetailJson['item_default_quantity'];
      itemUnitCost = widget.itemDetailJson['item_unit_cost'];
      itemUnitPrice = widget.itemDetailJson['item_unit_price'];
    });
  }

  @override
  Widget build(BuildContext context) {

    // Mobile View
    Widget simpanButton = ElevatedButton.icon(
      onPressed: () {
        updateItem(context);
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

    // Landscape View
    Widget simpanButtonLandscape = ElevatedButton.icon(
      onPressed: () {
        updateItem(context);
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

    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape ? LayoutBuilder(
          builder: (context, constraints) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                margin: const EdgeInsets.only(top: kToolbarHeight),
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Item',
                          style: TextStyle(
                            color: darkGrey,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CloseButton()
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 36),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                Column(
                                  children: [
                                    Card(
                                      color: Colors.white,
                                      elevation: 8,
                                      surfaceTintColor: Colors.grey.shade400,
                                      shadowColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(28),
                                        width: MediaQuery.of(context).size.width,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      'Pilih Kategori',
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
                                                                    hint: const Text('Pilih jenis pengeluaran'),
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
                                                      'Kode Barang',
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
                                                                initialValue: widget.itemDetailJson['item_code'],
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
                                                      'Nama Barang',
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
                                                                initialValue: widget.itemDetailJson['item_name'],
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
                                                                cursorColor: Colors.orange,
                                                                keyboardType: TextInputType.text,
                                                                textInputAction: TextInputAction.next,
                                                                initialValue: widget.itemDetailJson['item_remark'],
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
                                                      'Pilih Satuan',
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
                                                                    hint: const Text('Pilih jenis pengeluaran'),
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
                                                        initialValue: widget.itemDetailJson['item_default_quantity'],
                                                        onChanged: (text) {
                                                          itemDefaultQuantity = text;
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
                                            Row(
                                              children: [
                                                Flexible(
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
                                                                      cursorColor: Colors.orange,
                                                                      keyboardType: TextInputType.text,
                                                                      textInputAction: TextInputAction.next,
                                                                      initialValue: widget.itemDetailJson['item_unit_cost'],
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
                                                const SizedBox(width: 10),
                                                Flexible(
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
                                                                      cursorColor: Colors.orange,
                                                                      keyboardType: TextInputType.text,
                                                                      textInputAction: TextInputAction.next,
                                                                      initialValue: widget.itemDetailJson['item_unit_price'],
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
                                              ],
                                            ),
                                            const SizedBox(height: 40),
                                            Center(
                                                child: simpanButtonLandscape
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 48),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ) : Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
              ),
              child: Container(
                margin: const EdgeInsets.only(top: kToolbarHeight),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Item',
                          style: TextStyle(
                            color: darkGrey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CloseButton()
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 4,
                          surfaceTintColor: Colors.grey.shade200,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                          'Pilih Kategori',
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
                                                        hint: const Text('Pilih jenis pengeluaran'),
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
                                          'Kode Barang',
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
                                                    initialValue: widget.itemDetailJson['item_code'],
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
                                          'Nama Barang',
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
                                                    initialValue: widget.itemDetailJson['item_name'],
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
                                                    cursorColor: Colors.orange,
                                                    keyboardType: TextInputType.text,
                                                    textInputAction: TextInputAction.next,
                                                    initialValue: widget.itemDetailJson['item_remark'],
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
                                          'Pilih Satuan',
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
                                                        hint: const Text('Pilih jenis pengeluaran'),
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
                                                        initialValue: widget.itemDetailJson['item_default_quantity'],
                                                        onChanged: (text) {
                                                          itemDefaultQuantity = text;
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
                                Row(
                                  children: [
                                    Flexible(
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
                                                          cursorColor: Colors.orange,
                                                          keyboardType: TextInputType.text,
                                                          textInputAction: TextInputAction.next,
                                                          initialValue: widget.itemDetailJson['item_unit_cost'],
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
                                    const SizedBox(width: 10),
                                    Flexible(
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
                                                          cursorColor: Colors.orange,
                                                          keyboardType: TextInputType.text,
                                                          textInputAction: TextInputAction.next,
                                                          initialValue: widget.itemDetailJson['item_unit_price'],
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
                                  ],
                                ),
                                const SizedBox(height: 40),
                                Center(
                                    child: simpanButton
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchItemUnit(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
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
        // Berhasil
        hideLoaderDialog(context);
        setState(() {
          itemUnit = json.encode(response.data['data']);
          itemUnitJson = json.decode(itemUnit);
        });
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

  Future<void> updateItem(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.itemUpdate,
        data: {
          'user_id': userId,
          'item_id': itemId,
          'item_category_id': itemCategoryId,
          'item_unit_id': itemUnitId,
          'item_name': itemName,
          'item_code': itemCode,
          /*'item_default_quantity': item_default_quantity,*/
          'item_default_quantity': 1,
          'item_unit_cost': itemUnitCost,
          'item_unit_price': itemUnitPrice,
          'item_remark': itemRemark,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        // Category Page
        setState(() {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const CategoryPage()));
        });
        //Messsage
        CustomSnackbar.show(context, 'Edit Barang Berhasil');
        //EditItemPage
      }
    } on DioException catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        /*print(e.message);*/
      }
    }
  }
}