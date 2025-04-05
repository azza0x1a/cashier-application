/*
import 'package:app_settings/app_settings.dart';
import 'package:dio/dio.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:mozaic_app/helper/responsive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../../style/app_properties.dart';
import '../../../style/custom_background.dart';
import '../../../utility/blueprint.dart';
import '../../../utility/currency_format.dart';
import '../../../widget/custom_loading.dart';
import '../../main/main_bottom_navigation.dart';
import 'no_printer_page.dart';

class ExpenditurePrintAllPage extends StatefulWidget {
  const ExpenditurePrintAllPage({super.key});

  @override
  State<ExpenditurePrintAllPage> createState() => _ExpenditurePrintAllPageState();
}

class _ExpenditurePrintAllPageState extends State<ExpenditurePrintAllPage> {
  String username = '';
  String user_id = '';
  String user_group_name = '';
  String printer_address = '';
  String printer_kitchen_address = '';
  String token = '';
  String sales_invoice_id = '';
  String start_date = DateTime.now().toString();
  String end_date = DateTime.now().toString();
  late FocusNode myFocusNode;
  bool bluetooth_state = false;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult>? scanResult;
  List<ScanResult>? filteredScanResult;
  int? navbar_index;
  var salesinvoice;
  var salesinvoiceitem;
  var preferencecompany;
  var expenditure;
  int capital_money_total = 0;
  int expenditure_total = 0;
  int discount_total = 0;
  int ppn_total = 0;
  int sales_subtotal = 0;
  int sales_total = 0;
  int profit = 0;
  int cashier_cash = 0;
  int sales_cash_subtotal = 0;
  int sales_gopay_subtotal = 0;
  int sales_ovo_subtotal = 0;
  int sales_shopeepay_subtotal = 0;
  int sales_others_subtotal = 0;
  int cashier_non_cash = 0;
  int sales_cash_total = 0;
  int sales_non_cash_total = 0;
  int print_status = 0;

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    fetchPrinterAddress(context);
    myFocusNode = FocusNode();
  }

  loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username')!;
      user_id = prefs.getString('user_id')!;
      user_group_name = prefs.getString('user_group_name')!;
      token = prefs.getString('token')!;
      printer_address = prefs.getString('printer_address')!;
    });
  }

  void findDevices() {
    flutterBlue.startScan(timeout: const Duration(seconds: 5));
    flutterBlue.scanResults.listen((results) {
      setState(() {
        if (printer_address.isNotEmpty || printer_kitchen_address.isNotEmpty) {
          scanResult = results
              .where((i) =>
          i.device.name == printer_address ||
              i.device.name == printer_kitchen_address)
              .toList();
        }
        scanResult = results;
      });
    });
    flutterBlue.stopScan();
    filteredScanResult = FlutterBlue.instance.scan().where((scanResult) {
      final advertisingData = scanResult.advertisementData;
      final deviceName = scanResult.device.name;
      return (advertisingData.manufacturerData[0x004C] == [0x02, 0x15] ||
          advertisingData.manufacturerData[0x0051] != null) &&
          deviceName.startsWith('Phone');
    }) as List<ScanResult>?;

    setState(() {
      scanResult = filteredScanResult;
      print("Before Filter : ");
      print(filteredScanResult);
    });
  }

  void printWithDevice(BluetoothDevice device) async {
    device.disconnect();
    await device.connect();
    final gen = Generator(PaperSize.mm80, await CapabilityProfile.load());
    final printer = BluePrint();
    // print(navbar_index);
    await getExpenditurePrintData(context);
    await getExpenditurePrintByDateData(context);

    printer.add(
      gen.text(
        'Struk Pengeluaran',
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
    );
    printer.add(
      gen.text(
        preferencecompany['company_name'].toString(),
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
    );
    printer.add(
      gen.text(
        preferencecompany['company_address'].toString(),
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
    );
    printer.add(
      gen.text(
        'WA ' + preferencecompany['company_phone_number'].toString(),
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
    );
    printer.add(gen.feed(1));
    printer.add(
      gen.text(
        DateFormat('d MMMM y').format(DateTime.parse(start_date)) +
            " s/d " +
            DateFormat('d MMMM y').format(DateTime.parse(end_date)),
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
    );
    printer.add(gen.feed(1));
    printer.add(
      gen.text(
        'Total Pengeluaran : ' + CurrencyFormat.convertToIdrwithoutSymbol(expenditure_total, 0),
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
    );
    printer.add(gen.feed(1));
    printer.add(
      gen.row([
        PosColumn(
          text: expenditure['expenditure_remark'].toString(),
          width: 9,
          styles: PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: expenditure['expenditure_amount'] != 0
              ? CurrencyFormat.convertToIdrwithoutSymbol(
              int.parse(expenditure['expenditure_amount'].toString()), 0)
              : "0",
          width: 3,
          styles: PosStyles(align: PosAlign.right),
        ),
      ]),
    );
    printer.add(gen.feed(1));
    printer.add(
      gen.text(
        preferencecompany['receipt_bottom_text'].toString(),
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
    );
    printer.add(gen.feed(2));
    printer.add(
      gen.text(
        expenditure['created_at'].toString().substring(0, 19),
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ),
    );
    printer.add(
      gen.text(
        expenditure['name'].toString(),
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ),
    );
    printer.add(gen.feed(3));
    await printer.printData(device);
    device.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      // Mobile View
      mobile: CustomPaint(
        painter: MainBackground(),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.transparent,
              title: Text(
                'Print',
                style: TextStyle(color: darkGrey, fontSize: 18.sp),
              ),
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                    children: <Widget>[
                      StreamBuilder<BluetoothState>(
                          stream: FlutterBlue.instance.state,
                          initialData: BluetoothState.unknown,
                          builder: (c, snapshot) {
                            final state = snapshot.data;
                            if (state == BluetoothState.on) {
                              return Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 20, right: 20).w,
                                      width: MediaQuery.of(context).size.width / 1.7,
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          Map<Permission, PermissionStatus> statuses = await [
                                            Permission.location,
                                            Permission.bluetoothScan,
                                            Permission.bluetoothAdvertise,
                                            Permission.bluetoothConnect,
                                          ].request();
                                          if (statuses[Permission.location]!.isGranted &&
                                              statuses[Permission.bluetoothScan]!.isGranted &&
                                              statuses[Permission.bluetoothAdvertise]!.isGranted &&
                                              statuses[Permission.bluetoothConnect]!.isGranted) {
                                            findDevices();
                                          }
                                          // printWithDevice(scanResult![2].device);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color.fromRGBO(236, 60, 3, 1),
                                        ),
                                        icon: Icon(
                                          Icons.bluetooth_connected,
                                          color: Colors.white,
                                          size: 12.sp,
                                        ),
                                        label: Text('SCAN DEVICE',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.sp)), // <-- Text
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    SizedBox(
                                      height: 600.h,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return (scanResult![index].device.name == printer_address) ? Container(
                                              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: [
                                                    Color(0xffFCE183),
                                                    Color(0xffF68D7F),
                                                  ],
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(0, 3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: ListTile(
                                                trailing: SimpleShadow(
                                                  child: Image.asset(
                                                    'assets/icons/printer.png',
                                                    height: 40.h,
                                                    width: 40.w,
                                                  ),
                                                  opacity: 0.6,
                                                  color: Colors.black26,
                                                  offset: Offset(2, 2),
                                                  sigma: 5,
                                                ),
                                                title: Text(
                                                    "Printer Kasir : ${scanResult![index].device.name}",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14.sp,
                                                        color: Colors.white)
                                                ),
                                                subtitle: Text(
                                                    "MAC Address : ${scanResult![index].device.id.id}",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14.sp,
                                                        color: Colors.white)
                                                ),
                                                onTap: () =>
                                                    printWithDevice(scanResult![index].device),
                                              ),
                                            ) : Container();
                                          },
                                          itemCount: scanResult?.length ?? 0),
                                    ),
                                  ]
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            print(state);
                                            AppSettings.openBluetoothSettings();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromRGBO(236, 60, 3, 1),
                                          ),
                                          icon: Icon(
                                            Icons.bluetooth,
                                            color: Colors.white,
                                            size: 12.sp,
                                          ),
                                          label: Text('HIDUPKAN BLUETOOTH',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12.sp)
                                          ),
                                        ),
                                        NoPrinterPage()
                                      ],
                                    )
                                ),
                              );
                            }
                          }),
                      SizedBox(height: 20.h),
                    ]
                ),
              ),
            )
        ),
      ),

      // Tablet View
      tablet: CustomPaint(
        painter: MainBackground(),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.transparent,
              title: Text(
                'Print',
                style: TextStyle(color: darkGrey, fontSize: 36),
              ),
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                    children: <Widget>[
                      StreamBuilder<BluetoothState>(
                          stream: FlutterBlue.instance.state,
                          initialData: BluetoothState.unknown,
                          builder: (c, snapshot) {
                            final state = snapshot.data;
                            if (state == BluetoothState.on) {
                              return Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 40, right: 40),
                                      height: 60,
                                      width: MediaQuery.of(context).size.width / 2.5,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          findDevices();
                                          // printWithDevice(scanResult![2].device);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color.fromRGBO(236, 60, 3, 1),
                                        ),
                                        icon: Icon(
                                          Icons.bluetooth_connected,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        label: Text('SCAN DEVICE',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 24
                                            )
                                        ), // <-- Text
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    SizedBox(
                                      height: 600,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return (scanResult![index].device.name == printer_address) ? Container(
                                              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: [
                                                    Color(0xffFCE183),
                                                    Color(0xffF68D7F),
                                                  ],
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(0, 3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: ListTile(
                                                trailing: SimpleShadow(
                                                  child: Image.asset(
                                                    'assets/icons/printer.png',
                                                    height: 80,
                                                    width: 80,
                                                  ),
                                                  opacity: 0.6,
                                                  color: Colors.black26,
                                                  offset: Offset(2, 2),
                                                  sigma: 5,
                                                ),
                                                title: Text(
                                                    "Printer Kasir : ${scanResult![index].device.name}",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 28,
                                                        color: Colors.white)
                                                ),
                                                subtitle: Text(
                                                    "MAC Address : ${scanResult![index].device.id.id}",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 28,
                                                        color: Colors.white)
                                                ),
                                                onTap: () =>
                                                    printWithDevice(scanResult![index].device),
                                              ),
                                            ) : Container();
                                          },
                                          itemCount: scanResult?.length ?? 0),
                                    ),
                                  ]
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            print(state);
                                            AppSettings.openBluetoothSettings();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromRGBO(236, 60, 3, 1),
                                          ),
                                          icon: Icon(
                                            Icons.bluetooth,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          label: Text('HIDUPKAN BLUETOOTH',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 24
                                              )
                                          ),
                                        ),
                                        const NoPrinterPage()
                                      ],
                                    )
                                ),
                              );
                            }
                          }),
                      SizedBox(height: 40),
                    ]
                ),
              ),
            )
        ),
      ),

      // Desktop View
      desktop: Container(
        child: Center(
          child: Text(
            'Desktop Mode Unavailable'
          ),
        ),
      ),
    );
  }

  getExpenditurePrintData(BuildContext context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    String expenditure_id = prefs.getString('expenditure_id')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.expenditurePrint,
        data: {
          'user_id': user_id,
          'expenditure_id': expenditure_id
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        expenditure = response.data['expenditure'];
        preferencecompany = response.data['preferencecompany'];
        //Messsage
        //SettingsPage
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => MainBottomNavigation()));
      }
    } on DioError catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
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
      } else {
        print(e.message);
      }
    }
  }

  getExpenditurePrintByDateData(BuildContext context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    String expenditure_id = prefs.getString('expenditure_id')!;
    start_date = prefs.getString('start_date')!;
    if (start_date == null) {
      DateTime date_now = DateTime.now();
      start_date = date_now.toString();
    }
    end_date = prefs.getString('end_date')!;
    if (end_date == null) {
      DateTime date_now = DateTime.now();
      end_date = date_now.toString();
    }
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.dashboardPrint,
        data: {
          'user_id': user_id,
          'expenditure_id': expenditure_id,
          'dashboard_start_date': start_date,
          'dashboard_end_date': end_date,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        expenditure = response.data['expenditure'];
        expenditure_total = response.data['expenditure_total'];
        // Messsage
        // SettingsPage
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (BuildContext context) {
              return MainBottomNavigation();
            },
          ), (_) => false,
        );
      }
    } on DioError catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
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
      } else {
        print(e.message);
      }
    }
  }

  void fetchPrinterAddress(BuildContext context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.printerAddress,
        data: {
          'user_id': user_id
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        String prefPrinterAddress = response.data['data'].toString();
        await prefs.setString('printer_address', prefPrinterAddress);
        printer_address = prefPrinterAddress;
        //Messsage
        //SettingsPage
      }
    } on DioError catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
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
      } else {
        print(e.message);
      }
    }
  }

  void fetchPrinterKitchenAddress(BuildContext context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.printerKitchenAddress,
        data: {
          'user_id': user_id
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        String prefPrinterKitchenAddress = response.data['data'].toString();
        await prefs.setString(
            'printer_kitchen_address', prefPrinterKitchenAddress);
        printer_kitchen_address = prefPrinterKitchenAddress;
        //Messsage
        //SettingsPage
      }
    } on DioError catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
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
      } else {
        print(e.message);
      }
    }
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
*/
