import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // 숫자만 필터링
    String digitsOnly = text.replaceAll(RegExp(r'\D'), '');

    // 전화번호 형식: 010-1234-5678 (예시)
    StringBuffer formatted = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 3 || i == 7) {
        formatted.write('-');
      }
      formatted.write(digitsOnly[i]);
    }

    return TextEditingValue(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class BusinessNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // 숫자만 필터링
    String digitsOnly = text.replaceAll(RegExp(r'\D'), '');

    // 사업자등록번호 형식: XXX-XX-XXXXX
    StringBuffer formatted = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 3 || i == 5) {
        formatted.write('-');
      }
      formatted.write(digitsOnly[i]);
    }

    return TextEditingValue(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class NameFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // 한글 및 영어만 허용
    String filtered = newValue.text.replaceAll(RegExp(r'[^a-zA-Z가-힣\s]'), '');

    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}

class EmailFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // 영어, 숫자, 기본 이메일 특수문자만 허용
    String filtered = newValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9@._-]'), '');

    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}


class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // 숫자만 추출하고 콤마를 추가합니다.
    final num value = int.parse(newValue.text.replaceAll(',', ''));
    final formattedValue = NumberFormat('#,###').format(value);

    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
