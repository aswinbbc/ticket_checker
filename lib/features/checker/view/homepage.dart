import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_checker/constants/colors.dart';
import 'package:ticket_checker/dummy_data.dart';
import 'package:ticket_checker/features/checker/model/booking_details_model.dart';
import 'package:ticket_checker/features/checker/repo/checker_repo.dart';
import 'package:ticket_checker/features/checker/view/detail_page.dart';
import 'package:ticket_checker/features/checker/view_model/checker_viewmodel.dart';
import 'package:ticket_checker/features/checker/widget/qr_scanner.dart';
import 'package:ticket_checker/utils/app_build_methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var orderNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Center(child: Text("Search Tickets")),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QrScannerBox(orderNumberController: orderNumberController),
          Center(
            child: ElevatedButton(
              onPressed: () {
                CheckerRepo(orderNumberController.text).fetchFromAPIService(
                  onShowError: (msg, [asToast]) {
                    showAppToast(msg: msg);
                  },
                  onSuccess: (tickets) {
                    if (tickets != null) {
                      if (tickets.result != null) {
                        orderNumberController.clear();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(data: tickets),
                            ));
                      } else {
                        showAppToast(msg: tickets.message!);
                      }
                    } else {
                      showAppToast(msg: "no ticket found");
                    }
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Search"),
            ),
          ),
        ],
      ),
    );
  }
}
