import 'package:flutter/material.dart';
import 'package:mozaic_app/screens/category/category_page.dart';
import 'package:mozaic_app/screens/printer/printer_address_page.dart';
import 'package:mozaic_app/screens/printer/printer_kitchen_address_page.dart';

import '../../style/app_properties.dart';
import '../category/component/modal_category_page.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  PageController controller = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {

    // Mobile View
    Widget uangModalButton = ElevatedButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const ModalCategoryPage(),
        );
      },
      icon: const Icon(
        Icons.monetization_on,
        color: Colors.white,
        size: 18,
      ),
      label: const Text(
        'Uang Modal',
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

    Widget printerAddressButton = ElevatedButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const PrinterAddressPage(),
        );
      },
      icon: const Icon(
        Icons.print,
        color: Colors.white,
        size: 18,
      ),
      label: const Text(
        'Printer Kasir',
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

    Widget printerKitchenAddressButton = ElevatedButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const PrinterKitchenAddressPage(),
        );
      },
      icon: const Icon(
        Icons.print,
        color: Colors.white,
        size: 18,
      ),
      label: const Text(
        'Printer Dapur',
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

    Widget menuBaruButton = ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CategoryPage()));
      },
      icon: const Icon(
        Icons.menu,
        color: Colors.white,
        size: 18,
      ),
      label: const Text(
        'Menu Baru',
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
        return orientation == Orientation.landscape ? Material(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                image: const DecorationImage(image: AssetImage('assets/background.png')
                )
            ),
            child: Stack(
              children: [
                PageView(
                  onPageChanged: (value) {
                    setState(() {
                      pageIndex = value;
                    });
                  },
                  controller: controller,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/icons/printer.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32
                          ),
                          child: Text(
                            'Setting Printer',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 32
                          ),
                          child: Text(
                            'Anda dapat mengatur printer manual dengan memasukkan nama printer kedalam aplikasi Mozaic agar dapat tampil sewaktu dipindai.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            printerAddressButton,
                            printerKitchenAddressButton,
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/money-bag.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32
                          ),
                          child: Text(
                            'Uang Modal ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 32
                          ),
                          child: Text(
                            'Masukkan uang modal sebagai modal usaha',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 18
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 32
                            ),
                            child: uangModalButton
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/new-menu.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32
                          ),
                          child: Text(
                            'Menu Baru',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 32
                          ),
                          child: Text(
                            'Anda dapat mengatur Kategori, Item, Barang sesuai kebutuhan anda didalam aplikasi Mozaic Point of Sale.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 18
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 32
                            ),
                            child: menuBaruButton
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 16,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                  color: pageIndex == 0 ? yellow : Colors.white),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                  color: pageIndex == 1 ? yellow : Colors.white),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                  color: pageIndex == 2 ? yellow : Colors.white),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Opacity(
                              opacity: pageIndex != 2 ? 1.0 : 0.0,
                              child: TextButton(
                                child: const Text(
                                  'SKIP',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ), pageIndex != 2 ? TextButton(
                              child: const Text(
                                'NEXT',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                              onPressed: () {
                                if (!(controller.page == 2)) {
                                  controller.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
                                }
                              },
                            ) : TextButton(
                              child: const Text(
                                'FINISH',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ) : Material(
          child: Container(
            //      width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.grey[100],
                image: const DecorationImage(image: AssetImage('assets/background.png')
                )
            ),
            child: Stack(
              children: [
                PageView(
                  onPageChanged: (value) {
                    setState(() {
                      pageIndex = value;
                    });
                  },
                  controller: controller,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/icons/printer.png',
                            height: 200,
                            width: 200,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Setting Printer',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          child: Text(
                            'Anda dapat mengatur printer manual dengan memasukkan nama printer kedalam aplikasi Mozaic agar dapat tampil sewaktu dipindai.',
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            printerAddressButton,
                            printerKitchenAddressButton,
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/money-bag.png',
                            height: 200,
                            width: 200,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Uang Modal ',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          child: Text(
                            'Masukkan uang modal sebagai modal usaha',
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            child: uangModalButton
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/new-menu.png',
                            height: 200,
                            width: 200,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Menu Baru',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          child: Text(
                            'Anda dapat mengatur Kategori, Item, Barang sesuai kebutuhan anda didalam aplikasi Mozaic Point of Sale ini.',
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            child: menuBaruButton
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 16,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                  color: pageIndex == 0 ? yellow : Colors.white),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                  color: pageIndex == 1 ? yellow : Colors.white),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                  color: pageIndex == 2 ? yellow : Colors.white),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Opacity(
                              opacity: pageIndex != 2 ? 1.0 : 0.0,
                              child: TextButton(
                                child: const Text(
                                  'SKIP',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ), pageIndex != 2 ? TextButton(
                              child: const Text(
                                'NEXT',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                              onPressed: () {
                                if (!(controller.page == 2)) {
                                  controller.nextPage(
                                      duration: const Duration(milliseconds: 200),
                                      curve: Curves.linear);
                                }
                              },
                            ) : TextButton(
                              child: const Text(
                                'FINISH',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
