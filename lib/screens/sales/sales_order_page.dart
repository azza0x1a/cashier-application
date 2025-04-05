import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:mozaic_app/screens/main/main_bottom_navigation.dart';
import 'package:mozaic_app/style/custom_background.dart';
import 'package:mozaic_app/widget/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../component/no_data_card.dart';
import '../../style/app_properties.dart';
import '../../utility/currency_format.dart';
import '../../widget/custom_loading.dart';
import 'sales_detail_page.dart';

class SalesOrderPage extends StatefulWidget {
  const SalesOrderPage({super.key});

  @override
  State<SalesOrderPage> createState() => _SalesOrderPageState();
}

class _SalesOrderPageState extends State<SalesOrderPage> {
  String userId = '';
  String userName = '';
  String userGroupName = '';
  String token = '';
  String? cartItems;
  String? descriptionItems;
  String item = '';
  String itemCategory = '';
  int itemCategoryId = 0;
  int itemId = 0;
  var itemCategoryJson = [];
  var itemJson = [];
  var duplicateItemJson = [];
  List<dynamic> cartItemsJsonForLoops = [];
  List<dynamic> descriptionItemsJsonForLoops = [];
  final Map amountMap = {};
  final Map descriptionMap = {};

  // late TabController tabController;
  TextEditingController editingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<String> categories = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    fetchCategories(context);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
      duplicateItemJson = json.decode(item);
      /*item_id = itemJson[0]['item_id'];*/
      cartItems = prefs.getString('cartitems');
      itemCategory = prefs.getString('itemcategory')!;
      itemCategoryJson = json.decode(itemCategory);
      itemCategoryId = itemCategoryJson[0]['item_category_id'];
      if (cartItems != null) {
        cartItemsJsonForLoops = json.decode(cartItems!);
        for (var value in cartItemsJsonForLoops) {
          amountMap['amount_${value['item_id']}'] =
              value['quantity'];
        }
      }
      descriptionItems = prefs.getString('descriptionitems');
      if (descriptionItems != null) {
        descriptionItemsJsonForLoops = json.decode(descriptionItems!);
        for (var value in descriptionItemsJsonForLoops) {
          descriptionMap['description_${value['item_id']}'] =
              value['description'];
        }
      }
      fetchItem(context, itemCategoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    Widget buildTabBar() {
      return TabBar(
        tabs: itemCategoryJson
            .map((item) => Tab(text: item['item_category_name'].toString()))
            .toList(),
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            itemCategoryId = itemCategoryJson[index]['item_category_id'];
          });
          fetchItem(context, itemCategoryJson[index]['item_category_id']);
        },
        labelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        labelColor: darkGrey,
        unselectedLabelColor: const Color.fromRGBO(0, 0, 0, 0.5),
        isScrollable: true,
      );
    }

    List<Widget> buildTabViews() {
      return itemCategoryJson.map((item) {
        if (itemJson.isNotEmpty) {
          return OrientationBuilder(
            builder: (context, orientation) {
              return orientation == Orientation.landscape ? LayoutBuilder(
                builder: (context, constraints) {
                  return ScrollbarTheme(
                    data: ScrollbarThemeData(
                      thumbColor: WidgetStateProperty.all(Colors.orange),
                      thickness: WidgetStateProperty.all(10),
                      radius: const Radius.circular(20),
                      trackColor: WidgetStateProperty.all(Colors.grey[200]),
                      trackBorderColor: WidgetStateProperty.all(Colors.grey[300]),
                      interactive: true,
                      trackVisibility: WidgetStateProperty.all(true),
                    ),
                    child: Scrollbar(
                      controller: scrollController,
                      thickness: 8,
                      radius: const Radius.circular(4),
                      interactive: true,
                      child: ListView.builder(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: itemJson.length,
                        itemBuilder: (context, index) {
                          return itemCardLandscape(context, index);
                        },
                        padding: const EdgeInsets.only(bottom: 100),
                      ),
                    ),
                  );
                },
              ) : ScrollbarTheme(
                data: ScrollbarThemeData(
                  thumbColor: WidgetStateProperty.all(Colors.orange),
                  thickness: WidgetStateProperty.all(10),
                  radius: const Radius.circular(20),
                  trackColor: WidgetStateProperty.all(Colors.grey[200]),
                  trackBorderColor: WidgetStateProperty.all(Colors.grey[300]),
                  interactive: true,
                  trackVisibility: WidgetStateProperty.all(true),
                ),
                child: Scrollbar(
                  controller: scrollController,
                  thickness: 8,
                  radius: const Radius.circular(4),
                  interactive: true,
                  child: ListView.builder(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: itemJson.length,
                    itemBuilder: (context, index) {
                      return itemCard(context, index);
                    },
                    padding: const EdgeInsets.only(bottom: 130),
                  ),
                ),
              );
            },
          );
        } else {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: NoDataCard()
              ),
            ],
          );
        }
      }).toList();
    }

    Widget salesDetailButton = ElevatedButton.icon(
      onPressed: () {
        /*print("simpan");*/
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SalesDetailPage()),
        );
      },
      icon: const Icon(
        Icons.fastfood,
        color: Colors.black,
        size: 18,
      ),
      label: const Text(
        'Order',
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

    Widget salesDetailButtonLandscape = ElevatedButton.icon(
      onPressed: () {
        /*print("simpan");*/
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SalesDetailPage()),
        );
      },
      icon: const Icon(
        Icons.fastfood,
        color: Colors.white,
        size: 18,
      ),
      label: const Text(
        'Order',
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
            return WillPopScope(
              onWillPop: () async {
                Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(
                    builder: (BuildContext context) {
                      return const MainBottomNavigation();
                    },
                  ), (_) => false,
                );
                return Future.value(false);
              },
              child: CustomPaint(
                painter: MainBackground(),
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 50),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Buat Pesanan',
                                      style: TextStyle(
                                        color: darkGrey,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    CloseButton(
                                      onPressed: () async {
                                        Navigator.of(context).pushAndRemoveUntil(
                                          CupertinoPageRoute(
                                            builder: (context) {
                                              return const MainBottomNavigation();
                                            },
                                          ), (_) => false,
                                        );
                                        return Future.value();
                                      },
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 50),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 32),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    color: Colors.white,
                                  ),
                                  child: TextFormField(
                                    controller: editingController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Pencarian',
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: SvgPicture.asset(
                                          'assets/icons/search_icon.svg',
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                      prefixIconConstraints: const BoxConstraints(
                                        minWidth: 0,
                                        minHeight: 0,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      filterSearchResults(value);
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                child: SafeArea(
                                  child: DefaultTabController(
                                    length: itemCategoryJson.length,
                                    child: Column(
                                      children: [
                                        buildTabBar(),
                                        Flexible(
                                          child: TabBarView(
                                              physics: const NeverScrollableScrollPhysics(),
                                              children: buildTabViews()
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 260)),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 8,
                                bottom: bottomPadding != 20 ? 20 : bottomPadding
                            ),
                            width: width,
                            height: 80,
                            child: Center(
                              child: salesDetailButtonLandscape,
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ),
            );
          },
        ) : WillPopScope(
          onWillPop: () async {
            // Navigator.pop(context);
            // final prefs = await SharedPreferences.getInstance();
            // await prefs.remove('cartitems');
            // await prefs.remove('descriptionitems');
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) {
                  return const MainBottomNavigation();
                },
              ), (_) => false,
            );
            return Future.value(false);
          },
          child: CustomPaint(
            painter: MainBackground(),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Buat Pesanan',
                                  style: TextStyle(
                                    color: darkGrey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CloseButton(
                                  onPressed: () async {
                                    // Navigator.pop(context);
                                    // final prefs = await SharedPreferences.getInstance();
                                    // await prefs.remove('cartitems');
                                    // await prefs.remove('descriptionitems');
                                    Navigator.of(context).pushAndRemoveUntil(
                                      CupertinoPageRoute(
                                        builder: (context) {
                                          return const MainBottomNavigation();
                                        },
                                      ), (_) => false,
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 25
                            ),
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
                                    'Pencarian',
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
                                              controller: editingController,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Pencarian',
                                                prefixIcon: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/search_icon.svg',
                                                    fit: BoxFit.scaleDown,
                                                  ),
                                                ),
                                                prefixIconConstraints: const BoxConstraints(
                                                  minWidth: 0,
                                                  minHeight: 0,
                                                ),
                                              ),
                                              onChanged: (value) {
                                                filterSearchResults(value);
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
                          Expanded(
                            child: DefaultTabController(
                              length: itemCategoryJson.length,
                              child: Column(
                                children: [
                                  buildTabBar(),
                                  Expanded(
                                    child: TabBarView(
                                        physics: const NeverScrollableScrollPhysics(),
                                        children: buildTabViews()
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 130)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 8,
                            bottom: bottomPadding != 20 ? 20 : bottomPadding
                        ),
                        width: width,
                        height: 120,
                        child: Center(child: salesDetailButton),
                      ),
                    ),
                  ],
                )
            ),
          ),
        );
      },
    );

  }

  // Mobile View
  Widget itemCard(context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xffFCE183),
              Color(0xffF68D7F),
            ],
          ),
          boxShadow: shadow
        ),
        child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            leading: Container(
              padding: const EdgeInsets.only(right: 12),
              decoration: const BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1, color: Colors.white24)
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
                    itemJson[index]['item_name'][0].toUpperCase() +
                        itemJson[index]['item_name'][0].toLowerCase(),
                    style: const TextStyle(
                        color: Color(0xffF68D7F), fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            title: Text(
              itemJson[index]['item_name'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
                CurrencyFormat.convertToIdr(
                    int.parse(itemJson[index]['item_unit_price']), 0),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14
                )
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          right: BorderSide(width: 1, color: Colors.white24)
                      )
                  ),
                  child: InkWell(
                    onTap: () {
                      addDescriptionWindow(context, itemJson[index]['item_id']);
                    },
                    child: const Icon(Icons.description, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 15),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: InkWell(
                        onTap: () {
                          minusItem(
                              itemJson[index]['item_id'],
                              itemJson[index]['item_name'],
                              itemJson[index]['item_unit_price']);
                        },
                        child: const Icon(Icons.remove_rounded,
                            size: 20, color: Color(0xffF68D7F)
                        )
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  width: 36,
                  height: 36,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      initialValue: amountMap['amount_${itemJson[index]['item_id']}'] !=
                              null
                          ? amountMap['amount_${itemJson[index]['item_id']}']
                              .toString()
                          : "0",
                      key: Key(
                        amountMap['amount_${itemJson[index]['item_id']}'] !=
                                null
                            ? amountMap['amount_${itemJson[index]['item_id']}']
                                .toString()
                            : "0",
                      ),
                      validator: (value) {
                        if (int.parse(value!) == 999) {
                          return null;
                        }
                        return null;
                      },
                      onChanged: (inputAmount) async {
                        addItemManual(
                          itemJson[index]['item_id'],
                          itemJson[index]['item_name'],
                          itemJson[index]['item_unit_price'],
                          int.parse(inputAmount),
                        );
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        isCollapsed: true,
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: InkWell(
                      onTap: () {
                        addItem(
                            itemJson[index]['item_id'],
                            itemJson[index]['item_name'],
                            itemJson[index]['item_unit_price']);
                      },
                      child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: const Icon(Icons.add_rounded,
                              size: 20, color: Color(0xffF68D7F)
                          )
                      )
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  //Tablet View
  Widget itemCardLandscape(context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 80
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color.fromARGB(255, 0, 130, 198),
          boxShadow: shadow
      ),
      child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
          leading: Container(
            padding: const EdgeInsets.only(right: 24),
            decoration: const BoxDecoration(
                border: Border(
                    right: BorderSide(width: 2, color: Colors.white24)
                )
            ),
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  itemJson[index]['item_name'][0].toUpperCase() +
                      itemJson[index]['item_name'][0].toLowerCase(),
                  style: const TextStyle(
                      color: Color(0xffF68D7F),
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            itemJson[index]['item_name'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
              CurrencyFormat.convertToIdr(int.parse
                (itemJson[index]['item_unit_price']), 0),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16
              )
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 2, color: Colors.white24)
                    )
                ),
                child: GestureDetector(
                  onTap: () {
                    addDescriptionWindow(context, itemJson[index]['item_id']);
                  },
                  child: const Icon(Icons.description, color: Colors.white, size:26),
                ),
              ),
              const SizedBox(width: 30),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: GestureDetector(
                      onTap: () {
                        minusItem(
                            itemJson[index]['item_id'],
                            itemJson[index]['item_name'],
                            itemJson[index]['item_unit_price']);
                      },
                      child: const Icon(Icons.remove_rounded,
                          size: 26, color: Color(0xffF68D7F)
                      )
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                width: 40,
                height: 40,
                child: Center(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal
                    ),
                    initialValue: amountMap['amount_${itemJson[index]['item_id']}'] !=
                        null
                        ? amountMap['amount_${itemJson[index]['item_id']}']
                        .toString()
                        : "0",
                    key: Key(
                      amountMap['amount_${itemJson[index]['item_id']}'] !=
                          null
                          ? amountMap['amount_${itemJson[index]['item_id']}']
                          .toString()
                          : "0",
                    ),
                    validator: (value) {
                      if (int.parse(value!) == 999) {
                        return null;
                      }
                      return null;
                    },
                    onChanged: (inputAmount) async {
                      addItemManual(
                        itemJson[index]['item_id'],
                        itemJson[index]['item_name'],
                        itemJson[index]['item_unit_price'],
                        int.parse(inputAmount),
                      );
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      isCollapsed: true,
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                    onTap: () {
                      addItem(
                          itemJson[index]['item_id'],
                          itemJson[index]['item_name'],
                          itemJson[index]['item_unit_price']);
                    },
                    child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: const Icon(Icons.add_rounded,
                            size: 26, color: Color(0xffF68D7F)
                        )
                    )
                ),
              ),
            ],
          )
      ),
    );
  }

  addItemManual(
      var itemId, var itemName, var itemUnitPrice, var inputAmount) async {
    final prefs = await SharedPreferences.getInstance();
    cartItems = prefs.getString('cartitems');
    bool cek = false;
    var quantity = 0;

    if (cartItems == null) {
      var dataJson = [
        {
          'item_id': itemId,
          'item_name': itemName,
          'item_unit_price': itemUnitPrice,
          'quantity': inputAmount,
        }
      ];
      String data = json.encode(dataJson);
      await prefs.setString('cartitems', data);
      amountMap['amount_$itemId'] = inputAmount;
    } else {
      var cartItemsJsonForLoop = json.decode(cartItems!);
      var cartItemsJson = json.decode(cartItems!);

      if (inputAmount <= 0 || inputAmount == null) {
        cartItemsJson.removeWhere((item) => item['item_id'] == itemId);
        amountMap['amount_$itemId'] = 0;
      } else {
        cartItemsJsonForLoop.forEach((value) {
          if (itemId == value['item_id']) {
            cek = true;
            quantity = value['quantity'];
          }
        });
        if (cek = true) {
          var dataJson = {
            'item_id': itemId,
            'quantity': inputAmount,
            'item_name': itemName,
            'item_unit_price': itemUnitPrice,
          };
          cartItemsJson.removeWhere((item) => item['item_id'] == itemId);
          cartItemsJson.add(dataJson);
        } else {
          var dataJson = {
            'item_id': itemId,
            'quantity': inputAmount,
            'item_name': itemName,
            'item_unit_price': itemUnitPrice,
          };
          cartItemsJson.add(dataJson);
        }
      }
      cartItemsJson.forEach((value) {
        amountMap['amount_${value['item_id']}'] = value['quantity'];
      });
      await prefs.setString('cartitems', json.encode(cartItemsJson));
    }
  }

  addItem(var itemId, var itemName, var itemUnitPrice) async {
    final prefs = await SharedPreferences.getInstance();
    cartItems = prefs.getString('cartitems');
    bool cek = false;
    var quantity = 0;

    if (cartItems == null) {
      var dataJson = [
        {
          'item_id': itemId,
          'item_name': itemName,
          'item_unit_price': itemUnitPrice,
          'quantity': 1,
        }
      ];
      String data = json.encode(dataJson);
      await prefs.setString('cartitems', data);
      setState(() {
        amountMap['amount_$itemId'] = 1;
      });
    } else {
      var cartItemsJsonForLoop = json.decode(cartItems!);
      var cartItemsJson = json.decode(cartItems!);
      cartItemsJsonForLoop.forEach((value) {
        if (itemId == value['item_id']) {
          cek = true;
          quantity = value['quantity'];
        }
      });
      if (cek = true) {
        var dataJson = {
          'item_id': itemId,
          'quantity': quantity + 1,
          'item_name': itemName,
          'item_unit_price': itemUnitPrice,
        };
        cartItemsJson.removeWhere((item) => item['item_id'] == itemId);
        cartItemsJson.add(dataJson);
      } else {
        var dataJson = {
          'item_id': itemId,
          'quantity': 1,
          'item_name': itemName,
          'item_unit_price': itemUnitPrice,
        };
        cartItemsJson.add(dataJson);
      }
      cartItemsJson.forEach((value) {
        setState(() {
          amountMap['amount_${value['item_id']}'] =
              value['quantity'];
        });
      });
      await prefs.setString('cartitems', json.encode(cartItemsJson));
    }
  }

  minusItem(var itemId, var itemName, var itemUnitPrice) async {
    final prefs = await SharedPreferences.getInstance();
    cartItems = prefs.getString('cartitems');
    bool cek = false;
    var quantity = 0;

    if (cartItems == null) {
    } else {
      var cartItemsJsonForLoop = json.decode(cartItems!);
      var cartItemsJson = json.decode(cartItems!);
      cartItemsJsonForLoop.forEach((value) {
        if (itemId == value['item_id']) {
          cek = true;
          quantity = value['quantity'];
        }
      });
      if (cek = true) {
        var lastQuantity = quantity - 1;
        if (lastQuantity <= 0) {
          cartItemsJson.removeWhere((item) => item['item_id'] == itemId);
          setState(() {
            amountMap['amount_$itemId'] = 0;
          });
        } else {
          var dataJson = {
            'item_id': itemId,
            'quantity': lastQuantity,
            'item_name': itemName,
            'item_unit_price': itemUnitPrice,
          };
          cartItemsJson.removeWhere((item) => item['item_id'] == itemId);
          cartItemsJson.add(dataJson);
        }
      } else {}
      cartItemsJson.forEach((value) {
        setState(() {
          amountMap['amount_${value['item_id']}'] =
              value['quantity'];
        });
      });
      await prefs.setString('cartitems', json.encode(cartItemsJson));
    }
  }

  addDescription(var itemId, var value) async {
    final prefs = await SharedPreferences.getInstance();
    descriptionItems = prefs.getString('descriptionitems');
    if (descriptionItems == null) {
      var dataJson = [
        {
          'item_id': itemId,
          'description': value,
        }
      ];

      String data = json.encode(dataJson);
      await prefs.setString('descriptionitems', data);
    } else {
      var descriptionItemsJson = json.decode(descriptionItems!);
      var descriptionItemsJsonForLoop = json.decode(descriptionItems!);
      descriptionItemsJsonForLoop.forEach((value) {
        if (value['item_id'] == itemId) {
          descriptionItemsJson
              .removeWhere((item) => item['item_id'] == itemId);
        }
      });
      var dataJson = {
        'item_id': itemId,
        'description': value,
      };
      descriptionItemsJson.add(dataJson);
      await prefs.setString(
          'descriptionitems', json.encode(descriptionItemsJson));
    }

    setState(() {
      descriptionMap['description_$itemId'] = value;
    });
  }

  addDescriptionWindow(context, var itemId) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 60,
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              initialValue: descriptionMap['description_$itemId'] !=
                      null
                  ? descriptionMap['description_$itemId'].toString()
                  : "",
              onChanged: (value) {
                addDescription(itemId, value);
              },
              decoration: InputDecoration(
                labelText: "Catatan",
                labelStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromARGB(255, 235, 147, 17)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                return null;
              },
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

  Future<void> fetchItem(context, int itemCategoryId) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.item,
        data: {
          'user_id': userId,
          'item_category_id': itemCategoryId,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);

        setState(() {
          if (response.data['data'].isEmpty) {
            itemJson = [];
            duplicateItemJson = [];
          } else {
            itemJson = response.data['data'];
            duplicateItemJson = response.data['data'];
          }
        });
      }
    } on DioException catch (e) {
      /*print(e);*/
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

  Future<void> fetchCategories(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.itemCategory,
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
        setState(() {
          itemCategoryJson = response.data['data'];
        });
      }
    } on DioException catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        // gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {}
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      itemJson = duplicateItemJson
          .where((item) =>
              item['item_name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}
