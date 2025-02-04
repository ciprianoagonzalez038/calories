import 'package:calories/config/constants/image_constants.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String imageUrl;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onClose;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.imageUrl,
    required this.backgroundColor,
    required this.textColor,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 20.0, bottom: 20.0),
                  child: Row(
                    children: [
                      Image.asset(
                        imageUrl,
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        message,
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Center(
                child: InkWell(
                  onTap: onClose,
                  child: SizedBox(
                    child: Image.asset(
                      ImageConstants.icClose,
                      width: 25,
                      height: 25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
