import 'package:flutter/material.dart';

class OtpCodeForm extends StatefulWidget {
  final double width;
  final double height;
  final List<TextEditingController> controllers;

  const OtpCodeForm({
    required Key key,
    required this.height,
    required this.width,
    required this.controllers,
  }) : super(key: key);

  @override
  State<OtpCodeForm> createState() => _OtpCodeFormState();
}

class _OtpCodeFormState extends State<OtpCodeForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < 6; i++) {
      widget.controllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        4,
        (index) => SizedBox(
          width: widget.width * 0.17,
          child: TextFormField(
            controller: widget.controllers[index],
            maxLength: 1,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: widget.height * 0.036,
            ),
            decoration: InputDecoration(
              counter: const Offstage(),
              hintText: (index + 1).toString(),
              hintStyle: const TextStyle(
                color: Color(0xFFE1E4E8),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: widget.controllers[index].text.isNotEmpty
                        ? const Color(0xFF383749)
                        : const Color(0xFFE1E4E8),
                    width: widget.width * 0.006),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: widget.width * 0.006,
                  color: const Color(0xFF383749),
                ),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 3) {
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}
