import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:intl/intl.dart';

class IkDatePicker extends StatelessWidget {
  final String label;
  final Function onTap;
  final DateTime? dateTime;
  final DateTime? timeOfDay;
  final String format;
  final bool? noMatter;
  final void Function(bool?)? noMatterChange;
  final bool required;

  const IkDatePicker(
      {super.key,
      required this.label,
      required this.onTap,
      this.dateTime,
      this.timeOfDay,
      required this.format,
      this.noMatter,
      this.noMatterChange,
      this.required = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Color(0xFF545454),
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.12,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(필수)',
                  style: TextStyle(
                    color: Color(0xFF545454),
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.12,
                  ),
                ),
                if (required)
                  const SizedBox(width: 4),
                if (required)
                  Text(
                    '*',
                    style: TextStyle(
                      color: Color(0xFFFF0000),
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.12,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: noMatter != null && noMatter!
                  ? Color(0xFFFAFAFA)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0xFFE1E1E1)),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                          "assets/main/${label == "시간" ? "time" : "calendar"}.svg"),
                      const SizedBox(width: 8),
                      Text(
                        noMatter != null && noMatter!
                            ? "시간무관"
                            : dateTime != null
                                ? DateFormat(format).format(dateTime!)
                                :DateFormat(format,'ko').format(timeOfDay!),
                        // "${timeOfDay!.hour}:${timeOfDay!.minute}",
                        style: TextStyle(
                          color: noMatter != null && noMatter!
                              ? Color(0xFFADADAD)
                              : AppColors.textColor,
                          fontSize: 15,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (noMatter != null)
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      print(noMatter);
                      noMatterChange!(!noMatter!);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: noMatter,
                            onChanged: noMatterChange,
                            checkColor: Colors.white,
                            activeColor: Color(0xFF191919),
                            side: BorderSide(color: Color(0xFFE1E1E1)),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                          Text(
                            '시간무관',
                            style: TextStyle(
                              color: Color(0xFF191919),
                              fontSize: 12,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 0.11,
                              letterSpacing: -0.12,
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            )
        ],
      ),
    );
  }
}
