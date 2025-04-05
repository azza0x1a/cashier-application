 import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:mozaic_app/screens/main/main_bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../style/app_properties.dart';
import '../../utility/currency_format.dart';
import '../../widget/custom_loading.dart';
import '../../widget/custom_snackbar.dart';

class SalesDetailPage extends StatefulWidget {
  const SalesDetailPage({super.key});

  @override
  State<SalesDetailPage> createState() => _SalesDetailPageState();
}

class _SalesDetailPageState extends State<SalesDetailPage> {
  String userId = '';
  String userName = '';
  String userGroupName = '';
  String token = '';
  String? cartItems;
  String? descriptionItems;
  String item = '';
  var itemJson = [];
  late FocusNode myFocusNode;
  late FocusNode myFocusNodeTwo;
  late FocusNode myFocusNodeThree;
  late FocusNode myFocusNodeFour;
  late FocusNode myFocusNodeFive;
  late FocusNode myFocusNodeSix;
  late FocusNode myFocusNodeSeven;
  var cartItemsJson = [];
  var descriptionItemsJson = [];
  var cartItemsJsonForLoops = [];
  var descriptionItemsJsonForLoops = [];
  var preferenceCompany = '';
  var preferenceCompanyJson = [];
  final Map amountMap = {};
  final Map descriptionMap = {};
  var tableNo = '';
  num discountPercentageTotal = 0;
  num discountAmountTotal = 0;
  String ppnPercentageTotalString = '';
  double ppnPercentageTotal = 0;
  num ppnAmountTotal = 0;
  num subtotal = 0;
  num subtotalItem = 0;
  num total = 0;
  num paidAmount = 0;
  num indexButton = 0;

  final TextEditingController _discountPercentageController =
      TextEditingController(text: 0.toString());
  final TextEditingController _discountAmountController =
      TextEditingController(text: 0.toString());
  /*final TextEditingController _ppnPercentageController =
      TextEditingController(text: 0.toString());*/
  final TextEditingController _ppnAmountController =
      TextEditingController(text: 0.toString());

  String? _initialValue1;
  String? _initialValue2;
  /*String? _initialValue3;*/
  String? _initialValue4;

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  /*final FocusNode _focusNode3 = FocusNode();*/
  final FocusNode _focusNode4 = FocusNode();

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    // getPreferenceCompany(context);
    myFocusNode = FocusNode();
    myFocusNodeTwo = FocusNode();
    myFocusNodeThree = FocusNode();
    myFocusNodeFour = FocusNode();
    myFocusNodeFive = FocusNode();
    myFocusNodeSix = FocusNode();
    myFocusNodeSeven = FocusNode();

