import 'package:flutter/material.dart';
Widget TextContentSeat(String title, TextTheme textStyles) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: textStyles.headlineSmall,
        ),
      ],
    );
  }
