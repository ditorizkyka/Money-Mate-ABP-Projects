import 'package:flutter/cupertino.dart';
import 'package:money_mate_mobile/constant/constant.dart';

class ButtonApp extends StatelessWidget {
  final String action;
  final GestureTapCallback onTap;

  const ButtonApp({required this.action, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        width: double.infinity,
        padding: EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorApp.mainColor,
        ),
        child: Center(child: Text(action, style: TypographyApp.buttonText)),
      ),
    );
  }
}
