import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../utils/exceptions.dart';

abstract class BaseService {
  /// Validate the response from API
  ///
  /// The method will filter the result type and `_status` field from the
  /// response
  Future<Response?> validatePOST(Response resData) async {
    try {
      if (resData.data is! Map) {
        throw APIException(
          enumProperty: EnumAPIExceptions.invalidResultType,
          message: "Invalid result type from server. Please try again.",
        );
      }
      final data = resData.data['result'];

      if (data.containsKey('status') && data['status'].toString() != "200") {
        if (data.containsKey('message')) {
          throw APIException(
              enumProperty: EnumAPIExceptions.dataSuccessFalse,
              message: data["message"].toString(),
              data: data);
        } else {
          throw APIException(
            enumProperty: EnumAPIExceptions.dataSuccessFalse,
            message: "Something went wrong",
            data: data,
          );
        }
      }
    } on APIException catch (_) {
      rethrow;
    } catch (ex) {
      debugPrint(ex.toString());
    }
    return resData;
  }

  /// Validate the response from API
  ///
  /// The method will filter the result type and `_status` field from the
  /// response
  Future<Response?> validateGET(Response resData) async {
    try {
      if (resData.data is! Map) {
        throw APIException(
          enumProperty: EnumAPIExceptions.invalidResultType,
          message: "Invalid result type from server. Please try again.",
        );
      }
      final data = resData.data;

      if ((resData.statusCode != 200 && resData.statusCode != 202)) {
        if (data.containsKey('message')) {
          throw APIException(
              enumProperty: EnumAPIExceptions.dataSuccessFalse,
              message: data["message"].toString(),
              data: data);
        } else {
          throw APIException(
            enumProperty: EnumAPIExceptions.dataSuccessFalse,
            message: "Something went wrong",
            data: data,
          );
        }
      }
    } on APIException catch (_) {
      rethrow;
    } catch (ex) {
      debugPrint(ex.toString());
    }
    return resData;
  }
}
