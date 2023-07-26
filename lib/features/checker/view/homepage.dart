import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ticket_checker/components/input_field.dart';
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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var orderNumberController = TextEditingController();
  @override
  void initState() {
    // SystemChannels.textInput.invokeMethod('TextInput.hide');

    Permission.camera.status.then((status) {
      if (status.isDenied) {
        Permission.camera.request();
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
      }
    });
    myFocusNode.requestFocus();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // SystemChannels.textInput.invokeMethod('TextInput.hide');
      myFocusNode.requestFocus();
    }
  }

  String seatNos = "";
  final inputController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Center(child: Text("Search Tickets")),
      ),
      floatingActionButton: showFab
          ? Image.asset(
              "assets/icon/logo_nobg.png",
              height: 150,
            )
          : null,
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
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrScannerBox(
                  orderNumberController: orderNumberController,
                  onIconClick: () async => verify(await scanner.scan()),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: InputField(
                    // showCursor: false,
                    // readOnly: true,
                    focusNode: myFocusNode,
                    controller: inputController,
                    // border: InputBorder.none,
                    // style: const TextStyle(color: Colors.transparent),
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        verify(text);
                        inputController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void verify(String? scanedData) async {
    String? cameraScanResult = scanedData;
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
