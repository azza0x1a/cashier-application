import 'package:flutter/material.dart';

class NoDataCard extends StatelessWidget {
  const NoDataCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      elevation: 2,
      shadowColor: Colors.grey,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_food,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Text(
              'Tidak ada data',
              style: TextStyle(
                fontSize: 16
              ),
            )
          ],
        ),
      ),
    );
  }
}
