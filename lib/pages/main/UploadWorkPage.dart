import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ilkkam/models/workTypes/WorkTypeTotalResDto.dart';
import 'package:ilkkam/pages/main/widgets/WorkUploadDialog.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/WorkRepository.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:ilkkam/utils/imagePicker.dart';
import 'package:ilkkam/widgets/IKCommonBtn.dart';
import 'package:ilkkam/widgets/IKDatePicker.dart';
import 'package:ilkkam/widgets/IKDropdownSelector.dart';
import 'package:ilkkam/widgets/IKPlaceSelector.dart';
import 'package:ilkkam/widgets/IKTextField.dart';
import 'package:ilkkam/widgets/IKWorkTypeSelector.dart';
import 'package:ilkkam/widgets/ImagePickerWidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/formatters.dart';

class UploadWorkPageArguments {
  bool edit;
  Work work;

  UploadWorkPageArguments({required this.edit, required this.work});
}

class UploadWorkPage extends StatefulWidget {
  const UploadWorkPage({super.key});

  static const routeName = "/upload-work-page";

  @override
  State<UploadWorkPage> createState() => _UploadWorkPageState();
}

class _UploadWorkPageState extends State<UploadWorkPage> {
  WorkRepository workRepository = WorkRepository();

  // 일깜 등록 관련
  final TextEditingController _priceC = TextEditingController();
  final TextEditingController _commentC = TextEditingController();

  bool noMatterTime = false;

  changeNoMatterTime(bool? val) {
    setState(() {
      if (val == null) {
        return;
      }
      noMatterTime = val;
    });
  }

  String? selectedProvince; // 선택된 시/도
  String? selectedCity; // 선택된 시/군/구
  // String? selectedSubCity; // 선택된 읍/면/동

  String? selectedWorkType;
  String? selectedWorkDetailType;

  DateTime dateTime = DateTime.now();
  DateTime time =
      DateTime.now().subtract(Duration(minutes: DateTime.now().minute % 10));

  // TimeOfDay time = TimeOfDay.now();
  List<WorkTypes> workTypes = [];
  List<WorkInfoDetail> workInfoDetails = [];

  // 이미지 리스트
  List<String> imageURLs = [];
  bool isImageUploading = false;

  bool isUploading = false;

  final _formKey = GlobalKey<FormState>();

