import 'package:flutter/material.dart';
import 'package:ticket_checker/components/qrscan.dart';
import 'package:ticket_checker/constants/colors.dart';

class QrScannerBox extends StatelessWidget {
  const QrScannerBox({
    super.key,
    required this.orderNumberController,
  });

  final TextEditingController orderNumberController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order No",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryTextColor),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 35.0, color: Colors.black),
                  decoration: InputDecoration(
                    // hasFloatingPlaceholder: true,
                    suffixIcon: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                      mainAxisSize: MainAxisSize.min, // added line
                      children: <Widget>[
                        IconButton(
                          iconSize: 50,
                          icon: const Icon(Icons.qr_code_scanner_rounded),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const QrCode(),
                            ));
                          },
                        ),
                      ],
                    ),
                  ),
                  controller: orderNumberController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
