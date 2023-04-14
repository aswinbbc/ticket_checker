
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showAppToast({required String msg}) async {
  if (msg.startsWith('Exception:')) {
    msg = msg.replaceFirst('Exception:', '');
  }

  msg = msg.trim();

  if (msg.startsWith('This widget has been')) {
    return true;
  }

  if (msg.startsWith('Null check operator')) {
    return true;
  }

  return await Fluttertoast.showToast(msg: msg);
}