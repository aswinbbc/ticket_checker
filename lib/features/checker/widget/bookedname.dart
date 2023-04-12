import 'package:flutter/material.dart';
import 'package:ticket_checker/constants/colors.dart';

class CustomerName extends StatelessWidget {
  const CustomerName({
    super.key,
    required this.customerName,
  });

  final String customerName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Customer Name",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryTextColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(customerName,
                style: const TextStyle(
                  fontSize: 15,
                )),
          )
        ],
      ),
    );
  }
}
