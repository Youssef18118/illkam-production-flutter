import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TextFormFieldType { medium, thin }

typedef string2Void = void Function(String?);

class IkTextField extends StatefulWidget {
  final String? label;
  final String placeholder;
  final Widget? action;
  final Widget? prefix;
  final int? maxline;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;
  final string2Void? onChange;
  final TextEditingController? controller;
  final bool enabled;
  final String? Function(String?)? validator;
  final String? errorText;
  final bool autoValidate;
  final TextFormFieldType fieldType;
  final Function? onTap;
  final int? length;

  const IkTextField(
      {Key? key,
      this.label,
      required this.placeholder,
      this.prefix,
      this.onChange,
      this.action,
      this.controller,
      this.maxline,
      this.formatters,
        this.length,
      this.keyboardType,
      this.enabled = true,
      this.validator,
      this.autoValidate = false,
        this.onTap,
      // this.formKey,
      this.fieldType = TextFormFieldType.medium,
      this.errorText})
      : super(key: key);

  @override
  State<IkTextField> createState() => _IkTextFieldState();
}

class _IkTextFieldState extends State<IkTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null)
          Container(
            margin: EdgeInsets.only(bottom: 6),
            child: Text(
              widget.label!,
              style: TextStyle(
                color: Color(0xFF949494),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.12,
              ),
            ),
          ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: TextFormField(
              // key: widget.formKey,
                  onTap: () => {
                    if(widget.onTap != null){
                      widget.onTap!()
                    }
                  },
              validator: widget.validator,
              enabled: widget.enabled,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxline != null ? widget.maxline : 1,
                  maxLength: widget.length,
              controller: widget.controller,
              autovalidateMode:
                  // widget.autoValidate
                  // ? AutovalidateMode.always
                  // :
                  AutovalidateMode.onUserInteraction,
              onChanged: widget.onChange,
              textAlign: widget.fieldType == TextFormFieldType.medium
                  ? TextAlign.start
                  : TextAlign.end,
              // focusNode: _focusNode,
              inputFormatters: widget.formatters,
              style: TextStyle(
                color: Color(0xFF545454),
                fontSize: 15,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                prefix: widget.prefix,
                suffix: widget.action,
                // suffixStyle: LT_TextStyle.medium_15,
                errorText: widget.errorText,
                isDense: true,
                contentPadding:
                    // widget.action != null?
                    // const EdgeInsets.only(right: 17, left: 17, top: 0, bottom: 0)
                    //     :
                    widget.fieldType == TextFormFieldType.medium
                        ? const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 17)
                        : const EdgeInsets.symmetric(
                            vertical: 9, horizontal: 16),
                hintText: widget.placeholder,

                hintStyle: TextStyle(
                  color: Color(0xFFC7C7C7),
                  fontSize: 15,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                    borderRadius: widget.fieldType == TextFormFieldType.thin
                        ? BorderRadius.circular(12)
                        : BorderRadius.all(Radius.circular(4.0)),
                    borderSide: BorderSide(
                        width: widget.fieldType == TextFormFieldType.thin
                            ? 1
                            : 0.50,
                        color: Color(widget.fieldType == TextFormFieldType.thin
                            ? 0xFFB2C6DB
                            : 0xFFDDE4EB))),
                // 밑줄 스타일을 제거
                enabledBorder: OutlineInputBorder(
                    borderRadius: widget.fieldType == TextFormFieldType.thin
                        ? BorderRadius.circular(12)
                        : BorderRadius.all(Radius.circular(4.0)),
                    borderSide: BorderSide(
                        width: widget.fieldType == TextFormFieldType.thin
                            ? 1
                            : 0.50,
                        color: Color(widget.fieldType == TextFormFieldType.thin
                            ? 0xFFB2C6DB
                            : 0xFFDDE4EB))),
                // 포커스 시 밑줄 스타일을 제거
                focusedBorder: OutlineInputBorder(
                    borderRadius: widget.fieldType == TextFormFieldType.thin
                        ? BorderRadius.circular(12)
                        : BorderRadius.all(Radius.circular(4.0)),
                    borderSide:
                        BorderSide(width: 0.50, color: Color(0xFF00A12B7))),
                // 에러 메시지 밑줄 스타일을 제거
                errorBorder: OutlineInputBorder(
                    borderRadius: widget.fieldType == TextFormFieldType.thin
                        ? BorderRadius.circular(12)
                        : BorderRadius.all(Radius.circular(4.0)),
                    borderSide:
                        BorderSide(width: 0.50, color: Color(0xFFDDE4EB))),
                // 포커스 된 에러 메시지 밑줄 스타일을 제거
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: widget.fieldType == TextFormFieldType.thin
                        ? BorderRadius.circular(12)
                        : BorderRadius.all(Radius.circular(4.0)),
                    borderSide:
                        BorderSide(width: 0.50, color: Color(0xFFDDE4EB))),
              ),
            )),
            // if (widget.action != null) widget.action!
          ],
        ),
      ],
    );
  }
}
