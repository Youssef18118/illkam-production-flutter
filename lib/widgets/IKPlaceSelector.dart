import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ilkkam/utils/mapLocationInfo.dart';
//
// Map<String, List<String>> locationData = {
//   '서울특별시': {
//     '강남구': ['삼성동', '청담동', '역삼동'],
//     '종로구': ['사직동', '삼청동', '평창동'],
//   },
//   '경기도': {
//     '수원시': ['영통구', '팔달구', '장안구'],
//     '성남시': ['분당구', '수정구', '중원구'],
//   },
//   '부산광역시': {
//     '해운대구': ['우동', '중동', '좌동'],
//     '수영구': ['광안동', '남천동', '수영동'],
//   },
// };

class IKPlaceSelector extends StatelessWidget {
  final String? selectedProvince; // 선택된 시/도
  final String? selectedCity; // 선택된 시/군/구
  // final String? selectedSubCity; // 선택된 읍/면/동

  final Function changeProvince;
  final Function changeCity;
  // final Function changeSubCity;
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

  bool useLabel = false;

  IKPlaceSelector(
      {super.key,
        this.useLabel = true,
      required this.selectedProvince,
      required this.selectedCity,
      // required this.selectedSubCity,
      required this.changeProvince,
      required this.changeCity,
      // required this.changeSubCity
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(useLabel)

        Container(
          margin: EdgeInsets.only(bottom: 6),
          child: Text(
            "지역",
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
                '시/도',
                style: hintStyle,
              ),
              style: valueStyle,
              value: selectedProvince,
              onChanged: (String? newValue) {
                changeProvince(newValue);
              },
              items:
              placeSiMap.keys
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              buttonStyleData: buttonStyleData,
              menuItemStyleData: menuItemStyleData,
              dropdownStyleData: dropdownStyleData,
            ),
            const SizedBox(width: 12),
            // 시/군/구 Dropdown
            DropdownButton2<String>(
              underline: const SizedBox.shrink(),
              hint: Text(
                '시/군/구',
                style: hintStyle,
              ),
              style: valueStyle,
              value: selectedCity,
              onChanged: (String? newValue) {
                changeCity(newValue);
              },
              items: selectedProvince == null
                  ? []
                  : placeSiMap[selectedProvince]!
                      .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              buttonStyleData: buttonStyleData,
              menuItemStyleData: menuItemStyleData,
              dropdownStyleData: dropdownStyleData,
            ),
            const SizedBox(width: 6),
            // DropdownButton2<String>(
            //   underline: const SizedBox.shrink(),
            //   hint: Text(
            //     '읍/면/동',
            //     style: hintStyle,
            //   ),
            //   style: valueStyle,
            //   value: selectedSubCity,
            //   onChanged: (String? newValue) {
            //     changeSubCity(newValue);
            //   },
            //   items: selectedCity == null
            //       ? []
            //       : locationData[selectedProvince]![selectedCity]!
            //           .map<DropdownMenuItem<String>>((String value) {
            //           return DropdownMenuItem<String>(
            //             value: value,
            //             child: Text(value),
            //           );
            //         }).toList(),
            //   buttonStyleData: buttonStyleData,
            //   menuItemStyleData: menuItemStyleData,
            //   dropdownStyleData: dropdownStyleData,
            // ),
          ],
        ),
      ],
    );
  }
}
