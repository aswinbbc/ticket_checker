import 'package:flutter/material.dart';
import 'package:ticket_checker/features/checker/repo/checker_repo.dart';
import 'package:ticket_checker/utils/app_build_methods.dart';

class CheckerViewModel extends ChangeNotifier {
  //not used
  getMyTickets(String ticketNo,String seatNos, BuildContext context) {
    GetTicketRepo(ticketNo,seatNos).fetchFromAPIService(
      onShowError: (msg, [asToast]) {
        showAppToast(msg: msg);
      },
      onSuccess: (tickets) {},
    );
  }
}
