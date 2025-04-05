import 'dart:convert';
import 'dart:io';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:mozaic_app/component/no_data_card.dart';
import 'package:mozaic_app/screens/sales/sales_order_page.dart';
import 'package:mozaic_app/style/app_properties.dart';
import 'package:mozaic_app/style/custom_background.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../utility/currency_format.dart';
import '../../widget/custom_loading.dart';
import '../../widget/custom_snackbar.dart';
import '../profile/about_page.dart';
import '../sales/sales_detail_saved_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String userId = '';
  String userName = '';
  String userGroupName = '';
  String token = '';
  String? savedItem;
  String? tableNo;
  String? discountPercentageTotal;
  String? discountAmountTotal;
  // String? ppnPercentageTotal;
  // String? ppnAmountTotal;
  String itemCategory = '';
  String salesInvoiceId = '';
  String? salesinvoice;
  String? salesinvoiceitem;
  String? unpaidsalesinvoice;
  String totalAmountToday = '';

  String fullName = '';
  int? guestState;

  var salesinvoiceJson = [];
  var salesinvoiceitemJson = [];
  var unpaidsalesinvoiceJson = [];
  var itemCategoryJson = [];

  Map<String, dynamic> preferenceCompanyPrint = {};
  Map<String, dynamic> salesinvoicePrint = {};
  List<dynamic> salesinvoiceitemPrint = [];

  String macAddressPrintCashier = '';
  String macAddressPrintKitchen = '';

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    fetchPaidSalesToday(context);
    fetchPaidSalesTodayMenu(context);
    fetchUnPaidSalesToday(context);
    fetchCategories(context);
    fetchPrinterAddress(context);
    fetchPrinterKitchenAddress(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void>loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id')!;
      userName = prefs.getString('username')!;
      fullName = prefs.getString('full_name')!;
      userGroupName = prefs.getString('user_group_name')!;
      guestState = int.parse(prefs.getString('guest_state')!);
      token = prefs.getString('token')!;
      macAddressPrintCashier = prefs.getString('printer_address')!;
      macAddressPrintKitchen = prefs.getString('printer_kitchen_address')!;
      // itemCategory = prefs.getString('itemcategory')!;
    });

    if (guestState == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Akun Percobaan"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text("username : $userName"),
                  const Text("password : 123456"),
                  const Text(
                    "*jika belum diubah",
                    style: TextStyle(fontSize: 10),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Akun percobaan hanya berlaku 7 hari !",
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                      "Untuk mendapatkan akses penuh silahkan hubungi kontak kami pada halaman 'Tentang Aplikasi' ",
                      style:
                      TextStyle(color: Color.fromARGB(255, 18, 155, 125))),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget appBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            onPressed: () => Navigator.of(context).push(CupertinoPageRoute(builder: (_) => const AboutPage())),
            icon: Image.asset(
              "assets/mozaic/logo-vc.png",
              fit: BoxFit.contain,
              height: 80,
              width: 80,
            )
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomPaint(
          painter: MainBackground(),
          child: OrientationBuilder(
            builder: (context, orientation) {
              return orientation == Orientation.landscape ? LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth;
                  double columnWidth = screenWidth / 3;
                  return Column(
                    children: [
                      appBar,
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: VerticalDivider(
                                width: 1,
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            ),
                            // Middle Column
                            SizedBox(
                                width: columnWidth,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 12,
                                          right: 12,
                                          bottom: 10
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: const Center(
                                        child: Text(
                                          "Penjualan Harian",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: salesinvoiceJson.isNotEmpty ? ListView.builder(
                                        padding: const EdgeInsets.only(bottom: 100),
                                        physics: const ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: salesinvoiceJson.length,
                                        itemBuilder: (context, int index) {
                                          return makeCard(context, index);
                                          // return const Text("tes");
                                        },
                                      ) : const NoDataCard(),
                                    )
                                  ],
                                )
                            ),
                            Expanded(
                              child: VerticalDivider(
                                width: 1,
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            ),
                            // Right Column
                            SizedBox(
                                width: columnWidth,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 12,
                                          right: 12,
                                          bottom: 10
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: const Center(
                                        child: Text(
                                          "Menu Laku Harian",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                             ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: salesinvoiceitemJson.isNotEmpty ? ListView.builder(
                                        padding: const EdgeInsets.only(bottom: 100),
                                        physics: const ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: salesinvoiceitemJson.length,
                                        itemBuilder: (context, int index) {
                                          return makeCardMenu(context, index);
                                          // return const Text("tes");
                                        },
                                      ) : const NoDataCard(),
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ) : Scaffold(
                backgroundColor: Colors.transparent,
                body: CustomPaint(
                  painter: MainBackground(),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      appBar,
                      Expanded(
                        child: ListView(
                          dragStartBehavior: DragStartBehavior.start,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Column(
                                children: [
                                  Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10
                                    ),
                                    elevation: 4,
                                    surfaceTintColor: const Color(0xff33B2B9),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: const BorderSide(
                                          color: Color(0xff33B2B9),
                                          width: 1,
                                        )
                                    ),
                                    child: ExpansionTile(
                                      backgroundColor: Colors.white,
                                      initiallyExpanded: true,
                                      expansionAnimationStyle: AnimationStyle(
                                          curve: Curves.easeIn,
                                          reverseCurve: Curves.easeOut
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          side: const BorderSide(
                                            color: Color(0xff33B2B9),
                                            width: 1,
                                          )
                                      ),
                                      leading: const Icon(Icons.reorder),
                                      title: const Text(
                                        "Penjualan Harian",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      subtitle: Text(
                                        totalAmountToday != '' ? CurrencyFormat.convertToIdr(int.parse(totalAmountToday), 0) : "Rp 0",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      children: [
                                        salesinvoiceJson.isNotEmpty ? ListView.builder(
                                          physics: const ClampingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: salesinvoiceJson.length,
                                          itemBuilder: (context, int index) {
                                            return makeCard(context, index);
                                            // return const Text("tes");
                                          },
                                        ) : const NoDataCard(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10
                                    ),
                                    elevation: 4,
                                    surfaceTintColor: const Color(0xff5189EA),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: const BorderSide(
                                          color: Color(0xff5189EA),
                                          width: 1,
                                        )
                                    ),
                                    child: ExpansionTile(
                                      backgroundColor: Colors.white,
                                      initiallyExpanded: true,
                                      expansionAnimationStyle: AnimationStyle(
                                          curve: Curves.easeIn,
                                          reverseCurve: Curves.easeOut
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          side: const BorderSide(
                                            color: Color(0xff5189EA),
                                            width: 1,
                                          )
                                      ),
                                      leading: const Icon(Icons.check),
                                      title: const Text(
                                        "Menu Laku Harian",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      children: [
                                        salesinvoiceitemJson.isNotEmpty ?  ListView.builder(
                                          physics: const ClampingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: salesinvoiceitemJson.length,
                                          itemBuilder: (context, int index) {
                                            return makeCardMenu(context, index);
                                            // return const Text("tes");
                                          },
                                        ) : const NoDataCard(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 80),
                                ]
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (itemCategory == '' || itemCategory.isEmpty) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                      'Opps!'
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text("Hai $userName"),
                        const Text(
                          "Produk anda masih Kosong !",
                          style: TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                            "Silahkan menambah produk pada halaman 'Menu Baru' ",
                            style: TextStyle(color: Color.fromARGB(255, 18, 155, 125))),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      child: const Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
            );
          } else {
            addSalesItem(context);
          }
        },
        label: const Text(
          'Tambah Pesanan',
          style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        icon: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget makeCardUnpaid(context, index) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      elevation: 4,
      shadowColor: Colors.grey,
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color(0xffff76be),
              width: 1,
            )
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1,
                color: Color(0xffff4dab),
              ),
            ),
          ),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xffff76be),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Center(
              child: Text(
                unpaidsalesinvoiceJson[index]['table_no'] ?? "-",
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                ),
              ),
            ),
          ),
        ),
        title: Text(
          CurrencyFormat.convertToIdr(int.parse(unpaidsalesinvoiceJson[index]['total_amount']), 0),
          style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
        subtitle: Text(
          unpaidsalesinvoiceJson[index]['salesinvoiceitem_name'],
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.normal
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                paySavedOrder(context, unpaidsalesinvoiceJson[index]['sales_invoice_id']);
              },
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(Icons.payments_sharp, color: Colors.grey.shade600),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                if (Platform.isAndroid) {
                  var bluetoothConnect = await Permission.bluetoothConnect.request();
                  var bluetoothScan = await Permission.bluetoothScan.request();
                  var bluetoothAdvertise = await Permission.bluetoothAdvertise.request();
                  if (bluetoothConnect != PermissionStatus.granted
                      && bluetoothScan != PermissionStatus.granted
                      && bluetoothAdvertise != PermissionStatus.granted) {
                    return;
                  }
                }
                printUnpaidOrder(context, unpaidsalesinvoiceJson[index]['sales_invoice_id']);
              },
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(Icons.print, color: Colors.grey.shade600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeCard(context, index) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      elevation: 4,
      shadowColor: Colors.grey,
      child: ListTile(
        onTap: () {

        },
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color(0xff33B2B9),
              width: 1,
            )
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        leading: Image.asset('assets/icons/hamburger.png'),
        title: Text(
          CurrencyFormat.convertToIdr(int.parse(salesinvoiceJson[index]['total_amount']), 0),
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14
          ),
        ),
        subtitle: Text(
          salesinvoiceJson[index]['salesinvoiceitem_name'],
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 14
          ),
        ),
        trailing: InkWell(
          onTap: () async {
            if (Platform.isAndroid) {
              var bluetoothConnect = await Permission.bluetoothConnect.request();
              var bluetoothScan = await Permission.bluetoothScan.request();
              var bluetoothAdvertise = await Permission.bluetoothAdvertise.request();
              if (bluetoothConnect != PermissionStatus.granted
                  && bluetoothScan != PermissionStatus.granted
                  && bluetoothAdvertise != PermissionStatus.granted) {
                return;
              }
            }
            printReceipt(context, salesinvoiceJson[index]['sales_invoice_id']);
          },
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: Icon(
                Icons.print,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget makeCardMenu(context, index) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      elevation: 4,
      shadowColor: Colors.grey,
      child: ListTile(
        onTap: () {

        },
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color(0xff5189EA),
              width: 1,
            )
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        leading: Container(
          padding: const EdgeInsets.only(right: 10),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                  width: 1,
                  color: Color(0xff5189EA)
              ),
            ),
          ),
          child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xff5189EA).withOpacity(0.7),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: Center(
                  child: Text(
                    salesinvoiceitemJson[index]['item_name'][0].toUpperCase() + salesinvoiceitemJson[index]['item_name'][0].toLowerCase(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),
                  )
              )
          ),
        ),
        title: Text(
          CurrencyFormat.convertToIdr(salesinvoiceitemJson[index]['subtotal_amount'], 0),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14
          ),
        ),
        subtitle: Text(
          salesinvoiceitemJson[index]['item_name'] + " x " + salesinvoiceitemJson[index]['quantity'].toString(),
          style: const TextStyle(
              color: Colors.black,
              fontSize: 14
          ),
        ),
      ),
    );
  }

  void fetchCategories(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    // showLoaderDialog(context);
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
        // berhasil
        // hideLoaderDialog(context);
        itemCategory = json.encode(response.data['data']);
        // await prefs.setString('itemcategory', itemCategory);
        // print(itemCategory[0]);
      }
    } on DioException catch (e) {
      // hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        // gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {

      }
    }
  }

  void printUnpaidOrder(context, var salesInvoiceId) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sales_invoice_id', salesInvoiceId.toString());
    prefs.setString('print_status', "1");

    printUnpaidOrderAction(context);
  }

  Future<void> printUnpaidOrderAction(context) async {
    if (await PrintBluetoothThermal.bluetoothEnabled) {
      if (await PrintBluetoothThermal.connect(macPrinterAddress: macAddressPrintKitchen)) {
        setState(() {
          PrintBluetoothThermal.connect(macPrinterAddress: macAddressPrintKitchen);
        });
        CustomSnackbar.show(context, 'Printer Terhubung');
      } else {
        bool conectionStatus = await PrintBluetoothThermal.connectionStatus;
        setState(() {
          PrintBluetoothThermal.connect(macPrinterAddress: macAddressPrintKitchen);
        });
        if (conectionStatus) {
          // Fetch data printer dari database
          await getSalesPrintData(context);
          List<int> ticket = await printOrder();
          await PrintBluetoothThermal.writeBytes(ticket);
          /*print("print result: $result");*/
          CustomSnackbar.show(context, 'Print Nota Berhasil');
        } else {
          // no connected
          CustomSnackbar.show(context, 'Print Nota Gagal, Perikas Printer Anda', backgroundColor: Colors.red);
        }
      }
    } else {
      await PrintBluetoothThermal.disconnect;
      /*setState(() {
        disconnect();
      });*/
      CustomSnackbar.show(context, 'Aktifkan Bluetooth', backgroundColor: Colors.red);
    }
  }

  Future<List<int>> printOrder() async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    /*final ByteData data = await rootBundle.load('assets/mozaic/logo-print-holyvlle.jpg');
    final Uint8List bytesImg = data.buffer.asUint8List();
    img.Image? image = img.decodeImage(bytesImg);*/
    // Logo Company
    /*bytes += generator.image(image!);*/
    // Nama Company
    bytes += generator.text(preferenceCompanyPrint['company_name'].toString(), styles: const PosStyles(bold: true, align: PosAlign.center));
    // Alamat Company
    bytes += generator.text(preferenceCompanyPrint['company_address'].toString(), styles: const PosStyles(bold: true, align: PosAlign.center));
    // Whatsapp Company
    bytes += generator.text('Whatsapp: ${preferenceCompanyPrint['company_phone_number']}', styles: const PosStyles(bold: true, align: PosAlign.center), linesAfter: 1);
    // Tanggal dan Kasir
    bytes += generator.text('================================', styles: const PosStyles(bold: true));
    bytes += generator.text('Tanggal: ${salesinvoicePrint['sales_invoice_date'].toString()}', styles: const PosStyles(bold: true, align: PosAlign.left));
    bytes += generator.text('Kasir: ${salesinvoicePrint['name'].toString()}', styles: const PosStyles(bold: true, align: PosAlign.left));
    bytes += generator.text('================================', styles: const PosStyles(bold: true), linesAfter: 1);
    // Unpaid Order
    if (salesinvoicePrint['table_no'] != null) {
      bytes += generator.text(salesinvoicePrint['table_no'].toString(), styles: const PosStyles(bold: true, align: PosAlign.center));
    } else {
      bytes += generator.text('', styles: const PosStyles(bold: true, align: PosAlign.center));
    }

    for (var value in salesinvoiceitemPrint) {
      bytes += generator.row([
        PosColumn(text: value['item_name'].toString(), width: 10, styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(text: "x${value['quantity']}", width: 2, styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      if (value['item_remark'] != null) {
        bytes += generator.text(value['item_remark'].toString(), styles: const PosStyles(align: PosAlign.left));
      } else {
        bytes += generator.text('', styles: const PosStyles(align: PosAlign.left));
      }
    }
    bytes += generator.text(salesinvoicePrint['created_at'].toString().substring(0, 19), styles: const PosStyles(bold: true, align: PosAlign.right));
    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  void printReceipt(context, var salesInvoiceId) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sales_invoice_id', salesInvoiceId.toString());
    prefs.setString('print_status', "0");

    // Print Aksi
    printOrderAction(context);
  }

  Future<void> printOrderAction(context) async {
    if (await PrintBluetoothThermal.bluetoothEnabled) {
      if (await PrintBluetoothThermal.connect(macPrinterAddress: macAddressPrintCashier)) {
        setState(() {
          PrintBluetoothThermal.connect(macPrinterAddress: macAddressPrintCashier);
        });
        CustomSnackbar.show(context, 'Printer Terhubung');
      } else {
        bool conectionStatus = await PrintBluetoothThermal.connectionStatus;
        setState(() {
          PrintBluetoothThermal.connect(macPrinterAddress: macAddressPrintCashier);
        });
        if (conectionStatus) {
          // Fetch data printer dari database
          await getSalesPrintData(context);
          List<int> ticket = await printNota();
          await PrintBluetoothThermal.writeBytes(ticket);
          /*print("print result: $result");*/
          CustomSnackbar.show(context, 'Print Nota Berhasil');
        } else {
          // no connected
          CustomSnackbar.show(context, 'Print Nota Gagal, Perikas Printer Anda', backgroundColor: Colors.red);
        }
      }
    } else {
      await PrintBluetoothThermal.disconnect;
      /*setState(() {
        disconnect();
      });*/
      CustomSnackbar.show(context, 'Aktifkan Bluetooth', backgroundColor: Colors.red);
    }
  }

  getSalesPrintData(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    // showLoaderDialog(context);
    token = prefs.getString('token')!;
    salesInvoiceId = prefs.getString('sales_invoice_id')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.salesPrint,
        data: {
          'user_id': userId,
          'sales_invoice_id': salesInvoiceId
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        // hideLoaderDialog(context);
        salesinvoicePrint = response.data['salesinvoice'];
        salesinvoiceitemPrint = response.data['salesinvoiceitem'];
        preferenceCompanyPrint = response.data['preferencecompany'];
        // Messsage
      }
    } on DioException catch (e) {
      // hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        /*print(e.message);*/
      }
    }
  }

  Future<List<int>> printNota() async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    /*final ByteData data = await rootBundle.load('assets/mozaic/logo-print-holyvlle.jpg');
    final Uint8List bytesImg = data.buffer.asUint8List();
    img.Image? image = img.decodeImage(bytesImg);*/
    // Logo Company
    /*bytes += generator.image(image!);*/
    // Nama Company
    bytes += generator.text(preferenceCompanyPrint['company_name'].toString(), styles: const PosStyles(bold: true, align: PosAlign.center));
    // Alamat Company
    bytes += generator.text(preferenceCompanyPrint['company_address'].toString(), styles: const PosStyles(bold: true, align: PosAlign.center));
    // Whatsapp Company
    bytes += generator.text('Whatsapp: ${preferenceCompanyPrint['company_phone_number']}', styles: const PosStyles(bold: true, align: PosAlign.center), linesAfter: 1);
    // Tanggal dan Kasir
    bytes += generator.text('================================', styles: const PosStyles(bold: true));
    bytes += generator.text('Tanggal: ${salesinvoicePrint['sales_invoice_date'].toString()}', styles: const PosStyles(bold: true, align: PosAlign.left));
    bytes += generator.text('Kasir: ${salesinvoicePrint['name'].toString()}', styles: const PosStyles(bold: true, align: PosAlign.left));
    bytes += generator.text('================================', styles: const PosStyles(bold: true), linesAfter: 1);
    // Order
    for (var value in salesinvoiceitemPrint) {
      bytes += generator.text(value['item_name'].toString(), styles: const PosStyles(bold: true, align: PosAlign.left));
      bytes += generator.row([
        PosColumn(
          text: 'Qty: ${value['quantity'].toString()}',
          width: 4,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: value['item_unit_price'] != 0 ? "@${CurrencyFormat.convertToIdrwithoutSymbol(int.parse(value['item_unit_price']), 0)}" : "0",
          width: 4,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: value['subtotal_amount'] != 0 ? CurrencyFormat.convertToIdrwithoutSymbol(int.parse(value['subtotal_amount']), 0) : "0",
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }
    // Summary
    bytes += generator.text('--------------------------------', styles: const PosStyles(bold: true));
    bytes += generator.row([
      PosColumn(
        text: "Subtotal",
        width: 9,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: salesinvoicePrint['subtotal_amount'] != 0 ? CurrencyFormat.convertToIdrwithoutSymbol(int.parse(salesinvoicePrint['subtotal_amount']), 0) : "0",
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Diskon",
        width: 9,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: salesinvoicePrint['discount_amount_total'] != 0 ? CurrencyFormat.convertToIdrwithoutSymbol(int.parse(salesinvoicePrint['discount_amount_total']), 0) : "0",
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "PPN",
        width: 9,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: salesinvoicePrint['ppn_amount_total'] != 0 ? CurrencyFormat.convertToIdrwithoutSymbol(double.parse(salesinvoicePrint['ppn_amount_total']), 0) : "0",
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Total",
        width: 9,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: salesinvoicePrint['total_amount'] != 0 ? CurrencyFormat.convertToIdrwithoutSymbol(int.parse(salesinvoicePrint['total_amount']), 0) : "0",
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Uang Bayar",
        width: 9,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: salesinvoicePrint['paid_amount'] != 0 ? CurrencyFormat.convertToIdrwithoutSymbol(int.parse(salesinvoicePrint['paid_amount']), 0) : "0",
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Kembalian",
        width: 9,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: salesinvoicePrint['change_amount'] != 0 ? CurrencyFormat.convertToIdrwithoutSymbol(int.parse(salesinvoicePrint['change_amount']), 0) : "0",
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    /*bytes += generator.text(preferenceCompanyPrint['receipt_bottom_text'].toString(), styles: const PosStyles(bold: true, align: PosAlign.center));*/
    bytes += generator.text(
      preferenceCompanyPrint['receipt_bottom_text'].toString(),
      styles: const PosStyles(
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.center
      ),
    );
    bytes += generator.text(salesinvoicePrint['created_at'].toString().substring(0, 19), styles: const PosStyles(bold: true, align: PosAlign.right));

    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  void addSalesItem(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    // showLoaderDialog(context);
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
        // hideLoaderDialog(context);
        itemCategory = json.encode(response.data['data']);
        await prefs.setString('itemcategory', itemCategory);
        // print(itemCategory);
        //SalesPage
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SalesOrderPage()));
      }
    } on DioException catch (e) {
      // hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        /*print(e.message);*/
      }
    }
  }

  void fetchUnPaidSalesToday(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    // showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.salesUnpaid,
        data: {
          'user_id': userId,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        // hideLoaderDialog(context);
        setState(() {
          unpaidsalesinvoice = json.encode(response.data['data']);
          unpaidsalesinvoiceJson = json.decode(unpaidsalesinvoice!);
        });
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

  Future<void> fetchPaidSalesToday(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    // showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.salesPaid,
        data: {
          'user_id': userId,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        // hideLoaderDialog(context);
        setState(() {
          salesinvoice = json.encode(response.data['data']);
          salesinvoiceJson = json.decode(salesinvoice!);
          totalAmountToday = response.data['total_amount_today'].toString();
        });
      }
    } on DioException catch (e) {
     /* print(e);*/
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

  Future<void> fetchPaidSalesTodayMenu(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    // showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.salesPaidMenu,
        data: {
          'user_id': userId,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        // hideLoaderDialog(context);
        setState(() {
          salesinvoiceitem = json.encode(response.data['data']);
          salesinvoiceitemJson = json.decode(salesinvoiceitem!);
        });
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

  Future<void> paySavedOrder(context, var salesInvoiceId) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    // showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.salesSaved,
        data: {
          'user_id': userId,
          'sales_invoice_id': salesInvoiceId,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        // hideLoaderDialog(context);
        setState(() {
          savedItem = json.encode(response.data['data']);
          tableNo = response.data['table_no'];
          discountPercentageTotal = response.data['discount_percentage_total'];
          discountAmountTotal = response.data['discount_amount_total'];
          // ppn_percentage_total = response.data['ppn_percentage_total'];
          // ppn_amount_total = response.data['ppn_amount_total'];
        });
        /*if (tableNo == null) {
          tableNo = '';
        }*/
        tableNo ?? (tableNo = '');
        await prefs.setString('saveditems', savedItem!);
        await prefs.setString('table_no', tableNo!);
        await prefs.setString('sales_invoice_id', salesInvoiceId.toString());
        await prefs.setString('discount_percentage_total', discountPercentageTotal!);
        await prefs.setString('discount_amount_total', discountAmountTotal!);
        // await prefs.setString('ppn_percentage_total', ppn_percentage_total!);
        // await prefs.setString('ppn_amount_total', ppn_amount_total!);
        //SalesPage
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SalesDetailSavedPage()));
        //Messsage
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

  Future<void> fetchPrinterAddress(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    /*showLoaderDialog(context);*/
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.printerAddress,
        data: {
          'user_id': userId
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        /*hideLoaderDialog(context);*/
        String prefPrinterAddress = response.data['data'].toString();
        await prefs.setString('printer_address', prefPrinterAddress);
        macAddressPrintCashier = prefPrinterAddress;
      }
    } on DioException catch (e) {
      /*hideLoaderDialog(context);*/
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        // gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
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
        String prefPrinterKitchenAddress = response.data['data'].toString();
        await prefs.setString('printer_kitchen_address', prefPrinterKitchenAddress);
        macAddressPrintKitchen = prefPrinterKitchenAddress;
      }
    } on DioException catch (e) {
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
