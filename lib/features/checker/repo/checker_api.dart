import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ticket_checker/features/checker/model/booking_details_model.dart';
import 'package:ticket_checker/services/web_api_service.dart';
import 'package:ticket_checker/utils/urls.dart';

extension HomeApi on WebAPIService {
  ///
  ///get all pending ticket count
  ///
  Future<BookingDetails?> getTicket(String ticketNo) async {
    return dio
        .get(
          "$urlBaseApi/bookings/order-details?order_no=$ticketNo",
          // data: jsonEncode(params),
        )
        .then((res) => BookingDetails.fromJson(res.data))
        .catchError((ex) {
      onDioError(ex, 'pending ticket');
    }, test: (ex) => ex is DioError);
  }
}
