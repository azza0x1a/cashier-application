import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:mozaic_app/component/no_data_card.dart';
import 'package:mozaic_app/screens/expenditure/tablet/expenditure_date_page_tablet.dart';
import 'package:mozaic_app/screens/expenditure/tablet/expenditure_form_page_tablet.dart';
import 'package:mozaic_app/style/custom_background.dart';
import 'package:flutter/material.dart';
import 'package:mozaic_app/widget/custom_loading.dart';
import 'package:mozaic_app/widget/custom_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style/app_properties.dart';
import '../../utility/currency_format.dart';

class ExpenditurePage extends StatefulWidget {
  const ExpenditurePage({super.key});

  @override
  State<ExpenditurePage> createState() => _ExpenditurePageState();
}

class _ExpenditurePageState extends State<ExpenditurePage> {
  String userId = '';
  String userName = '';
  String userGroupName = '';
  String token = '';
  String expenditure = '';
  DateTime date = DateTime.now();
  String? startDate = DateTime.now().toString();
  String? endDate = DateTime.now().toString();
  int capitalAmount = 0;
  var expenditureJson = [];
  Map<String, dynamic> preferenceCompanyPrint = {};
  Map<String, dynamic> expenditurePrint = {};
  var expenditureTotal = 0;

  String macAddressPrintCashier = '';

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    fetchExpenditureToday(context);
    fetchPrinterAddress(context);
  }

  Future<void> loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id')!;
      userName = prefs.getString('username')!;
      userGroupName = prefs.getString('user_group_name')!;
      token = prefs.getString('token')!;

      startDate = prefs.getString('start_date') ?? '';
      if (startDate == null) {
        DateTime dateNow = DateTime.now();
        startDate = dateNow.toString();
      }

      endDate = prefs.getString('end_date');
      if (endDate == null) {
        DateTime dateNow = DateTime.now();
        endDate = dateNow.toString();
      }
    });
  }

  void rebuild() {
    loadSharedPreference();
    fetchExpenditureToday(context);
    fetchPrinterAddress(context);
  }

  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape ? LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double columnWidth = screenWidth / 2;
            return CustomPaint(
              painter: MainBackground(),
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.dark,
                      statusBarBrightness: Brightness.light,
                    ),
                    iconTheme: const IconThemeData(
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.transparent,
                    actions: [
                      IconButton(
                        icon: Image.asset(
                          'assets/icons/calendar.png',
                          height: 30,
                          width: 30,
                        ),
                         onPressed: () {
                          showModalBottomSheet(
                               context: context,
                            isScrollControlled: true,
                            isDismissible: false,
                            builder: (context) => const ExpenditureDatePageTablet(),
                          ).then((value) => rebuild());
                        },
                       )
                    ],
                    title: const Text(
                      'Pengeluaran',
                      style: TextStyle(
                          color: darkGrey,
                          fontWeight: FontWeight.w500,
                          fontSize: 28
                      ),
                    ),
                  ),
                  body: SafeArea(
                    top: true,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  yellow,
                                  Colors.deepOrange,
                                ]
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "${DateFormat('d MMMM y').format(DateTime.parse(startDate!))} s/d ${DateFormat('d MMMM y').format(DateTime.parse(endDate!))}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: OrientationBuilder(
                            builder: (context, orientation) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: columnWidth,
                                    child: expenditureJson.isNotEmpty ? ListView.builder(
                                      padding: const EdgeInsets.only(bottom: 80),
                                      physics: const ClampingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: expenditureJson.length,
                                      itemBuilder: (context, index) {
                                        return expenditureCardTablet(context, index);
                                        // return const Text("tes");
                                      },
                                    ) : const NoDataCard()
                                  ),
                                  Expanded(
                                    child: VerticalDivider(
                                      width: 1,
                                      color: Colors.grey.withOpacity(0.4),
                                    ),
                                  ),
                                  SizedBox(
                                    width: columnWidth,
                                    child: ListTile(
                                      dense: true,
                                      leading: const Text(
                                        "Pengeluaran",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26
                                        ),
                                      ),
                                      trailing: Text(
                                        expenditureTotal.toString() != '' ? CurrencyFormat.convertToIdr(expenditureTotal, 0) : "Jumlah Total",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                      // Add your onPressed code here!
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        isDismissible: false,
                        builder: (context) => const ExpenditureFormPageTablet(),
                      ).then((value) => rebuild());
                    },
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    label: const Text(
                      'Tambah Pengeluaran',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  )
              ),
            );
          },
        ) : CustomPaint(
          painter: MainBackground(),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                scrolledUnderElevation: 0,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                ),
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                actions: [
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/calendar.png',
                      height: 30,
                      width: 30,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => const ExpenditureDatePageTablet(),
                      ).then((value) => rebuild());
                    },
                  )
                ],
                backgroundColor: Colors.transparent,
                title: const Text(
                  'Pengeluaran',
                  style: TextStyle(color: darkGrey, fontSize: 18),
                ),
              ),
              body: LayoutBuilder(
                builder: (_, constraints) => SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              height: 48,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      yellow,
                                      Colors.deepOrange,
                                    ]
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "${DateFormat('d MMMM y').format(DateTime.parse(startDate!))} s/d ${DateFormat('d MMMM y').format(DateTime.parse(endDate!))}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10
                              ),
                              surfaceTintColor: const Color(0xffff76be),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Color(0xffff76be),
                                    width: 1,
                                  )
                              ),
                              elevation: 4,
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
                                      color: Color(0xffff76be),
                                      width: 1,
                                    )
                                ),
                                leading: const Icon(Icons.outbond),
                                title: const Text(
                                  "Pengeluaran",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),
                                subtitle: Text(
                                  expenditureTotal.toString() != '' ? CurrencyFormat.convertToIdr(expenditureTotal, 0) : "Jumlah Total",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                children: [
                                  expenditureJson.isNotEmpty ? ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: expenditureJson.length,
                                    itemBuilder: (context, int index) {
                                      return expenditureCardMobile(context, index);
                                      // return const Text("tes");
                                    },
                                  ) : const NoDataCard(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  // Add your onPressed code here!
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: false,
                    builder: (context) => const ExpenditureFormPageTablet(),
                  ).then((value) => rebuild());
                },
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                label: const Text(
                  'Tambah Pengeluaran',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              )
          ),
        );
      }
    );
  }

  // Expenditure Card Mobile View
  Widget expenditureCardMobile(context, int index) {
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
        leading: SizedBox(
          height: 60,
          width: 60,
          child: Image.asset(
            'assets/icons/hamburger.png',
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          expenditureJson[index]['expenditure_remark'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          CurrencyFormat.convertToIdr(expenditureJson[index]['expenditure_amount'], 0),
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
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
            printExpenditure(context, expenditureJson[index]['expenditure_id']);
          },
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

  // Expenditure Card Landscape View
  Widget expenditureCardTablet(context, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 26,
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
              color: Color(0xffff76be),
              width: 1,
            )
        ),
        leading: Image.asset('assets/icons/hamburger.png'),
        title: Text(
          expenditureJson[index]['expenditure_remark'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          CurrencyFormat.convertToIdr(expenditureJson[index]['expenditure_amount'], 0),
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16
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
            printExpenditure(context, expenditureJson[index]['expenditure_id']);
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

  void printExpenditure(context, var expenditureId) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('expenditure_id', expenditureId.toString());
    // Print Aksi
    printAction(context);
  }

  Future<void> printAction(context) async {
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
          await getExpenditurePrintData(context);
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
    bytes += generator.text('Tanggal: ${expenditurePrint['expenditure_date'].toString()}', styles: const PosStyles(bold: true, align: PosAlign.left));
    bytes += generator.text('Kasir: ${expenditurePrint['name'].toString()}', styles: const PosStyles(bold: true, align: PosAlign.left));
    bytes += generator.text('================================', styles: const PosStyles(bold: true), linesAfter: 1);
    // Expenditure
    bytes += generator.text('Struk Pengeluaran', styles: const PosStyles(bold: true, align: PosAlign.center), linesAfter: 1);
    bytes += generator.row([
      PosColumn(
        text: expenditurePrint['expenditure_remark'].toString(),
        width: 9,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: expenditurePrint['expenditure_amount'] != 0 ? CurrencyFormat.convertToIdrwithoutSymbol(int.parse(expenditurePrint['expenditure_amount'].toString()), 0) : "0",
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.text(
      preferenceCompanyPrint['receipt_bottom_text'].toString(),
      styles: const PosStyles(
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.center
      ),
    );
    bytes += generator.text(expenditurePrint['created_at'].toString().substring(0, 19), styles: const PosStyles(bold: true, align: PosAlign.right));

    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  Future<void>getExpenditurePrintData(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    /*showLoaderDialog(context);*/
    token = prefs.getString('token')!;
    String expenditureId = prefs.getString('expenditure_id')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.expenditurePrint,
        data: {
          'user_id': userId,
          'expenditure_id': expenditureId
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        /*hideLoaderDialog(context);*/
        expenditurePrint = response.data['expenditure'];
        preferenceCompanyPrint = response.data['preferencecompany'];
        // Messsage
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
        //Messsage
        //SettingsPage
      }
    } on DioException catch (e) {
      /*hideLoaderDialog(context);*/
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        /*print(e.message);*/
      }
    }
  }

  Future<void> fetchExpenditureToday(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.expenditureToday,
        data: {
          'user_id': userId,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        setState(() {
          expenditure = json.encode(response.data['data']);
          expenditureJson = json.decode(expenditure);
          expenditureTotal = response.data['total_expenditure'];
        });
        // SalesPage
        // Messsage
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

  /*void printExpenditureByDate(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('start_date', startDate!);
    prefs.setString('end_date', endDate!);

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ExpenditurePrintAllPage()));
  }*/
}