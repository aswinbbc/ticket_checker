import 'package:ticket_checker/features/checker/repo/home_api.dart';
import 'package:ticket_checker/providers/_base.dart';
import 'package:ticket_checker/services/web_api_service.dart';

class CheckerRepo extends BaseSimpleAPIProvider<int> {
  String ticketNo;
  CheckerRepo(this.ticketNo);
  @override
  Future<int?> apiService() {
    return WebAPIService().getTicket(ticketNo);
  }
}
