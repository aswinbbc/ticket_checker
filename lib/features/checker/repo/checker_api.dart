import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ticket_checker/features/checker/model/booking_details_model.dart';
import 'package:ticket_checker/services/web_api_service.dart';
import 'package:ticket_checker/utils/urls.dart';

extension CheckerApi on WebAPIService {
  ///
  ///get ticket with ticket number.
  ///
  Future<BookingDetails?> getTicket(String ticketNo, String seatNos) async {
    return dio
        .get(
          "$urlBaseApi/bookings/order-details?order_no=$ticketNo&seat_number=$seatNos",
          // data: jsonEncode(params),
        )
        .then((res) => BookingDetails.fromJson(res.data))
        .catchError((ex) {
      onDioError(ex, 'pending ticket');
    }, test: (ex) => ex is DioError);
  }

  ///
  ///get ticket with ticket number.
  ///
  Future<String?> submitSelected(
      {required String seatNo, required String ticketNo}) async {
    var param = {"order_no": ticketNo, "taken_seat_nos": seatNo};
    return dio
        .put(
          "$urlBaseApi/bookings/confirm",
          data: jsonEncode(param),
        )
        .then((res) => res.data['message'] as String)
        .catchError((ex) {
      onDioError(ex, 'pending ticket');
    }, test: (ex) => ex is DioError);
  }
}
