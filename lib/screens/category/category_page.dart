import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:mozaic_app/component/no_data_card.dart';
import 'package:mozaic_app/screens/category/component/tablet/modal_item_page_tablet.dart';
import 'package:mozaic_app/screens/category/component/tablet/modal_unit_page_tablet.dart';
import 'package:mozaic_app/widget/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style/app_properties.dart';
import '../../utility/currency_format.dart';
import '../../widget/custom_loading.dart';
import 'component/modal_category_page.dart';
import 'component/tablet/modal_category_page_tablet.dart';
import 'edit_item_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String userName = '';
  String userId = '';
  String userGroupName = '';
  String itemCategory = '';
  String item = '';
  var itemCategoryJson = [];
  var itemJson = [];
  var duplicateItemJson = [];
  String token = '';
  int? itemCategoryId;
  late FocusNode myFocusNode;

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    fetchCategories(context);
    myFocusNode = FocusNode();
  }

  void rebuild() {
    loadSharedPreference();
    fetchCategories(context);
    myFocusNode = FocusNode();
  }

  Future<void> loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id')!;
      userName = prefs.getString('username')!;
      userGroupName = prefs.getString('user_group_name')!;
      itemCategory = prefs.getString('itemcategory')!;
      itemCategoryJson = json.decode(itemCategory);
      item = prefs.getString('item')!;
      itemJson = json.decode(item);
      duplicateItemJson = json.decode(item);
      token = prefs.getString('token')!;
      itemCategoryId = itemCategoryJson[0]['item_category_id'];
      fetchItem(context, itemCategoryId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    // Mobile View
    Widget tambahCategoryButton = ElevatedButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const ModalCategoryPage(),
        ).then((value) => rebuild());
      },
      icon: const Icon(
        Icons.category,
        color: Colors.white,
        size: 16,
      ),
      label: const Column(
        children: [
          Text(
            'Tambah',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'
            ),
          ),
          Text(
            'Kategori',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'
            ),
          ),
        ],
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

    Widget tambahSatuanButton = ElevatedButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const ModalUnitPageTablet(),
        ).then((value) => rebuild());
      },
      icon: const Icon(
        Icons.ad_units,
        color: Colors.white,
        size: 16,
      ),
      label: const Column(
        children: [
          Text(
            'Tambah',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'
            ),
          ),
          Text(
            'Satuan',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'
            ),
          ),
        ],
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

    Widget tambahBarangButton = ElevatedButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const ModalItemPageTablet(),
        ).then((value) => rebuild());
      },
      icon: const Icon(
        Icons.fastfood,
        color: Colors.white,
        size: 16,
      ),
      label: const Column(
        children: [
          Text(
            'Tambah',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'
            ),
          ),
          Text(
            'Produk',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'
            ),
          ),
        ],
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
    Widget tambahCategoryButtonLandscape = ElevatedButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const ModalCategoryPageTablet(),
        ).then((value) => rebuild());
      },
      icon: const Icon(
        Icons.category,
        color: Colors.white,
        size: 12,
      ),
      label: const Text(
        'Tambah Kategori',
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
    );

    Widget tambahSatuanButtonLandscape = ElevatedButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const ModalUnitPageTablet(),
        ).then((value) => rebuild());
      },
      icon: const Icon(
        Icons.ad_units,
        color: Colors.white,
        size: 12,
      ),
      label: const Text(
        'Tambah Satuan',
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
    );

    Widget tambahBarangButtonLandscape = ElevatedButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const ModalItemPageTablet(),
        ).then((value) => rebuild());
      },
      icon: const Icon(
        Icons.fastfood,
        color: Colors.white,
        size: 12,
      ),
      label: const Text(
        'Tambah Produk',
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
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape ? LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double columnWidth = screenWidth / 2;
            return Scaffold(
              appBar: AppBar(
                centerTitle: false,
                titleSpacing: 0,
                automaticallyImplyLeading: true,
                backgroundColor: const Color(0xffFDC054),
                elevation: 0,
                scrolledUnderElevation: 0,
                leadingWidth: 70,
                title: const Text(
                  "Menu Baru",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: columnWidth,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
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
                                    'Kategori',
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
                                                  hint: const Text('Pilih kategori'),
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
                                                    fetchItem(context, newVal as int);
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
                                    'Menu Tambah',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      tambahCategoryButtonLandscape,
                                      tambahSatuanButtonLandscape,
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Center(child: tambahBarangButtonLandscape)
                                ],
                              ),
                            ),
                          ),
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
                      child: itemJson.isNotEmpty ? ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: itemJson.length,
                        itemBuilder: (context, int index) {
                          return itemCardLanscape(context, index);
                        },
                      ) : const Center(
                        child: NoDataCard(),
                      )
                  ),
                ],
              )
            );
          },
        ) : Scaffold(
          backgroundColor: Color.fromARGB(255, 0, 130, 198),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            title: const Text(
              'Menu Baru',
              style: TextStyle(
                  color: darkGrey,
                  fontSize: 18
              ),
            ),
            elevation: 0,
            scrolledUnderElevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          body: SafeArea(
            top: true,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                'Kategori',
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
                                              hint: const Text('Pilih kategori'),
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
                                                fetchItem(context, newVal as int);
                                              },
                                            ),
                                          )
                                      )
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
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
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    tambahCategoryButton,
                                    const SizedBox(width:6),
                                    tambahSatuanButton,
                                  ],
                                ),
                              ),
                              Center(
                                child: tambahBarangButton,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SingleChildScrollView(
                              child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    itemJson.isNotEmpty ? ListView.builder(
                                      physics: const ClampingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: itemJson.length,
                                      itemBuilder: (context, int index) {
                                        return itemCard(context, index);
                                      },
                                    ) : const NoDataCard(),
                                    const Padding(padding: EdgeInsets.only(bottom: 130)),
                                  ]
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(top: 8, bottom: bottomPadding != 20 ? 20 : bottomPadding),
                    width: width,
                    height: 120,
                    // child: Center(child: Placeholder()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Mobile View
  Widget itemCard(context, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 6,
      ),
      elevation: 4,
      shadowColor: Colors.grey,
      child: GestureDetector(
        onTap: () {

        },
        child: ListTile(
            onTap: () {
              _onListTileTapped(itemJson[index]);
            },
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: Color(0xffF68D7F),
                  width: 1,
                )
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: Container(
                padding: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 2, color: Colors.white24
                        )
                    )
                ),
                // child: Icon(Icons.autorenew, color: Colors.white),
                child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xffF68D7F),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Center(
                        child: Text(
                          itemJson[index]['item_name'][0].toUpperCase() +
                              itemJson[index]['item_name'][0].toLowerCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    )
                )
            ),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                itemJson[index]['item_name'],
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal
                ),
              ),
            ),
            subtitle: Text(
                CurrencyFormat.convertToIdr(int.parse(itemJson[index]['item_unit_price']), 0),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal
                )
            )
        ),
      ),
    );
  }

  // Lanscape View
  Widget itemCardLanscape(context, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 26,
      ),
      elevation: 4,
      shadowColor: Colors.grey,
      child: GestureDetector(
        onTap: () {

        },
        child: ListTile(
            onTap: () {
              _onListTileTapped(itemJson[index]);
            },
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: Color(0xffF68D7F),
                  width: 1,
                )
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: Container(
                padding: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 2, color: Colors.white24)
                    )
                ),
                // child: Icon(Icons.autorenew, color: Colors.white),
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xffF68D7F),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Center(
                        child: Text(
                          itemJson[index]['item_name'][0].toUpperCase() +
                              itemJson[index]['item_name'][0].toLowerCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    )
                )
            ),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                itemJson[index]['item_name'],
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal
                ),
              ),
            ),
            subtitle: Text(
                CurrencyFormat.convertToIdr(int.parse(itemJson[index]['item_unit_price']), 0),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal
                )
            )
        ),
      ),
    );
  }

  void _onListTileTapped(Map<String, dynamic> itemDetailJson) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) =>
            EditItemPage(
              itemDetailJson: itemDetailJson,
            ),
      ),
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
        //Messsage
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
        Api.itemCategoryNewMenu,
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
        //gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {

      }
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
