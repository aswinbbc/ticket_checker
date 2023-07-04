import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ticket_checker/components/qrscan.dart';
import 'package:ticket_checker/constants/colors.dart';
import 'package:ticket_checker/features/checker/repo/checker_repo.dart';
import 'package:ticket_checker/features/checker/view/detail_page.dart';
import 'package:ticket_checker/features/checker/widget/qr_scanner.dart';
import 'package:ticket_checker/utils/app_build_methods.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var orderNumberController = TextEditingController();
  @override
  void initState() {
    Permission.camera.status.then((status) {
      if (status.isDenied) {
        Permission.camera.request();
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
      }
    });

    super.initState();
  }

  String seatNos = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Center(child: Text("Search Tickets")),
      ),
      floatingActionButton: Image.asset(
        "assets/icon/logo_nobg.png",
        height: 150,
      ),
      // Text.rich(
      //   TextSpan(
      //     text: 'Powered by ',
      //     children: <TextSpan>[
      //       TextSpan(
      //           text: 'Amalgamate',
      //           style: TextStyle(fontWeight: FontWeight.bold)),
      //     ],
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: QrScannerBox(
        orderNumberController: orderNumberController,
        onIconClick: () async {
          String? cameraScanResult = await scanner.scan();
          if (cameraScanResult?.isNotEmpty ?? false) {
            try {
              seatNos = "";
              print(cameraScanResult);
              final ticket = jsonDecode(cameraScanResult ?? '');
              final ticketNo = ticket['order_number'];
              seatNos = ticket['seat_number'];
              orderNumberController.text = ticketNo;
              checkDetails(context);
            } catch (e) {
              Alert(
                      context: context,
                      title: "Alert",
                      desc: "Not a valid ticket",
                      type: AlertType.info)
                  .show();
            }
          }

          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => const QrCode(),
          // ));
        },
      ),
    );
  }

  void checkDetails(BuildContext context) {
    GetTicketRepo(orderNumberController.text, seatNos).fetchFromAPIService(
      onShowError: (msg, [asToast]) {
        Alert(context: context, title: "Alert", desc: msg, type: AlertType.info)
            .show();
      },
      onSuccess: (tickets) {
        if (tickets != null) {
          if (tickets.result != null) {
            orderNumberController.clear();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailPage(data: tickets, seatNos: seatNos),
                ));
          } else {
            Alert(
                    context: context,
                    title: "Alert",
                    desc: tickets.message ?? "Not a valid ticket",
                    type: AlertType.info)
                .show();
          }
        } else {
          Alert(
                  context: context,
                  title: "Alert",
                  desc: "Not a valid ticket",
                  type: AlertType.info)
              .show();
        }
      },
    );
  }
}
