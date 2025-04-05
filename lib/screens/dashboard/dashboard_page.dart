import 'dart:io';

import 'package:dio/dio.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:mozaic_app/screens/dashboard/dashboard_date_page.dart';
import 'package:mozaic_app/screens/dashboard/tablet/dashboard_date_page_tablet.dart';
import 'package:mozaic_app/style/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:mozaic_app/style/custom_background.dart';
import 'package:mozaic_app/utility/currency_format.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/no_data_card.dart';
import '../../widget/custom_loading.dart';
import '../../widget/custom_snackbar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String userId = '';
  String userName = '';
  String userGroupName = '';
  String token = '';
  String? startDate = DateTime.now().toString();
  String? endDate = DateTime.now().toString();
  String? expenditure;
  String? salesinvoiceitem;
  var expenditureJson = [];
  var salesinvoiceitemJson = [];
  Map<String, dynamic> preferenceCompanyPrint = {};
  int capitalMoneyTotal = 0;
  int expenditureTotal = 0;
  int discountTotal = 0;
  int ppnTotal = 0;
  int salesSubtotal = 0;
  int salesTotal = 0;
  int profit = 0;
  int cashierCash = 0;
  int salesCashSubtotal = 0;
  int salesGopaySubtotal = 0;
  int salesOvoSubtotal = 0;
  int salesShopeepaySubtotal = 0;
  int salesOthersSubtotal = 0;
  int cashierNonCash = 0;
  int salesCashTotal = 0;
  int salesNonCashTotal = 0;

  String macAddressPrintCashier = '';

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    fetchDashboardData(context);
    fetchPrinterAddress(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void rebuild() {
    loadSharedPreference();
    fetchDashboardData(context);
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

  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape ? LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              painter: MainBackground(),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  scrolledUnderElevation: 0,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.light,
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
                          builder: (context) => const DashboardDatePageTablet(),
                        ).then((value) => rebuild());
                      },
                    )
                  ],
                  title: const Text(
                    'Dashboard',
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
                        child: Row(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                      ),
                                      Card(
                                        margin: const EdgeInsets.all(16),
                                        elevation: 4,
                                        color: Colors.white,
                                        surfaceTintColor: Colors.orange,
                                        shadowColor: Colors.grey,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: const BorderSide(
                                              color: Color(0xffffb259),
                                              width: 1,
                                            )
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 10
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                minTileHeight: 1,
                                                title: const Text(
                                                  'Modal Tunai',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                trailing: Text(
                                                  CurrencyFormat.convertToIdr(capitalMoneyTotal, 0),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              const Divider(),
                                              ListTile(
                                                minTileHeight: 1,
                                                title: const Text(
                                                  'Penjualan',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                trailing: Text(
                                                  CurrencyFormat.convertToIdr(salesSubtotal, 0),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(left: 20),
                                                child: ListTile(
                                                  minTileHeight: 1,
                                                  title: const Text(
                                                    'Tunai',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  trailing: Text(CurrencyFormat.convertToIdr(salesCashSubtotal, 0),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(left: 20),
                                                child: ListTile(
                                                  minTileHeight: 1,
                                                  title: const Text(
                                                    'GoPay',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                  trailing: Text(CurrencyFormat.convertToIdr(salesGopaySubtotal, 0),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(left: 20),
                                                child: ListTile(
                                                  minTileHeight: 1,
                                                  title: const Text(
                                                    'OVO',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                  trailing: Text(CurrencyFormat.convertToIdr(salesOvoSubtotal, 0),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(left: 20),
                                                child: ListTile(
                                                  minTileHeight: 1,
                                                  title: const Text(
                                                    'ShopeePay',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                  trailing: Text(CurrencyFormat.convertToIdr(salesShopeepaySubtotal, 0),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(left: 20),
                                                child: ListTile(
                                                  minTileHeight: 1,
                                                  title: const Text(
                                                    'QRis',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                  trailing: Text(CurrencyFormat.convertToIdr(salesOthersSubtotal, 0),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                minTileHeight: 1,
                                                title: const Text(
                                                  'Diskon',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black
                                                  ),
                                                ),
                                                trailing: Text(
                                                  "(${CurrencyFormat.convertToIdr(discountTotal, 0)})",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black
                                                  ),
                                                ),
                                              ),
                                              const Divider(),
                                              ListTile(
                                                minTileHeight: 1,
                                                title: const Text(
                                                  'Total Pendapatan',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                trailing: Text(
                                                  CurrencyFormat.convertToIdr(salesTotal, 0),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              const Divider(),
                                              ListTile(
                                                minTileHeight: 1,
                                                title: const Text(
                                                  'Pengeluaran',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                trailing: Text(
                                                  "(${CurrencyFormat.convertToIdr(expenditureTotal, 0)})",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              const Divider(),
                                              ListTile(
                                                minTileHeight: 1,
                                                title: const Text(
                                                  'Laba',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                trailing: Text(
                                                  CurrencyFormat.convertToIdr(profit, 0),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              const Divider(),
                                              ListTile(
                                                minTileHeight: 1,
                                                title: const Text(
                                                  'PPN',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                trailing: Text(
                                                  CurrencyFormat.convertToIdr(ppnTotal, 0),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                minTileHeight: 1,
                                                title: const Text(
                                                  'Uang di Kasir',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                trailing: Text(
                                                  CurrencyFormat.convertToIdr(cashierCash, 0),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                minTileHeight: 1,
                                                title: const Text(
                                                  'Non Tunai',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                trailing: Text(
                                                  CurrencyFormat.convertToIdr(cashierNonCash, 0),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                )
                            ),
                            VerticalDivider(
                              width: 1,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(16),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        width: MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                          boxShadow: shadow,
                                          gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                Color(0xffF68D7F),
                                                Color(0xffFCE183),
                                              ]
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)
                                          ),
                                        ),
                                        child: const ListTile(
                                          dense: true,
                                          leading: Text(
                                            "Menu Laku",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16
                                            ),
                                          ),
                                        ),
                                      ),
                                      salesinvoiceitemJson.isNotEmpty ? ListView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: salesinvoiceitemJson.length,
                                        itemBuilder: (context, index) {
                                          return dashboardCardMenuLandscape(context, index);
                                          // return const Text("tes");
                                        },
                                      ) : const NoDataCard(),
                                      const SizedBox(height: 24),
                                      Container(
                                        margin: const EdgeInsets.all(16),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        width: MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                          boxShadow: shadow,
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Color(0xffF749A2),
                                              Color(0xffFF7375),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)
                                          ),
                                        ),
                                        child: const ListTile(
                                          dense: true,
                                          leading: Text(
                                            "Pengeluaran",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16
                                            ),
                                          ),
                                        ),
                                      ),
                                      expenditureJson.isNotEmpty ? ListView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: expenditureJson.length,
                                        itemBuilder: (context, index) {
                                          return dashboardExpenditureCardLandscape(context, index);
                                          // return const Text("tes");
                                        },
                                      ) : const NoDataCard(),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                )
                            ),
                          ],
                        )
                                                    ,
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () async {
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
                    printDashboard(context);
                  },
                  backgroundColor: yellow,
                  label: const Text(
                    'Cetak',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  icon: const Icon(
                    Icons.print,
                    color: Colors.black,
                  ),
                ),
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
                      builder: (context) => const DashboardDatePage(),
                    ).then((value) => rebuild());
                  },
                )
              ],
              title: const Text(
                'Dashboard',
                style: TextStyle(
                    color: darkGrey,
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                ),
              ),
            ),
            body: SafeArea(
              top: true,
              child: Column(
                children: [
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
                  Expanded(
                    child: LayoutBuilder(
                      builder: (_, constraints) => SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                              Card(
                                margin: const EdgeInsets.all(16),
                                elevation: 4,
                                color: Colors.white,
                                surfaceTintColor: Colors.orange,
                                shadowColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                      color: Color(0xffffb259),
                                      width: 1,
                                    )
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        minTileHeight: 1,
                                        title: const Text(
                                          'Modal Tunai',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        trailing: Text(
                                          CurrencyFormat.convertToIdr(capitalMoneyTotal, 0),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      ListTile(
                                        minTileHeight: 1,
                                        title: const Text(
                                          'Penjualan',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        trailing: Text(
                                          CurrencyFormat.convertToIdr(salesSubtotal, 0),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: ListTile(
                                          minTileHeight: 1,
                                          title: const Text(
                                            'Tunai',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: Text(CurrencyFormat.convertToIdr(salesCashSubtotal, 0),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: ListTile(
                                          minTileHeight: 1,
                                          title: const Text(
                                            'GoPay',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                            ),
                                          ),
                                          trailing: Text(CurrencyFormat.convertToIdr(salesGopaySubtotal, 0),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: ListTile(
                                          minTileHeight: 1,
                                          title: const Text(
                                            'OVO',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                            ),
                                          ),
                                          trailing: Text(CurrencyFormat.convertToIdr(salesOvoSubtotal, 0),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: ListTile(
                                          minTileHeight: 1,
                                          title: const Text(
                                            'ShopeePay',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                            ),
                                          ),
                                          trailing: Text(CurrencyFormat.convertToIdr(salesShopeepaySubtotal, 0),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: ListTile(
                                          minTileHeight: 1,
                                          title: const Text(
                                            'Lainnya',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                            ),
                                          ),
                                          trailing: Text(CurrencyFormat.convertToIdr(salesOthersSubtotal, 0),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                            ),
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        minTileHeight: 1,
                                        title: const Text(
                                          'Diskon',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                          ),
                                        ),
                                        trailing: Text(
                                          "(${CurrencyFormat.convertToIdr(discountTotal, 0)})",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      ListTile(
                                        minTileHeight: 1,
                                        title: const Text(
                                          'Total Pendapatan',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        trailing: Text(
                                          CurrencyFormat.convertToIdr(salesTotal, 0),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      ListTile(
                                        minTileHeight: 1,
                                        title: const Text(
                                          'Pengeluaran',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        trailing: Text(
                                          "(${CurrencyFormat.convertToIdr(expenditureTotal, 0)})",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      ListTile(
                                        minTileHeight: 1,
                                        title: const Text(
                                          'Laba',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        trailing: Text(
                                          CurrencyFormat.convertToIdr(profit, 0),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      ListTile(
                                        minTileHeight: 1,
                                        title: const Text(
                                          'Uang di Kasir',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        trailing: Text(
                                          CurrencyFormat.convertToIdr(cashierCash, 0),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        minTileHeight: 1,
                                        title: const Text(
                                          'Non Tunai',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        trailing: Text(
                                          CurrencyFormat.convertToIdr(cashierNonCash, 0),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10
                                ),
                                surfaceTintColor: const Color(0xffF68D7F),
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      color: Color(0xffF68D7F),
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
                                        color: Color(0xffF68D7F),
                                        width: 1,
                                      )
                                  ),
                                  leading: const Icon(
                                      Icons.fastfood
                                  ),
                                  title: const Text(
                                    "Menu Laku",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  children: [
                                    salesinvoiceitemJson.isNotEmpty ? ListView.builder(
                                      physics: const ClampingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: salesinvoiceitemJson.length,
                                      itemBuilder: (context, int index) {
                                        return dashboardCardMenu(context, index);
                                        // return const Text("tes");
                                      },
                                    ) : const NoDataCard(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10
                                ),
                                surfaceTintColor: const Color(0xffF749A2),
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      color: Color(0xffF749A2),
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
                                        color: Color(0xffF749A2),
                                        width: 1,
                                      )
                                  ),
                                  leading: const Icon(
                                      Icons.outbond
                                  ),
                                  title: const Text(
                                    "Pengeluaran",
                                    style: TextStyle(
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
                                        return dashboardExpenditureCard(context, index);
                                        // return const Text("tes");
                                      },
                                    ) : const NoDataCard(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
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
                printDashboard(context);
              },
              backgroundColor: Colors.white,
              label: const Text(
                'Cetak',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
              icon: const Icon(
                Icons.print,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  // Mobile View
  Widget dashboardCardMenu(context, int index) {
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
              color: Color(0xffF68D7F),
              width: 1,
            )
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        leading: Image.asset(
          'assets/icons/hamburger.png',
          fit: BoxFit.cover,
          height: 60,
          width: 60,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              salesinvoiceitemJson[index]['item_name'],
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: .4),
            Text(
              CurrencyFormat.convertToIdr(salesinvoiceitemJson[index]['subtotal_amount'], 0),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Jumlah : ${salesinvoiceitemJson[index]['quantity']}",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardExpenditureCard(context, int index) {
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
              color: Color(0xffF749A2),
              width: 1,
            )
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        leading: Image.asset(
          'assets/icons/hamburger.png',
          fit: BoxFit.cover,
          height: 60,
          width: 60,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              expenditureJson[index]['expenditure_remark'],
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: .4),
            Text(
              CurrencyFormat.convertToIdr(expenditureJson[index]['expenditure_amount'], 0),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tablet View
  Widget dashboardCardMenuLandscape(context, index) {
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color(0xffF68D7F),
              width: 1,
            )
        ),
        tileColor: Colors.white,
        leading: Image.asset('assets/icons/hamburger.png'),
        title: Text(
          salesinvoiceitemJson[index]['item_name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              CurrencyFormat.convertToIdr(salesinvoiceitemJson[index]['subtotal_amount'], 0),
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16
              ),
            ),
            Text(
              "Jumlah : ${salesinvoiceitemJson[index]['quantity']}",
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardExpenditureCardLandscape(context, index) {
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color(0xffF749A2),
              width: 1,
            )
        ),
        tileColor: Colors.white,
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
      ),
    );
  }

  void printDashboard(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('start_date', startDate!);
    prefs.setString('end_date', endDate!);

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
          await getDashboardPrintData(context);
          List<int> ticket = await printNota();
          await PrintBluetoothThermal.writeBytes(ticket);
          /*print("print result: $result");*/
          CustomSnackbar.show(context, 'Print Nota Berhasil');
        } else {
          // no connected
          CustomSnackbar.show(context, 'Print Nota Gagal, Periksa Printer Anda', backgroundColor: Colors.red);
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
    bytes += generator.text(
      "${DateFormat('d MMMM y').format(DateTime.parse(startDate!))} s/d ${DateFormat('d MMMM y').format(DateTime.parse(endDate!))}",
      styles: const PosStyles(bold: true, align: PosAlign.center),
    );
    /*bytes += generator.text('Kasir: ${expenditurePrint['name'].toString()}', styles: const PosStyles(bold: true, align: PosAlign.left));*/
    bytes += generator.text('================================', styles: const PosStyles(bold: true), linesAfter: 1);
    // Dashboard
    bytes += generator.text('Dashboard', styles: const PosStyles(bold: true, align: PosAlign.center), linesAfter: 1);
    bytes += generator.row([
      PosColumn(
        text: "Modal Tunai",
        width: 9,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: capitalMoneyTotal != 0
            ? CurrencyFormat.convertToIdrwithoutSymbol(
            capitalMoneyTotal, 0)
            : "0",
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Penjualan",
        width: 9,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: salesSubtotal != 0
            ? CurrencyFormat.convertToIdrwithoutSymbol(salesSubtotal, 0)
            : "0",
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "",
        width: 1,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: "Tunai",
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: salesCashSubtotal != 0
            ? CurrencyFormat.convertToIdrwithoutSymbol(
            salesCashSubtotal, 0)
            : "0",
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "",
        width: 1,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: "GoPay",
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: salesGopaySubtotal != 0
            ? CurrencyFormat.convertToIdrwithoutSymbol(
            salesGopaySubtotal, 0)
            : "0",
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "",
        width: 1,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: "Ovo",
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: salesOvoSubtotal != 0
            ? CurrencyFormat.convertToIdrwithoutSymbol(
            salesOvoSubtotal, 0)
            : "0",
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "",
        width: 1,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: "ShopeePay",
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: salesShopeepaySubtotal != 0
            ? CurrencyFormat.convertToIdrwithoutSymbol(
            salesShopeepaySubtotal, 0)
            : "0",
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "",
        width: 1,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: "QRis",
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: salesOthersSubtotal != 0
            ? CurrencyFormat.convertToIdrwithoutSymbol(
            salesOthersSubtotal, 0)
            : "0",
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Diskon",
        width: 7,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: discountTotal != 0
            ? CurrencyFormat.convertToIdrwithoutSymbol(discountTotal, 0)
            : "0",
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Total Pendapatan",
        width: 7,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: salesTotal != 0
            ? CurrencyFormat.convertToIdrwithoutSymbol(salesTotal, 0)
            : "0",
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Pengeluaran",
        width: 7,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: expenditureTotal != 0
            ? CurrencyFormat.convertToIdrwithoutSymbol(expenditureTotal, 0)
            : "0",
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Laba",
        width: 7,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: profit != 0
            ? CurrencyFormat.convertToIdrwithoutSymbol(profit, 0)
            : "0",
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "PPN",
        width: 7,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: ppnTotal != 0
            ? CurrencyFormat.convertToIdrwithoutSymbol(ppnTotal, 0)
            : "0",
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Uang di Kasir",
        width: 7,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: cashierCash != 0
            ? CurrencyFormat.convertToIdrwithoutSymbol(cashierCash, 0)
            : "0",
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Non Tunai",
        width: 7,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: cashierNonCash != 0
            ? CurrencyFormat.convertToIdrwithoutSymbol(cashierNonCash, 0)
            : "0",
        width: 5,
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
    /*bytes += generator.text(expenditurePrint['created_at'].toString().substring(0, 19), styles: const PosStyles(bold: true, align: PosAlign.right));*/

    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
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

  Future<void> getDashboardPrintData(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    // showLoaderDialog(context);
    token = prefs.getString('token')!;
    startDate = prefs.getString('start_date')!;
    if (startDate == null) {
      DateTime dateNow = DateTime.now();
      startDate = dateNow.toString();
    }
    endDate = prefs.getString('end_date')!;
    if (endDate == null) {
      DateTime dateNow = DateTime.now();
      endDate = dateNow.toString();
    }
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.dashboardPrint,
        data: {
          'user_id': userId,
          'dashboard_start_date': startDate,
          'dashboard_end_date': endDate,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        // hideLoaderDialog(context);
        setState(() {
          capitalMoneyTotal = response.data['capital_money_total'];
          expenditureTotal = response.data['expenditure_total'];
          discountTotal = response.data['discount_total'];
          ppnTotal = response.data['ppn_total'];
          salesSubtotal = response.data['sales_subtotal'];
          salesTotal = response.data['sales_total'];
          profit = salesTotal - expenditureTotal;
          cashierCash = profit + capitalMoneyTotal;
          preferenceCompanyPrint = response.data['preferencecompany'];
          salesCashSubtotal = response.data['sales_cash_subtotal'];
          salesGopaySubtotal = response.data['sales_gopay_subtotal'];
          salesOvoSubtotal = response.data['sales_ovo_subtotal'];
          salesShopeepaySubtotal = response.data['sales_shopeepay_subtotal'];
          salesOthersSubtotal = response.data['sales_others_subtotal'];
          salesCashTotal = response.data['sales_cash_total'];
          salesNonCashTotal = response.data['sales_non_cash_total'];
          cashierCash = salesCashTotal + capitalMoneyTotal;
          cashierNonCash = salesNonCashTotal;
        });
        // Messsage
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

  Future<void> fetchDashboardData(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    // showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.dashboard,
        data: {
          'user_id': userId,
          'dashboard_start_date': startDate,
          'dashboard_end_date': endDate,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        // hideLoaderDialog(context);
        setState(() {
          expenditureJson = response.data['expenditure'];
          salesinvoiceitemJson = response.data['salesinvoiceitem'];
          capitalMoneyTotal = response.data['capital_money_total'];
          expenditureTotal = response.data['expenditure_total'];
          discountTotal = response.data['discount_total'];
          ppnTotal = response.data['ppn_total'];
          salesSubtotal = response.data['sales_subtotal'];
          salesTotal = response.data['sales_total'];
          salesCashSubtotal = response.data['sales_cash_subtotal'];
          salesGopaySubtotal = response.data['sales_gopay_subtotal'];
          salesOvoSubtotal = response.data['sales_ovo_subtotal'];
          salesShopeepaySubtotal = response.data['sales_shopeepay_subtotal'];
          salesOthersSubtotal = response.data['sales_others_subtotal'];
          salesCashTotal = response.data['sales_cash_total'];
          salesNonCashTotal = response.data['sales_non_cash_total'];
          profit = salesTotal - expenditureTotal;
          cashierCash = salesCashTotal + capitalMoneyTotal;
          cashierNonCash = salesNonCashTotal;
        });
        //SalesPage
        //Messsage
      }
    } on DioException catch (e) {
      /*print(e);*/
      hideLoaderDialog(context);
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