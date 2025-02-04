import 'package:calories/config/constants/color_constants.dart';
import 'package:calories/config/constants/image_constants.dart';
import 'package:calories/config/parameters/parameters.dart';
import 'package:calories/presentation/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'prediction_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController ipController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    ipController.addListener(_validateInputs);
    portController.addListener(_validateInputs);
  }

  @override
  void dispose() {
    ipController.dispose();
    portController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      isEnabled =
          ipController.text.isNotEmpty && portController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(),
      backgroundColor: ColorConstants.background,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              elevation: 4,
              color: ColorConstants.card,
              surfaceTintColor: ColorConstants.card,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    lottieTop(),
                    const SizedBox(height: 30),
                    buildTextField(Parameters.serverIP, ipController),
                    const SizedBox(height: 30),
                    buildTextField(Parameters.serverPort, portController),
                    const SizedBox(height: 90),
                    CustomButton(
                      text: Parameters.continueButton,
                      onPressed: isEnabled ? () => navigate() : null,
                      activeBackground: ColorConstants.backgroundButtonEnable,
                      disabledBackground:
                          ColorConstants.backgroundButtonDisable,
                      activeTextColor: ColorConstants.textButtonEnable,
                      disabledTextColor: ColorConstants.textButtonDisable,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget lottieTop() {
    return Lottie.asset(
      ImageConstants.icServer,
      width: 200,
      height: 200,
      fit: BoxFit.contain,
    );
  }

  navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PredictionScreen(
          ip: ipController.text,
          port: portController.text,
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      inputFormatters: _getFormatter(),
      keyboardType: TextInputType.number,
      cursorColor: ColorConstants.cursor,
      style: const TextStyle(color: ColorConstants.textPrimary),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        filled: true,
        fillColor: ColorConstants.background,
        labelStyle: const TextStyle(color: ColorConstants.textField),
        label: Container(
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: ColorConstants.background,
            border: Border.all(color: ColorConstants.background, width: 1),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              label,
              style: const TextStyle(color: ColorConstants.textField),
            ),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          gapPadding: 0,
          borderSide:
              const BorderSide(color: ColorConstants.borderTextField, width: 2),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          gapPadding: 0,
          borderSide:
              const BorderSide(color: ColorConstants.borderTextField, width: 2),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

  AppBar customAppbar() {
    return AppBar(
      title: const Text(
        Parameters.serverConfiguration,
        style: TextStyle(
          color: ColorConstants.appbarText,
        ),
      ),
      backgroundColor: ColorConstants.appbar,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2.0),
        child: Container(
          color: Colors.grey.shade300,
          height: 2.0,
        ),
      ),
    );
  }

  List<TextInputFormatter> _getFormatter() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      LengthLimitingTextInputFormatter(20),
    ];
  }
}
