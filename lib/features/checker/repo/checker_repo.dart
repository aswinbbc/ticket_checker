import 'package:ticket_checker/features/checker/model/booking_details_model.dart';
import 'package:ticket_checker/features/checker/repo/checker_api.dart';
import 'package:ticket_checker/providers/_base.dart';
import 'package:ticket_checker/services/web_api_service.dart';

class GetTicketRepo extends BaseSimpleAPIProvider<BookingDetails> {
  String ticketNo;
  String seatNos;
  GetTicketRepo(this.ticketNo, this.seatNos);
  @override
  Future<BookingDetails?> apiService() {
    return WebAPIService().getTicket(ticketNo, seatNos);
  }
}

class SubmitTicketRepo extends BaseSimpleAPIProvider<String> {
  String ticketNo;
  String seatNo;
  String totalSeats;
  SubmitTicketRepo(
      {required this.ticketNo, required this.seatNo, required this.totalSeats});
  @override
  Future<String?> apiService() {
    return WebAPIService().submitSelected(
      ticketNo: ticketNo,
      seatNo: seatNo,
      totalSeats: totalSeats,
    );
  }
}
