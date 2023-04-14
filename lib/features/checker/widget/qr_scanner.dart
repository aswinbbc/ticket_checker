import 'package:flutter/material.dart';
import 'package:ticket_checker/components/input_field.dart';
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            iconSize: 250,
            icon: const Icon(Icons.qr_code_scanner_rounded),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const QrCode(),
              ));
            },
          ),
          const Text(
            "Scan to above",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryTextColor),
          ),
          const Text(
            "OR",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryTextColor),
          ),
          SizedBox(
            height: 20,
          ),
          InputField(
            labelText: "Enter Ticket Number Here",
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 35.0, color: Colors.black),
            controller: orderNumberController,
          ),
        ],
      ),
    );
  }
}
