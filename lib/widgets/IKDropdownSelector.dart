import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class IKDropdownSelector extends StatelessWidget {
  final String label;
  final String? selectedValue; // 선택된 시/도

  final Function changeValue;

  final List<String> items;

  final DropdownStyleData dropdownStyleData = DropdownStyleData(
    maxHeight: 200,
    // width: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      // color: Colors.redAccent,
    ),
    // offset: const Offset(-20, 0),
    scrollbarTheme: ScrollbarThemeData(
      radius: const Radius.circular(40),
      thickness: MaterialStateProperty.all(6),
      thumbVisibility: MaterialStateProperty.all(true),
    ),
  );
  final MenuItemStyleData menuItemStyleData = MenuItemStyleData(
    height: 40,
  );

  final TextStyle hintStyle = const TextStyle(
    color: Color(0xFFC7C7C7),
    fontSize: 12,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500,
    letterSpacing: -0.12,
  );
  final TextStyle valueStyle = const TextStyle(
    color: Color(0xFF545454),
    fontSize: 12,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    letterSpacing: -0.12,
  );

  IKDropdownSelector(
      {super.key,
      required this.label,
      required this.selectedValue,
      required this.changeValue,
      required this.items});

  @override
  Widget build(BuildContext context) {
    final ButtonStyleData buttonStyleData = ButtonStyleData(
      height: 40,
      width: label == "폐기물 양"? 160 : 110,
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFE1E1E1),
        ),
        // color: Color(0xFF0FFEBE0)
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: TextStyle(
              color: Color(0xFF545454),
              fontSize: 12,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              letterSpacing: -0.12,
            ),
          ),
        ),
        DropdownButton2<String>(
          underline: SizedBox.shrink(),
          hint: Text(
            label,
            style: hintStyle,
          ),
          style: valueStyle,
          value: selectedValue,
          onChanged: (String? newValue) {
            changeValue(newValue);
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          buttonStyleData: buttonStyleData,
          menuItemStyleData: menuItemStyleData,
          dropdownStyleData: dropdownStyleData,
        ),
      ],
    );
  }
}
