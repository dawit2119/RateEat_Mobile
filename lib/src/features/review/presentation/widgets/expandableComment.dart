import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ExpandableComment extends StatefulWidget {
  final String comment;
  final int trimLength;
  const ExpandableComment({
    Key? key,
    required this.comment,
    this.trimLength = 100,
  }) : super(key: key);

  @override
  _ExpandableCommentState createState() => _ExpandableCommentState();
}

class _ExpandableCommentState extends State<ExpandableComment> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isTrimmed = widget.comment.length > widget.trimLength;
    final displayText = isTrimmed && !_expanded
        ? widget.comment.substring(0, widget.trimLength) + '...'
        : widget.comment;

    return AnimatedCrossFade(
      crossFadeState:
          _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: Duration(milliseconds: 200),
      firstChild: RichText(
        text: TextSpan(
          text: displayText,
          style: GoogleFonts.poppins(
            color: AppColors.textDark,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
            fontSize: 14.sp,
          ),
          children: isTrimmed && !_expanded
              ? [
                  TextSpan(
                    text: " More",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() => _expanded = true);
                      },
                  ),
                ]
              : [],
        ),
      ),
      secondChild: GestureDetector(
        onTap: () {
          setState(() {
            _expanded = false;
          });
        },
        child: Text(
          widget.comment,
          style: GoogleFonts.poppins(
            color: AppColors.textDark,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
