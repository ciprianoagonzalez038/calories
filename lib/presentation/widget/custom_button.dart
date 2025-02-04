import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color activeBackground;
  final Color disabledBackground;
  final Color activeTextColor;
  final Color disabledTextColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.activeBackground = Colors.blue,
    this.disabledBackground = Colors.grey,
    this.activeTextColor = Colors.white,
    this.disabledTextColor = Colors.black54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return disabledBackground;
                }
                return activeBackground;
              },
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return disabledTextColor;
                }
                return activeTextColor;
              },
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
