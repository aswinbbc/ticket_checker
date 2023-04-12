
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ticket_checker/components/list_scroll_more_widget.dart';

import '../providers/_base.dart';
import '../providers/_mixins.dart';
import 'exceptions.dart';

/// The String extension class for the app
///
///
extension StringExtension on String {
  /// Append the svg location to the string
  String asAssetSvg() => 'assets/svgs/$this.svg';

  /// Append the image location to the string
  String asAssetImg() => 'assets/images/$this';

  String replaceForEllipses() {
    // for (var word in this.split(' ')) {
    //   if (!checkArabic(word)) {
    //     this.replaceAll(word, word.replaceAll("", "\u{200B}"));
    //   }
    // }
    if (!checkArabic(this)) {
      return replaceAll('', "\u{200B}");
    }
    return this;
  }

  double? toDouble() {
    try {
      if (isEmpty) {
        return null;
      }
      return double.parse(this);
    } catch (ex) {
      debugPrint(ex.toString());
      return null;
    }
  }

  bool isImageExtenstion(
      {List<String> imgExt = const <String>['png', 'jpg', 'jpeg', 'gif']}) {
    if (!contains('.')) return false;

    final ext = substring(lastIndexOf('.') + 1).toString();
    return imgExt.contains(ext);
  }
}

bool checkArabic(String text) {
  final regexExp = RegExp("[\u0621-\u064A]+");
  return regexExp.hasMatch(text);
}

/// The extension for the [Future]
extension FutureExtension<T> on Future<T> {
  /// Handle the loading states
  ///
  Future<T> coverWithProgress<I extends MixinProgressProvider>(I provider) =>
      Future(() {
        provider.isLoading = true;
      }).then<T>((_) => this).whenComplete(() => provider.isLoading = false);

  /// Handles the error
  Future<T> handleAPIException({
    required HandleAPIException handleAPIException,
    required OnShowError onShowError,
    VoidCallback? onInvalidToken,
  }) {
    return catchError((ex) {
      handleAPIException(
          ex: ex, onShowError: onShowError, onInvalidToken: onInvalidToken);
    }, test: (ex) => ex is APIException).catchError((ex) {
      onShowError(ex.toString());
    }, test: (ex) => ex is! AppLoginException).catchError((ex) {
      if (ex is AssertionError) {
        onShowError(ex.message?.toString() ?? ex.toString());
      }
    }, test: (ex) => ex is AssertionError);
  }

  /// Handles the error
  Future<T> handleAssertionException({required OnShowError onShowError}) {
    return catchError((ex) {
      if (ex is AssertionError) {
        onShowError(ex.message?.toString() ?? ex.toString());
      }
    }, test: (ex) => ex is AssertionError).catchError((ex) {
      throw (ex);
    });
  }

  /// Displays the loading infront of all
  ///
  ///
  Future<T> showOverlayProgress(
      {required BuildContext context, double bgOpacity = 0.30}) {
    OverlayEntry? progressOverlay;
    if (progressOverlay == null) {
      progressOverlay = OverlayEntry(
        builder: (context) => AbsorbPointer(
          absorbing: true,
          child: Container(
            color: Colors.black.withOpacity(bgOpacity),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
        ),
      );
      Overlay.of(context).insert(progressOverlay);
    }
    return whenComplete(() {
      if (progressOverlay != null) {
        progressOverlay!.remove();
        progressOverlay = null;
      }
    });
  }
}

extension WidgetExtension on Widget {
  /// For the app the common padding is `28` in horizontal
  ///
  /// This extension will add an horizontal padding to the elements
  Widget withScreenPadding({double padding = 16}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: padding.sp),
        child: this,
      );