    _focusNode1.addListener(_onFocusChange1);
    _focusNode2.addListener(_onFocusChange2);
    /*_focusNode3.addListener(_onFocusChange3);*/
    _focusNode4.addListener(_onFocusChange4);
  }

  Future<void> loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id')!;
      userName = prefs.getString('username')!;
      userGroupName = prefs.getString('user_group_name')!;
      token = prefs.getString('token')!;
      item = prefs.getString('item')!;
      itemJson = json.decode(item);
      /*item_id = itemJson[0]['item_id'];*/
      cartItems = prefs.getString('cartitems');
      if (cartItems != null) {
        cartItemsJsonForLoops = json.decode(cartItems!);
        cartItemsJson = json.decode(cartItems!);
        for (var value in cartItemsJsonForLoops) {
          amountMap['amount_${value['item_id']}'] =
              value['quantity'];
          int quantity = value['quantity'];
          var subtotalPeritem = int.parse(value['item_unit_price']) * quantity;
          subtotal += subtotalPeritem;
          subtotalItem += quantity;
        }
        total = subtotal;
      }
      descriptionItems = prefs.getString('descriptionitems');
      if (descriptionItems != null) {
        descriptionItemsJsonForLoops = json.decode(descriptionItems!);
        descriptionItemsJson = json.decode(descriptionItems!);
        for (var value in descriptionItemsJsonForLoops) {
          descriptionMap['description_${value['item_id']}'] =
              value['description'];
        }
      }
    });
  }

  @override
  void dispose() {
    _focusNode1.removeListener(_onFocusChange1);
    _focusNode2.removeListener(_onFocusChange2);
    /*_focusNode3.removeListener(_onFocusChange3);*/
    _focusNode4.removeListener(_onFocusChange4);
    _focusNode1.dispose();
    _focusNode2.dispose();
    /*_focusNode3.dispose();*/
    _focusNode4.dispose();
    super.dispose();
  }

  void _onFocusChange1() {
    if (_focusNode1.hasFocus) {
      _initialValue1 = _discountPercentageController.text;
      _discountPercentageController.clear();
    } else if (_initialValue1 != null) {
      _discountPercentageController.text = _initialValue1!;
      _initialValue1 = null;
    }
  }

  void _onFocusChange2() {
    if (_focusNode2.hasFocus) {
      _initialValue2 = _discountAmountController.text;
      _discountAmountController.clear();
    } else if (_initialValue2 != null) {
      _discountAmountController.text = _initialValue2!;
      _initialValue2 = null;
    }
  }

  /*void _onFocusChange3() {
    if (_focusNode3.hasFocus) {
      _initialValue3 = _ppnPercentageController.text;
      _ppnPercentageController.clear();
    } else if (_initialValue3 != null) {
      _ppnPercentageController.text = _initialValue3!;
      _initialValue3 = null;
    }
  }*/

  void _onFocusChange4() {
    if (_focusNode4.hasFocus) {
      _initialValue4 = _ppnAmountController.text;
      _ppnAmountController.clear();
    } else if (_initialValue4 != null) {
      _ppnAmountController.text = _initialValue4!;
      _initialValue4 = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    // Mobile View
    Widget bayarButton = ElevatedButton.icon(
      onPressed: () {
        paymentWindow(context);
      },
      icon: const Icon(
        Icons.monetization_on,
        color: Colors.black,
        size: 18,
      ),
      label: const Text(
        'Bayar',
        style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat'
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        shadowColor: Colors.orangeAccent,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );



    // Landscape View
    Widget bayarButtonLandscape = ElevatedButton.icon(
      onPressed: () {
        paymentWindow(context);
      },
      icon: const Icon(
        Icons.monetization_on,
        color: Colors.white,
        size: 18,
      ),
      label: const Text(
        'Bayar',
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

    Widget simpanButtonLandscape = ElevatedButton.icon(
      onPressed: () {
        insertSaveSalesItems(context);
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
            double screenWidth = constraints.maxWidth;
            double columnWidth = screenWidth / 2;
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                top: true,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order',
                            style: TextStyle(
                              color: darkGrey,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CloseButton()
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: columnWidth,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6
                                ),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      // No meja
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
                                                'Nomor Meja',
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
                                                          keyboardType: TextInputType.number,
                                                          textInputAction: TextInputAction.next,
                                                          key: Key(tableNo),
                                                          initialValue: tableNo,
                                                          onChanged: (text) {
                                                            tableNo = text;
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
                                                            hintText: 'Masukkan nomor meja',
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
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Sub total
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
                                                    'Sub Total',
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
                                                              key: Key(CurrencyFormat.convertToIdr(subtotal, 0).toString()),
                                                              initialValue: CurrencyFormat.convertToIdr(subtotal, 0).toString(),
                                                              onChanged: (text) {
                                                                subtotal = int.parse(text);
                                                              },
                                                              cursorColor: Colors.orange,
                                                              keyboardType: TextInputType.number,
                                                              textInputAction: TextInputAction.next,
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
                                                                hintStyle: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.normal
                                                                ),
                                                              ),
                                                              validator: (value) {
                                                                if (value!.isEmpty) {
                                                                  return 'Subtotal tidak boleh kosong';
                                                                }
                                                                return null;
                                                              },
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
                                          Row(
                                            children: [
                                              Expanded(
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
                                                          'Diskon (%)',
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
                                                                    controller: _discountPercentageController,
                                                                    focusNode: _focusNode1,
                                                                    onChanged: (value) {
                                                                      changeDiscountPercentage(value);
                                                                    },
                                                                    cursorColor: Colors.orange,
                                                                    keyboardType: TextInputType.number,
                                                                    textInputAction: TextInputAction.next,
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
                                              const SizedBox(width: 16),
                                              // Diskon
                                              Expanded(
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
                                                          'Diskon',
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
                                                                    controller: _discountAmountController,
                                                                    focusNode: _focusNode2,
                                                                    onChanged: (value) {
                                                                      changeDiscountAmount(value);
                                                                    },
                                                                    cursorColor: Colors.orange,
                                                                    keyboardType: TextInputType.number,
                                                                    textInputAction: TextInputAction.next,
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
                                          /*const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Expanded(
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
                                                          'PPN (%)',
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
                                                                    controller: _ppnPercentageController,
                                                                    focusNode: _focusNode3,
                                                                    onChanged: (value) {
                                                                      changePPNPercentage(value);
                                                                    },
                                                                    cursorColor: Colors.orange,
                                                                    keyboardType: TextInputType.number,
                                                                    textInputAction: TextInputAction.next,
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
                                              const SizedBox(width: 16),
                                              // Diskon
                                              Expanded(
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
                                                          'PPN',
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
                                                                    // key: Key(ppn_amount_total.toString()),
                                                                    // initialValue: ppn_amount_total.toString(),
                                                                    controller: _ppnAmountController,
                                                                    focusNode: _focusNode4,
                                                                    onChanged: (text) {
                                                                      ppnAmountTotal = double.parse(text);
                                                                    },
                                                                    cursorColor: Colors.orange,
                                                                    keyboardType: TextInputType.number,
                                                                    textInputAction: TextInputAction.next,
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
                                          ),*/
                                          const SizedBox(height: 10),
                                          // Total
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
                                                    'Total',
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
                                                              key: Key(CurrencyFormat.convertToIdr(total, 0).toString()),
                                                              initialValue: CurrencyFormat.convertToIdr(total, 0).toString(),
                                                              onChanged: (text) {
                                                                total = int.parse(text);
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
                                        ],
                                      ),
                                      const Padding(padding: EdgeInsets.only(bottom: 100)),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: VerticalDivider(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                              ),
                              SizedBox(
                                width: columnWidth,
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 100),
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: cartItemsJson.length,
                                  itemBuilder: (context, index) {
                                    return makeCardLandscape(context, index);
                                  },
                                ),
                              )
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.only(top: 8, bottom: bottomPadding != 20 ? 20 : bottomPadding),
                              width: width,
                              height: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Center(child: simpanButtonLandscape),
                                  Center(child: bayarButtonLandscape),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ) : Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: Container(
                    margin: const EdgeInsets.only(top: kToolbarHeight),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order',
                              style: TextStyle(
                                color: darkGrey,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CloseButton()
                          ],
                        ),
                        const SizedBox(height: 20),
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
                                  'Nomor Meja',
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
                                            keyboardType: TextInputType.number,
                                            textInputAction: TextInputAction.next,
                                            key: Key(tableNo),
                                            initialValue: tableNo,
                                            onChanged: (text) {
                                              tableNo = text;
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
                                              hintText: 'Masukkan nomor meja',
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
                        ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: cartItemsJson.length,
                          itemBuilder: (context, int index) {
                            return makeCard(context, index);
                          },
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Sub total
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
                                      'Sub Total',
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
                                                key: Key(CurrencyFormat.convertToIdr(subtotal, 0).toString()),
                                                initialValue: CurrencyFormat.convertToIdr(subtotal, 0).toString(),
                                                onChanged: (text) {
                                                  subtotal = int.parse(text);
                                                },
                                                cursorColor: Colors.orange,
                                                keyboardType: TextInputType.number,
                                                textInputAction: TextInputAction.next,
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
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Subtotal tidak boleh kosong';
                                                  }
                                                  return null;
                                                },
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
                            Row(
                              children: [
                                Expanded(
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
                                            'Diskon (%)',
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
                                                      controller: _discountPercentageController,
                                                      focusNode: _focusNode1,
                                                      onChanged: (value) {
                                                        changeDiscountPercentage(value);
                                                      },
                                                      cursorColor: Colors.orange,
                                                      keyboardType: TextInputType.number,
                                                      textInputAction: TextInputAction.next,
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
                                const SizedBox(width: 16),
                                // Diskon
                                Expanded(
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
                                            'Diskon',
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
                                                      controller: _discountAmountController,
                                                      focusNode: _focusNode2,
                                                      onChanged: (value) {
                                                        changeDiscountAmount(value);
                                                      },
                                                      cursorColor: Colors.orange,
                                                      keyboardType: TextInputType.number,
                                                      textInputAction: TextInputAction.next,
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
                            /*const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
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
                                          'PPN (%)',
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
                                                    controller: _ppnPercentageController,
                                                    focusNode: _focusNode3,
                                                    onChanged: (value) {
                                                      changePPNPercentage(value);
                                                    },
                                                    cursorColor: Colors.orange,
                                                    keyboardType: TextInputType.number,
                                                    textInputAction: TextInputAction.next,
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
                              const SizedBox(width: 16),
                              // Diskon
                              Expanded(
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
                                          'PPN',
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
                                                    // key: Key(ppn_amount_total.toString()),
                                                    // initialValue: ppn_amount_total.toString(),
                                                    controller: _ppnAmountController,
                                                    focusNode: _focusNode4,
                                                    onChanged: (text) {
                                                      ppnAmountTotal = double.parse(text);
                                                    },
                                                    cursorColor: Colors.orange,
                                                    keyboardType: TextInputType.number,
                                                    textInputAction: TextInputAction.next,
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
                          ),*/
                            const SizedBox(height: 10),
                            // Total
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
                                      'Total',
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
                                                key: Key(CurrencyFormat.convertToIdr(total, 0).toString()),
                                                initialValue: CurrencyFormat.convertToIdr(total, 0).toString(),
                                                onChanged: (text) {
                                                  total = int.parse(text);
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
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 130)),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(
                      top: 8, bottom: bottomPadding != 20 ? 20 : bottomPadding),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            const Color(0xffd7d7d7).withOpacity(0.0),
                            const Color(0xffd7d7d7).withOpacity(0.5),
                            const Color(0xffd7d7d7),
                          ],
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter)),
                  width: width,
                  height: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(child: bayarButton),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Mobile View
  Widget makeCard(context, int index) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xffF68D7F),
                    Color(0xffFCE183),
                  ],
                ),
                boxShadow: shadow
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    leading: Container(
                        padding: const EdgeInsets.only(right: 24),
                        decoration: const BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 2, color: Colors.white24
                                )
                            )
                        ),
                        child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Center(
                                child: Text(
                                  cartItemsJson[index]['item_name'][0].toUpperCase() +
                                      cartItemsJson[index]['item_name'][0]
                                          .toLowerCase(),
                                  style: const TextStyle(
                                      color: Color(0xffF68D7F),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                            )
                        )
                    ),
                    title: Text(
                      cartItemsJson[index]['item_name'],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18
                      ),
                    ),
                    subtitle: Text(
                        CurrencyFormat.convertToIdr(
                            int.parse(cartItemsJson[index]['item_unit_price']) *
                                amountMap['amount_${cartItemsJson[index]['item_id']}'],
                            0),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16
                        )
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 30),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Text(
                              // ignore: unnecessary_null_comparison
                              amountMap['amount_${cartItemsJson[index]['item_id']}'] !=
                                  null
                                  ? amountMap['amount_${cartItemsJson[index]['item_id']}']
                                  .toString()
                                  : "0",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 221, 221, 221),
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 255, 255, 255),
                  ],
                ),
                boxShadow: shadow
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(descriptionMap['description_${cartItemsJson[index]['item_id']}'] !=
                  null
                  ? "Catatan :\n${descriptionMap['description_${cartItemsJson[index]['item_id']}']}"
                  : "Catatan :\n" " ",
                style: const TextStyle(
                    fontSize: 16
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Landscape View
  Widget makeCardLandscape(context, int index) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xffF68D7F),
                    Color(0xffFCE183),
                  ],
                ),
                boxShadow: shadow
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    leading: Container(
                        padding: const EdgeInsets.only(right: 24),
                        decoration: const BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 2, color: Colors.white24
                                )
                            )
                        ),
                        child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Center(
                                child: Text(
                                  cartItemsJson[index]['item_name'][0].toUpperCase() +
                                      cartItemsJson[index]['item_name'][0]
                                          .toLowerCase(),
                                  style: const TextStyle(
                                      color: Color(0xffF68D7F),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                            )
                        )
                    ),
                    title: Text(
                      cartItemsJson[index]['item_name'],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18
                      ),
                    ),
                    subtitle: Text(
                        CurrencyFormat.convertToIdr(
                            int.parse(cartItemsJson[index]['item_unit_price']) *
                                amountMap['amount_${cartItemsJson[index]['item_id']}'],
                            0),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16
                        )
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 2,
                                      color: Colors.white24
                                  )
                              )
                          ),
                        ),
                        const SizedBox(width: 30),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Text(
                              // ignore: unnecessary_null_comparison
                              amountMap['amount_${cartItemsJson[index]['item_id']}'] !=
                                  null
                                  ? amountMap['amount_${cartItemsJson[index]['item_id']}']
                                  .toString()
                                  : "0",
                              style: const TextStyle(
                                  color: Color(0xffF68D7F),
                                  fontSize: 22
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 221, 221, 221),
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 255, 255, 255),
                  ],
                ),
                boxShadow: shadow
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(descriptionMap['description_${cartItemsJson[index]['item_id']}'] !=
                  null
                  ? "Catatan :\n${descriptionMap['description_${cartItemsJson[index]['item_id']}']}"
                  : "Catatan :\n" " ",
                style: const TextStyle(
                    fontSize: 18
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  changePPNPercentage(var value) {
    setState(() {
      /*print(value);*/
      if (value == '' || value == null) {
        value = "0";
      }
      ppnPercentageTotal = double.parse(value);
      String calculateAmount =
          (subtotal * ppnPercentageTotal / 100).round().toString();
      ppnAmountTotal = int.parse(calculateAmount);
      _ppnAmountController.text = ppnAmountTotal.toString();
      // total = subtotal - ppn_amount_total;
      total = subtotal +
          (subtotal * ppnPercentageTotal / 100) -
          discountAmountTotal;
    });
  }

  changeDiscountPercentage(var value) {
    setState(() {
      /*print(value);*/
      if (value == '' || value == null) {
        value = "0";
      }
      discountPercentageTotal = int.parse(value);
      String calculateAmount =
          (subtotal * discountPercentageTotal / 100).round().toString();
      discountAmountTotal = int.parse(calculateAmount);
      _discountAmountController.text = discountAmountTotal.toString();
      // total = subtotal - discount_amount_total;
      total = subtotal +
          (subtotal * ppnPercentageTotal / 100) -
          discountAmountTotal;
    });
  }

  changeDiscountAmount(var value) {
    setState(() {
      /*print(value);*/
      if (value == '' || value == null) {
        value = "0";
      }
      discountAmountTotal = int.parse(value);
      String calculatePercentage =
          (discountAmountTotal * 100 / subtotal).round().toString();
      discountPercentageTotal = int.parse(calculatePercentage);
      _discountPercentageController.text = discountPercentageTotal.toString();
      // total = subtotal - discount_amount_total;
      total = subtotal +
          (subtotal * ppnPercentageTotal / 100) -
          discountAmountTotal;
    });
  }

  void insertSalesItems(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.salesAdd,
        data: {
          'user_id': userId,
          'items': cartItemsJson,
          'descriptions': descriptionItemsJson,
          'subtotal_amount': subtotal,
          'subtotal_item': subtotalItem,
          'discount_percentage_total': discountPercentageTotal,
          'discount_amount_total': discountAmountTotal,
          'ppn_percentage_total': ppnPercentageTotal,
          'ppn_amount_total': ppnAmountTotal,
          'total_amount': total,
          'table_no': tableNo,
          'paid_amount': paidAmount,
          'index_button': indexButton,
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        hideLoaderDialog(context);
        // SalesPage
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) {
              return const MainBottomNavigation();
            },
          ), (_) => false,
        );
        // Message
        CustomSnackbar.show(context, 'Order Berhasil Dibayar');
      }
    } on DioException catch (e) {
      /*print(e);*/
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        // gagal
        String errorMessage = e.response?.data['message'];
        // Message
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        /*print(e.message);*/
        Navigator.pop(context);
        // Message
        CustomSnackbar.show(context, 'Server Error', backgroundColor: Colors.red);
      }
    }
  }

  void insertSaveSalesItems(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.insertSalesSave,
        data: {
          'user_id': userId,
          'items': cartItemsJson,
          'descriptions': descriptionItemsJson,
          'subtotal_amount': subtotal,
          'subtotal_item': subtotalItem,
          'discount_percentage_total': discountPercentageTotal,
          'discount_amount_total': discountAmountTotal,
          'ppn_percentage_total': ppnPercentageTotal,
          'ppn_amount_total': ppnAmountTotal,
          'total_amount': total,
          'table_no': tableNo,
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        hideLoaderDialog(context);
        // SalesPage
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) {
              return const MainBottomNavigation();
            },
          ), (_) => false,
        );
        // Message
        CustomSnackbar.show(context, 'Order Berhasil Disimpan');
      }
    } on DioException catch (e) {
      /*print(e);*/
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        // gagal
        String errorMessage = e.response?.data['message'];
        // Message
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        /*print(e.message);*/
        Navigator.pop(context);
        // Message
        CustomSnackbar.show(context, 'Server Error', backgroundColor: Colors.red);
      }
    }
  }

  /*void getPreferenceCompany(context) async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        AppConstans.BASE_URL+AppConstans.PREFERENCE_COMPANY,
        data: {
          'user_id': user_id,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          preferenceCompany = json.encode(response.data['data']);
          preferenceCompanyJson = json.decode(preferenceCompany!);

          ppn_percentage_total_string = preferenceCompanyJson[0]['ppn_percentage'];
          ppn_percentage_total = double.parse(ppn_percentage_total_string);
          ppn_amount_total = subtotal * ppn_percentage_total / 100;

          total = subtotal + (subtotal * ppn_percentage_total / 100);

          _ppnPercentageController.text = ppn_percentage_total.toString();
          _ppnAmountController.text = ppn_amount_total.toString();
        });
      }
    } on DioError catch (e) {
      print(e);
      print('gagal');
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        String errorMessage = e.response?.data['message'];
        _onWidgetDidBuild(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
      } else {}
    }
  }*/

  paymentWindow(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        TextEditingController paidAmountController = TextEditingController();
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SizedBox(
                height: 400,
                width: 450,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.16),
                              offset: Offset(0, 5),
                              blurRadius: 7,
                            )
                          ],
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          color: Colors.grey[200],
                        ),
                        child: TextFormField(
                          controller: paidAmountController,
                          onChanged: (value) {
                            paidAmount = int.parse(value);
                            // _paidAmountController.text = paid_amount.toString();
                          },
                          decoration: const InputDecoration(
                            labelText: "Bayar",
                            labelStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Tunai"),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount = total;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 1;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 1
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Bayar Pas",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount += 100000;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 2;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 2
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "100.000",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount += 50000;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 3;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 3
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "50.000",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount += 20000;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 4;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 4
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "20.000",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount += 10000;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 5;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 5
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "10.000",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount += 5000;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 6;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 6
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "5000",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount += 2000;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 7;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 7
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "2000",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount = 0;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 8;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 8
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Batal",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text("Non Tunai"),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount = total;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 9;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: paidAmount == 9
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "GoPay",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount = total;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 10;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 10
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "OVO",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount = total;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 11;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 11
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "ShopeePay",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount = total;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 12;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 12
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "QRis",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              insertSalesItems(context);
                            },
                            icon: const Icon(
                              Icons.monetization_on,
                              color: Colors.white,
                              size: 12,
                            ),
                            label: const Text(
                              'Bayar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
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
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              indexButton = 0;
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 12,
                            ),
                            label: const Text(
                              'Kembali',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
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
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
