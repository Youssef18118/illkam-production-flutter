import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ilkkam/models/workTypes/WorkTypeDetails.dart';
import 'package:ilkkam/models/workTypes/WorkTypeTotalResDto.dart';

class IKWorkTypeSelector extends StatelessWidget {
  final String? mainType; // 선택된 시/군/구
  final String? detailType; // 선택된 읍/면/동

  List<WorkTypes> items;

  final Function changeMainType; // 선택된 읍/면/동
  final Function changeDetailType; // 선택된 읍/면/동
  final bool useLabel;

  IKWorkTypeSelector({
    super.key,
    this.useLabel = true,
    required this.mainType,
    required this.detailType,
    required this.changeMainType,
    required this.changeDetailType,
    required this.items,
  });

  final ButtonStyleData buttonStyleData = ButtonStyleData(
    height: 40,
    width: 130,
    padding: const EdgeInsets.only(left: 10,right: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Color(0xFFE1E1E1),
      ),
      // color: Color(0xFF0FFEBE0)
    ),
  );
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (useLabel)
          Container(
            margin: EdgeInsets.only(bottom: 6),
            child: Text(
              "일깜유형",
              style: TextStyle(
                color: Color(0xFF545454),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.12,
              ),
            ),
          ),
        Row(
          children: [
            DropdownButton2<String>(
              underline: SizedBox.shrink(),
              hint: Text(
                '1차 카테고리',
                style: hintStyle,
              ),
              style: valueStyle,
              value: mainType,
              onChanged: (String? newValue) {
                changeMainType(newValue);
              },
              items: items.map<DropdownMenuItem<String>>((WorkTypes value) {
                return DropdownMenuItem<String>(
                  value: value.name,
                  child: Text(value.name ?? ''),
                );
              }).toList(),
              buttonStyleData: buttonStyleData,
              menuItemStyleData: menuItemStyleData,
              dropdownStyleData: dropdownStyleData,
            ),
            const SizedBox(width: 12),
            // 시/군/구 Dropdown
            mainType != null &&
                    items
                        .firstWhere((elem) => elem.name == mainType)
                        .workTypeDetails!
                        .isNotEmpty
                ? DropdownButton2<String>(
                    underline: const SizedBox.shrink(),
                    hint: Text(
                      '2차 카테고리',
                      style: hintStyle,
                    ),
                    style: valueStyle,
                    value: detailType,
                    onChanged: (String? newValue) {
                      changeDetailType(newValue);
                    },
                    items: mainType == null
                        ? []
                        : items
                            .firstWhere((elem) => elem.name == mainType)
                            .workTypeDetails!
                            .map<DropdownMenuItem<String>>(
                                (WorkTypeDetails value) {
                            return DropdownMenuItem<String>(
                              value: value.name,
                              child: Text(value.name ?? ''),
                            );
                          }).toList(),
                    buttonStyleData: buttonStyleData,
                    menuItemStyleData: menuItemStyleData,
                    dropdownStyleData: dropdownStyleData,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
