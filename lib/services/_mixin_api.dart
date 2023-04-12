import 'package:dio/dio.dart';
import '../utils/exceptions.dart';
import '_base.dart';

mixin WebAPIMixin on BaseService {
  /// Returns the token from Shared Preference
  /// Token is saved as key pair of [keyToken]
  /// Throws exception in case of any error
  // Future<String?> getTokenFromSharedPref() => SharedPreferences.getInstance()
  //     .then<String?>((sp) => sp.getString(spKeys.keyToken));

  /// Handle the dio error in call
  void onDioError(DioError error, String apiName) {
    String? msg;
    switch (error.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
      case DioErrorType.other:
        // msg = LanguageProvider().isEnglish
        //     ? "Couldn't connect. Please try again"
        //     : "تعذر الإتصال. حاول مرة أخرى";
        throw APIException(
            enumProperty: EnumAPIExceptions.httpStatusError,
            message:
                "Unable to connect to server. Please check your network connection");
      case DioErrorType.response:

        /// Check the api response has data
        if (error.response?.data == null) {
          throw APIException(
              enumProperty: EnumAPIExceptions.httpStatusError,
              message: msg ?? "$apiName:${error.message}",
              otherData: [error.error]);
        }

        if (error.response!.data is Map) {
          final Map data = error.response!.data;
          if (data.containsKey('message')) {
            if (data['message'] == 'Unauthenticated') {
              throw APIException(
                  enumProperty: EnumAPIExceptions.invalidToken,
                  message: 'Token expired');
            }

            throw APIException(
              enumProperty: EnumAPIExceptions.dataSuccessFalse,
              message: data['message'],
              data: error.response?.data,
            );
          }

          if (data.containsKey('message')) {
            if ([
              "invalid session",
              "invalid session.",
              "not a valid session",
              "not a valid session.",
              "invalid login details",
            ].contains(data["message"]?.toString().toLowerCase())) {
              throw APIException(
                enumProperty: EnumAPIExceptions.invalidToken,
                message: data['message'],
                data: error.response?.data,
              );
            }
          }

          if (data.containsKey('message')) {
            if (data['message'] == 'Unauthenticated') {
              throw APIException(
                enumProperty: EnumAPIExceptions.invalidToken,
                message: 'Token expired',
                data: error.response?.data,
              );
            }

            throw APIException(
              enumProperty: EnumAPIExceptions.dataSuccessFalse,
              message: data['message'],
              data: error.response?.data,
            );
          }
        }

        break;
      case DioErrorType.cancel:
        msg = "The request has been cancelled.";
        break;
    }
    throw APIException(
        enumProperty: EnumAPIExceptions.httpStatusError,
        message: msg ?? "$apiName:${error.message}",
        otherData: [error.response?.data]);
  }
}

// /// The mixin class to save the login responses to shared prefrences
// mixin MixinSaveLoginInfo on BaseProvider, MixinProgressProvider {
//   @protected
//   Future<bool> saveLoginInfo(LoginModel model) async {
//     try {
//       showLoading();
//       final sp = await SPHelper.getSp();
//       return sp.setString(SpKeys.loginResponse, model.toString());
//     } catch (ex) {
//       debugPrint(ex.toString());
//       rethrow;
//     } finally {
//       hideLoading();
//     }
//   }

//   Future<LoginModel?> getLoginInfo() async {
//     try {
//       // showLoading();
//       final sp = await SPHelper.getSp();
//       final data = sp.getString(SpKeys.loginResponse);

//       if (data == null) return null;

//       return LoginModel.fromString(data);
//     } catch (ex) {
//       debugPrint(ex.toString());
//       rethrow;
//     } finally {
//       // hideLoading();
//     }
//   }

//   @protected
//   Future<bool> setIsLoggedIn(bool val) async {
//     try {
//       showLoading();
//       final sp = await SPHelper.getSp();
//       return sp.setBool(SpKeys.isLoggedIn, val);
//     } catch (ex) {
//       debugPrint(ex.toString());
//       rethrow;
//     } finally {
//       hideLoading();
//     }
//   }

//   Future<bool?> getIsLoggedIn() async {
//     try {
//       showLoading();
//       final sp = await SPHelper.getSp();
//       final data = sp.getBool(SpKeys.isLoggedIn);
//       return data;
//     } catch (ex) {
//       debugPrint(ex.toString());
//       rethrow;
//     } finally {
//       hideLoading();
//     }
//   }
// }