  Future<DateTime?> onCalendarWidgetTap(BuildContext context) async {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final nowDate = DateTime.now();

    return showCupertinoCalendarPicker(
      context,
      widgetRenderBox: renderBox,
      minimumDateTime: nowDate.subtract(const Duration(days: 15)),
      initialDateTime: nowDate,
      maximumDateTime: nowDate.add(const Duration(days: 360)),
      mode: CupertinoCalendarMode.dateTime,
      timeLabel: 'Ends',
      onDateTimeChanged: (dateTime) async {
        final DateTime? current = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(3000));
        if (current != null) {
          setState(() {
            dateTime = current;
          });
        }
      },
    );
  }

  @override
  void initState() {
    workRepository.getAllWorkType().then((v) {
      if (mounted) {
        setState(() {
          workTypes = v;
        });
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final work = Provider.of<WorkController>(context);
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Form(
            key: _formKey, // Form에 key 추가
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IkDatePicker(
                  required: true,
                  format: 'yyyy년 MM월 dd일',
                  label: "날짜",
                  onTap: () async {
                    _showDialog(CupertinoDatePicker(
                      initialDateTime: time,
                      mode: CupertinoDatePickerMode.date,
                      use24hFormat: false,
                      minimumDate:
                          DateTime(now.year, now.month, now.day, 0, 0, 0, 0),
                      maximumDate: dateTime.add(Duration(days: 90)),
                      // This is called when the user changes the time.
                      onDateTimeChanged: (DateTime newTime) async {
                        setState(() {
                          dateTime = newTime;
                        });
                      },
                    ));
                    // onCalendarWidgetTap(context);
                  },
                  dateTime: dateTime,
                ),
                SizedBox(
                  height: 20,
                ),
                IkDatePicker(
                  required: true,
                  label: "시간",
                  noMatter: noMatterTime,
                  noMatterChange: changeNoMatterTime,
                  format: 'a hh:mm',
                  timeOfDay: time,
                  onTap: () async {
                    if (noMatterTime) {
                      return;
                    }
                    _showDialog(CupertinoDatePicker(
                      initialDateTime: time,
                      minuteInterval: 10,
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: false,
                      // This is called when the user changes the time.
                      onDateTimeChanged: (DateTime newTime) {
                        setState(() => time = newTime);
                      },
                    ));
                  },
                  // timeOfDay: time,
                ),
                SizedBox(
                  height: 20,
                ),
                IKPlaceSelector(
                  required: true,
                  selectedProvince: selectedProvince,
                  selectedCity: selectedCity,
                  // selectedSubCity: selectedSubCity,
                  changeProvince: changeProvince,
                  changeCity: changeCity,
                  // changeSubCity: changeSubCity
                ),
                SizedBox(
                  height: 20,
                ),
                IKWorkTypeSelector(
                  required: true,
                  items: workTypes,
                  mainType: selectedWorkType,
                  detailType: selectedWorkDetailType,
                  changeDetailType: changeWorkDetailType,
                  changeMainType: changeWorkMainType,
                ),
                SizedBox(
                  height: 20,
                ),
                ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (ctx, idx) {
                      WorkInfoDetail workInfo = workInfoDetails[idx];
                      if (workInfo.inputType == "select" &&
                          workInfo.options != null) {
                        if (selectedWorkType == '가전 청소' &&
                            workInfo.name == "종류") {
                          //   가전 청소일 때 세탁기 냉장고 분리
                          if (selectedWorkDetailType == "냉장고 청소" ||
                              selectedWorkDetailType == "세탁기 청소") {
                            return IKDropdownSelector(
                                required: true,
                                label: workInfo.name ?? '',
                                selectedValue: workInfo.value,
                                changeValue: (String newVal) {
                                  setState(() {
                                    workInfo.value = newVal;
                                  });
                                },
                                items: workInfo.options
                                        ?.where((eleme) => eleme.contains(
                                            selectedWorkDetailType!
                                                .replaceFirst(" 청소", "")))
                                        .toList() ??
                                    []);
                          } else {
                            return SizedBox.shrink();
                          }
                        } else {
                          //   나머지는 그냥 그대로
                          return IKDropdownSelector(
                              required: true,
                              label: workInfo.name ?? '',
                              selectedValue: workInfo.value,
                              changeValue: (String newVal) {
                                setState(() {
                                  workInfo.value = newVal;
                                });
                              },
                              items: workInfo.options ?? []);
                        }
                      } else {
                        return IkTextField(
                          required: true,
                          keyboardType: workInfo.inputType == 'integer'
                              ? TextInputType.number
                              : TextInputType.text,
                          placeholder: workInfo.placeholder ??
                              "${workInfo.name}을(를) 입력해주세요.",
                          formatters: workInfo.inputType == 'integer'
                              ? [FilteringTextInputFormatter.digitsOnly]
                              : [],
                          label: workInfo.name,
                          maxline: workInfo.name == "시공상세" ? 3 : null,
                          length: workInfo.name == "시공상세" ? null : 20,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "정보를 입력해주세요.";
                            }
                            return null;
                          },
                          onChange: (String? val) {
                            if (val != null) {
                              workInfo.value = val;
                            }
                          },
                        );
                      }
                    },
                    separatorBuilder: (ctx, idx) => SizedBox(
                          height: 20,
                        ),
                    itemCount: workInfoDetails.length),
                if (selectedWorkType != "견적방문 요청")
                  SizedBox(
                    height: 20,
                  ),
                if (selectedWorkType != "견적방문 요청")
                  IkTextField(
                    controller: _priceC,
                    placeholder: "100,000",
                    formatters: [ThousandsFormatter()],
                    label: "금액(필수)",
                    required: true,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "금액을 입력해주세요.";
                      }
                      return null;
                    },
                    action: Text(
                      "원",
                      style: TextStyle(
                        color: Color(0xFF545454),
                        fontSize: 15,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                IkTextField(
                  controller: _commentC,
                  placeholder: "시공 요구사항을 자세히 알려주세요 \n\n ※ 동의 없는 개인정보 입력 시 법적 책임이 따를 수 있습니다.",
                  maxline: 5,
                  label: "고객 및 업체 요구사항(선택)",
                ),
                SizedBox(
                  height: 20,
                ),
                ImagePickerWidget(
                    label: "사진 등록",
                    length: 3,
                    count: imageURLs.length,
                    onDelete: (int index) {
                      setState(() {
                        imageURLs.removeAt(index);
                      });
                    },
                    onTap: () async {
                      if (imageURLs.length == 3) {
                        return;
                      }
                      setState(() {
                        isImageUploading = true;
                      });
                      String? imgURL = await pickImage(PickUsageType.ILLKAM);
                      if (imgURL != null) {
                        setState(() {
                          imageURLs.add(imgURL);
                        });
                      }
                      setState(() {
                        isImageUploading = false;
                      });
                    },
                    isImageUploading: isImageUploading,
                    img: imageURLs),
                SizedBox(
                  height: 40,
                ),
                IKCommonBtn(
                    title: "등록하기",
                    onTap: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (selectedProvince == null ||
                            selectedProvince == "시·도 선택") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("지역(시·도)을 선택해주세요.")));
                          return;
                        }
                        if (selectedCity == null || selectedCity == "시·군·구 선택") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("지역(시·군·구)을 선택해주세요.")));
                          return;
                        }
                        if (selectedWorkType == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("일깜유형을 선택해주세요.")));
                          return;
                        }

                        final selectedWorkTypeData = workTypes.firstWhere(
                            (e) => e.name == selectedWorkType,
                            orElse: () => WorkTypes());
                        if ((selectedWorkTypeData.workTypeDetails?.length ?? 0) >
                                0 &&
                            selectedWorkDetailType == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("일깜유형(2차)을 선택해주세요.")));
                          return;
                        }

                        final emptyWorkInfo = workInfoDetails.firstWhere(
                            (elem) {
                          if (elem.name == "종류" &&
                              selectedWorkDetailType == "건조기 청소") {
                            return false;
                          }
                          return elem.value == null || elem.value!.isEmpty;
                        }, orElse: () => WorkInfoDetail());

                        if (emptyWorkInfo.name != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("${emptyWorkInfo.name}을(를) 입력해주세요.")));
                          return;
                        }

                        if (isUploading) {
                          return;
                        }
                        try {
                          isUploading = true;

                          await workRepository.saveWork(
                              workDate:
                                  DateFormat("yyyy-MM-dd").format(dateTime),
                              workHour: noMatterTime
                                  ? null
                                  : DateFormat("a hh:mm", "ko").format(time),
                              workLocationSi: selectedProvince ?? '',
                              workLocationGu: selectedCity ?? '',
                              workType: selectedWorkType ?? '',
                              workTypeDetail: selectedWorkDetailType ?? '',
                              workInfoDetail: workInfoDetails,
                              price: _priceC.text.isEmpty ? "0" : _priceC.text,
                              workImages: imageURLs,
                              comment: _commentC.text);
                          work.reload();
                          work.reloadWorkListPage();
                          isUploading = false;
                          showWorkUploadFinishedDialog(context);
                        } catch (error) {
                          isUploading = false;
                        }
                      }
                    })
              ],
            )),
      ),
    );
  }

  changeWorkMainType(String newValue) {
    setState(() {
      selectedWorkType = newValue;
      selectedWorkDetailType = null;
      workInfoDetails =
          workTypes.firstWhere((elem) => elem.name == newValue).workInfoDetail!;
    });
  }

  changeWorkDetailType(String newValue) {
    setState(() {
      selectedWorkDetailType = newValue;
      workInfoDetails
          .firstWhere((elem) => elem.name == "종류",
              orElse: () => WorkInfoDetail(
                    name: "종류",
                  ))
          .value = null;
    });
  }

  changeProvince(String newValue) {
    setState(() {
      selectedProvince = newValue;
      selectedCity = null; // 시/군/구 초기화
      // selectedSubCity = null; // 읍/면/동 초기화
    });
  }

  changeCity(String newValue) {
    setState(() {
      selectedCity = newValue; // 시/군/구 초기화
      // selectedSubCity = null; // 읍/면/동 초기화
    });
  }

  changeSubCity(String newValue) {
    setState(() {
      // selectedSubCity = newValue; // 읍/면/동 초기화
    });
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}