  Widget withScreenshotImg({required String imgUrl, double opacity = 0.5}) =>
      Stack(
        children: [
          Positioned.fill(child: this),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Opacity(
                opacity: opacity,
                child: Image.network(
                  imgUrl,
                  colorBlendMode: BlendMode.colorBurn,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      );

  // Widget withUnderline({Color? color}) {
  //   color = color ?? colorblue;
  //   return Stack(
  //     children: [
  //       Positioned(
  //         left: 0,
  //         right: 0,
  //         bottom: 1.0,
  //         child: Container(
  //           decoration: BoxDecoration(
  //             border: Border(
  //               bottom: BorderSide(
  //                 color: color,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       this,
  //     ],
  //   );
  // }

  /// Shows the progress widget on the center of the [Widget]
  Widget showProgressOnCenter<P extends MixinProgressProvider?>({
    double bgOpacity = 0.15,
    BorderRadiusGeometry? borderRadius,
  }) =>
      Consumer<P>(
        builder: (context, provider, _) => Stack(
          children: [
            AbsorbPointer(absorbing: provider?.isLoading ?? false, child: this),
            if (provider?.isLoading ?? false)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).dividerColor.withOpacity(bgOpacity),
                    borderRadius: borderRadius,
                  ),
                  child: const CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      );

  Widget showProgressOnCenter2<P extends MixinProgressProvider?,
          P2 extends MixinProgressProvider?>({
    double bgOpacity = 0.15,
    BorderRadiusGeometry? borderRadius,
  }) =>
      Consumer2<P, P2>(
        builder: (context, p, p2, _) {
          bool? isloading = (p?.isLoading ?? false) || (p2?.isLoading ?? false);
          return Stack(
            children: [
              AbsorbPointer(absorbing: isloading, child: this),
              if (isloading)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).dividerColor.withOpacity(bgOpacity),
                      borderRadius: borderRadius,
                    ),
                    child: const CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      );

  Widget showProgressOnCenter3<
          P extends MixinProgressProvider?,
          P2 extends MixinProgressProvider?,
          P3 extends MixinProgressProvider?>({double bgOpacity = 0.45}) =>
      Consumer3<P, P2, P3>(
        builder: (context, p, p2, p3, _) => Stack(
          children: [
            AbsorbPointer(
                absorbing: (p?.isLoading ?? false) ||
                    (p2?.isLoading ?? false) ||
                    (p3?.isLoading ?? false),
                child: this),
            if ((p?.isLoading ?? false) ||
                (p2?.isLoading ?? false) ||
                (p3?.isLoading ?? false))
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).dividerColor.withOpacity(bgOpacity),
                  child: const CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      );

  Widget showProgressOnCenter4<
          P extends MixinProgressProvider?,
          P2 extends MixinProgressProvider?,
          P3 extends MixinProgressProvider?,
          P4 extends MixinProgressProvider?>({double bgOpacity = 0.45}) =>
      Consumer4<P, P2, P3, P4>(
        builder: (context, p, p2, p3, p4, _) => Stack(
          children: [
            AbsorbPointer(
                absorbing: ((p?.isLoading ?? false) ||
                    (p2?.isLoading ?? false) ||
                    (p3?.isLoading ?? false) ||
                    (p4?.isLoading ?? false)),
                child: this),
            if ((p?.isLoading ?? false) ||
                (p2?.isLoading ?? false) ||
                (p3?.isLoading ?? false) ||
                (p4?.isLoading ?? false))
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).dividerColor.withOpacity(bgOpacity),
                  child: const CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      );

  Widget showCircleProgressOnCenter<P extends MixinProgressProvider?>(
          {double bgOpacity = 0.30}) =>
      Consumer<P>(
        builder: (context, provider, _) => Stack(
          children: [
            AbsorbPointer(
                absorbing: (provider?.isLoading ?? false), child: this),
            if (provider?.isLoading ?? false)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).dividerColor.withOpacity(bgOpacity),
                  child: const CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      );

  Widget showGreyProgressOnCenter<P extends MixinProgressProvider?>(
          {double bgOpacity = 0.30}) =>
      Consumer<P>(
        builder: (context, provider, _) => Stack(
          children: [
            AbsorbPointer(
                absorbing: (provider?.isLoading ?? false), child: this),
            if (provider?.isLoading ?? false)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).dividerColor.withOpacity(bgOpacity),
                  child: const CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      );

  Widget showProgressOnCenter5<
              P extends MixinProgressProvider?,
              P2 extends MixinProgressProvider?,
              P3 extends MixinProgressProvider?,
              P4 extends MixinProgressProvider?,
              P5 extends MixinProgressProvider?>(
          {double bgOpacity = 0.45, bool isProgress2 = false}) =>
      Consumer5<P, P2, P3, P4, P5>(
        builder: (context, p, p2, p3, p4, p5, _) {
          bool isLoading = ((p?.isLoading ?? false) ||
              (p2?.isLoading ?? false) ||
              (p3?.isLoading ?? false) ||
              (p4?.isLoading ?? false) ||
              (p5?.isLoading ?? false));
          return Stack(
            children: [
              IgnorePointer(ignoring: isLoading, child: this),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color:
                        Theme.of(context).dividerColor.withOpacity(bgOpacity),
                    child: isProgress2
                        ? const CircularProgressIndicator()
                        : const CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      );

  Widget showProgressOnCenter6<
          P extends MixinProgressProvider?,
          P2 extends MixinProgressProvider?,
          P3 extends MixinProgressProvider?,
          P4 extends MixinProgressProvider?,
          P5 extends MixinProgressProvider?,
          P6 extends MixinProgressProvider?>({double bgOpacity = 0.45}) =>
      Consumer6<P, P2, P3, P4, P5, P6>(
        builder: (context, p, p2, p3, p4, p5, p6, _) {
          bool isLoading = ((p?.isLoading ?? false) ||
              (p2?.isLoading ?? false) ||
              (p3?.isLoading ?? false) ||
              (p4?.isLoading ?? false) ||
              (p5?.isLoading ?? false) ||
              (p6?.isLoading ?? false));
          return Stack(
            children: [
              AbsorbPointer(absorbing: isLoading, child: this),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color:
                        Theme.of(context).dividerColor.withOpacity(bgOpacity),
                    child: const CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      );

  Widget showProgressOnCenter1<P extends MixinProgressProvider?>(
          {Color bgColor = Colors.transparent}) =>
      Consumer<P>(
        builder: (context, provider, _) => Stack(
          children: [
            AbsorbPointer(
                absorbing: (provider?.isLoading ?? false), child: this),
            if (provider?.isLoading ?? false)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: bgColor,
                  child: const CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      );

  Widget orShowEmptyWidget({
    @required List? items,
    bool isLoading = false,
    String text = "No records found",
    double bottomPadding = 0.0,
    double iconTopPadding = 0.0,
  }) {
    if (isLoading) return this;
    if (items?.isEmpty ?? true) {
      return Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Padding(
            //   padding: EdgeInsets.only(top: iconTopPadding),
            //   child: const Text("Empty"),
            // ),
            SvgPicture.asset(
              'empty_state'.asAssetSvg(),
              height: 135.sm,
              width: 135.sm,
            ),
            Text(
              text,
              style: TextStyle(
                color: const Color(0xFFA3A3A3),
                fontSize: 19.sm,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 16,
            //     bottom: bottomPadding,
            //   ),
            //   child: Text(
            //     text,
            //     style: const TextStyle(
            //       color: Color(0xFFA3A3A3),
            //       fontSize: 21,
            //       fontWeight: FontWeight.w400,
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ],
        )),
      );
    }
    return this;
  }

  Widget orShowEmptyWidget1({
    @required List? items,
    bool isLoading = false,
    String text = "No records found",
    double bottomPadding = 0.0,
    double iconTopPadding = 0.0,
  }) {
    if (isLoading) return this;
    if (items?.isEmpty ?? true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset(
            'empty_state'.asAssetSvg(),
            height: 100.sm,
            width: 100.sm,
          ),
          Text(
            text,
            style: TextStyle(
              color: const Color(0xFFA3A3A3),
              fontSize: 15.sm,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
    return this;
  }
}

extension BuildContextExtension on BuildContext {
  T? getScreenParamsOf<T>() {
    try {
      return ModalRoute.of(this)!.settings.arguments as T;
    } catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }
}

extension DateTimeExtension on DateTime {
  DateTime roundToCeil() {
    DateTime returnTime = this;
    if (returnTime.minute % 5 != 0) {
      final roundedMinutes = 5 * (returnTime.minute / 5).ceil();
      final diff = roundedMinutes - returnTime.minute;
      if (diff != 0) {
        returnTime = returnTime.add(Duration(minutes: diff));
      }
    }
    return returnTime;
  }

  String? toFormatted({String format = "dd/MM/yyy"}) {
    try {
      return DateFormat(format).format(this);
    } catch (ex) {
      debugPrint(ex.toString());
      return null;
    }
  }

  String? toFormattedCurrent({String format = "dd/MM/yyy"}) {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final aDate = DateTime(year, month, day);
      if (aDate == today) {
        return "Today ${DateFormat.jm().format(this)}";
      }
      return "${DateFormat("dd-MM-yyyy").format(this)} ${DateFormat.jm().format(this)}";
    } catch (ex) {
      debugPrint(ex.toString());
      return null;
    }
  }
}

extension DynamicExtension on dynamic {
  double? toDouble() {
    try {
      if (this?.toString().isEmpty ?? true) {
        return null;
      }
      return double.parse(this?.toString() ?? "");
    } catch (ex) {
      debugPrint(ex.toString());
      return null;
    }
  }
}

extension DoubleExtension on double? {
  double? toFormattedDecimal(int decimals) {
    if (this == null) return null;

    int maxDigits = 10;

    if (decimals > maxDigits) {
      maxDigits = decimals + 1;
    }
    String valStr = this!.toStringAsFixed(maxDigits);
    final splits = valStr.split('.');
    valStr = "${splits[0]}.${splits[1].substring(0, decimals)}";
    return double.parse(valStr);
  }

  String? toEstimatedDiffAmount() {
    if (this == null) return null;
    return "${(this?.toDouble().toStringAsFixed(2) ?? 0)} - ${((this?.toDouble() ?? 0) + 30).toStringAsFixed(2)}";
  }
}

extension ListViewExtension on ListView {
  Widget withLoadMore({
    required void Function(BuildContext context) onLoadMore,
    required bool Function(BuildContext context) canLoadMore,
  }) =>
      ListScrollMoreWidget(
        onLoadMore: onLoadMore,
        canLoadMore: canLoadMore,
        child: this,
      );
}

extension GridViewExtension on GridView {
  Widget withLoadMore({
    required void Function(BuildContext context) onLoadMore,
    required bool Function(BuildContext context) canLoadMore,
  }) =>
      GridScrollMoreWidget(
        onLoadMore: onLoadMore,
        canLoadMore: canLoadMore,
        child: this,
      );
}

extension NavigatorStateExtension on NavigatorState {
  void pushNamedIfNotCurrent(String routeName, {Object? arguments}) {
    if (!isCurrentRoute(routeName)) {
      pushNamed(routeName, arguments: arguments);
    } else {
      pop();
      pushNamed(routeName, arguments: arguments);
    }
  }

  bool isCurrentRoute(String routeName) {
    bool isCurrent = false;
    popUntil((route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    });
    return isCurrent;
  }
}
