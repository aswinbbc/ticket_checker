import 'package:dio/dio.dart';
import 'package:ticket_checker/services/web_api_service.dart';
import 'package:ticket_checker/utils/urls.dart';

extension HomeApi on WebAPIService {
  ///
  ///get all pending ticket count
  ///
  Future<int?> getTicket(String ticketNo) async {
    return dio
        .get(
          "$urlBaseApi/bookings/order-details?order_no=$ticketNo",
          // data: jsonEncode(params),
        )
        .then((res) => validateGET(res).then((value) {
              return res.data['data'] as int;
            }))
        .catchError((ex) {
      onDioError(ex, 'pending ticket');
      return 0;
    }, test: (ex) => ex is DioError);
  }
}
