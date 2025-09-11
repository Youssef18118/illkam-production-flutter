import 'package:flutter/material.dart';

class AppColors {
  /// App Background
  /// Off white
  static const background = Color(0xFFFFFFFF);
  static const cardBackground = Colors.white;
  static const activeFillColor = Color(0xFFE0E0E0);
  static const chatroomBackground = Color(0xFFF0F2F6);
  static const black1 = Color(0xFF111111);
  static const black3 = Color(0xFF333333);

  /// Text Theme
  /// For cards, content, and canvas:
  static const textColor = Color(0xFF2F2F2F);
  static const subTitleColor = Color(0xFF444444);
  static const holderColor = Color(0xFF777777);
  static const labelColor = Color(0xFF666666);

  /// For 'Primary' theme
  static const accentBackground = Color(0xFF01A9DB);
  static const rippleColor = Color(0xFF0ABAB5);
  static const disabledBackground = Color(0xFF8F8F8F);
  static const secondaryBackground = Color(0xFFE4E6EC);
  static const dividerColor = Color(0xFFE0E0E0);

  /// For headings
  static const displayTextColor = Colors.black;

  /// for 'Accent' theme
  static const accentTextColor = Colors.black;

  // static const accentTextColor = Colors.blue;

  static const errorColor = Color(0xFFFF3030);

  static const purple = Color(0xFFB59FB5);

  static MaterialColor primary = MaterialColor(0xFF01A9DB, _primarySwatch);
  static MaterialColor text = MaterialColor(0xFF191919, _textSwatch);
  static MaterialColor bg = MaterialColor(0xFFFFFFFF, _bgSwatch);
}

Map<int, Color> _primarySwatch = {
  100: Color(0xFFFFECE1),
  200: Color(0xFFFFDDC9),
  300: Color(0xFFF6B793),
  400: Color(0xFFFF955B),
  500: Color(0xFFFF8C4D),
  600: Color(0xFFFF803A),
  700: Color(0xFF01A9DB),
  900: Color(0xFFF85C06),
};

Map<int, Color> _textSwatch = {
  50: Color(0xFFE1E1E1),
  100: Color(0xFFFAFAFA),
  200: Color(0xFFDCDCDC),
  550: Color(0xFFC7C7C7),
  600: Color(0xFFADADAD),
  700: Color(0xFF7D7D7D),
  800: Color(0xFF545454),
  850: Color(0xFF494949),
  900: Color(0xFF191919),
};

Map<int, Color> _bgSwatch = {
  50: Color(0xFFF4F4F4),
  80: Color(0xFFFAFAFA),
  400: Color(0xFFFFFFFF),
};

class IKTextStyle {
  static TextStyle white_8 = const TextStyle(
    color: Colors.white,
    fontSize: 8,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w700,
  );
  static TextStyle appBarTitle = const TextStyle(
    color: Colors.white,
    fontSize: 19,
    fontFamily: 'SEBANG',
    fontWeight: FontWeight.w700,
    height: 1.47,
  );
  static TextStyle landing_name = const TextStyle(
  color: Color(0xFF121212),
  fontSize: 19,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w700,
  letterSpacing: -0.19,
  );

  static TextStyle appMainText = const TextStyle(
    color: Color(0xFF01A9DB),
    fontSize: 32,
    fontFamily: 'Cafe24',
    fontWeight: FontWeight.w700,
  );

  static TextStyle selectorBtnText = const TextStyle(
    color: Color(0xFFFAFAFA),
    fontSize: 15,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
  );



  static TextStyle selectorText = const TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    height: 1.5
  );

  static TextStyle categoryTitle = const TextStyle(
    color: Color(0xFF121212),
    fontSize: 12,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    height: 1.83,
    letterSpacing: -0.60,
  );
}
