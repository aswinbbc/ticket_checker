import 'package:ticket_checker/features/checker/model/booking_details_model.dart';
import 'package:ticket_checker/features/checker/repo/checker_api.dart';
import 'package:ticket_checker/providers/_base.dart';
import 'package:ticket_checker/services/web_api_service.dart';

class CheckerRepo extends BaseSimpleAPIProvider<BookingDetails> {
  String ticketNo;
  CheckerRepo(this.ticketNo);
  @override
  Future<BookingDetails?> apiService() {
    return WebAPIService().getTicket(ticketNo);
  }
}
