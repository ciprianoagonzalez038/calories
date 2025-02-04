import 'package:calories/config/constants/color_constants.dart';
import 'package:calories/config/constants/image_constants.dart';
import 'package:calories/config/parameters/parameters.dart';
import 'package:calories/infrastructure/models/request/calories_request.dart';
import 'package:calories/presentation/usecase/prediction_usecase.dart';
import 'package:calories/presentation/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class PredictionScreen extends StatefulWidget {
  final String ip;
  final String port;

  const PredictionScreen({super.key, required this.ip, required this.port});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  double age = 25;
  double weight = 70;
  double duration = 30;
  double heartRate = 120;
  int gender = -1;

  bool isLoading = false;

  bool isButtonEnabled() {
    return gender != -1 &&
        age > 0 &&
        weight > 0 &&
        duration > 0 &&
        heartRate > 0;
  }

  late PredictionUseCase _predictionUseCase;

  @override
  void initState() {
    _predictionUseCase =
        PredictionUseCase(baseUrl: "http://${widget.ip}:${widget.port}");
    super.initState();
  }

  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: customAppbar(),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Card(
                    elevation: 4,
                    color: ColorConstants.card,
                    surfaceTintColor: ColorConstants.card,
                    child: Column(
                      children: [
                        Image.asset(
                          ImageConstants.icCalories,
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(height: 30),
                        Text('${Parameters.age}: ${age.toInt()}'),
                        Slider(
                          activeColor: ColorConstants.slider,
                          value: age,
                          min: 20,
                          max: 79,
                          divisions: 100,
                          label: age.toInt().toString(),
                          onChanged: (value) {
                            setState(() {
                              age = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Text('${Parameters.weight}: ${weight.toInt()} kg'),
                        Slider(
                          activeColor: ColorConstants.slider,
                          value: weight,
                          min: 36,
                          max: 132,
                          divisions: 200,
                          label: weight.toInt().toString(),
                          onChanged: (value) {
                            setState(() {
                              weight = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Text('${Parameters.duration}: ${duration.toInt()} min'),
                        Slider(
                          activeColor: ColorConstants.slider,
                          value: duration,
                          min: 1,
                          max: 30,
                          divisions: 120,
                          label: duration.toInt().toString(),
                          onChanged: (value) {
                            setState(() {
                              duration = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                            '${Parameters.heartRate}: ${heartRate.toInt()} bpm'),
                        Slider(
                          activeColor: ColorConstants.slider,
                          value: heartRate,
                          min: 67,
                          max: 128,
                          divisions: 200,
                          label: heartRate.toInt().toString(),
                          onChanged: (value) {
                            setState(() {
                              heartRate = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('${Parameters.gender}: '),
                            Radio(
                              activeColor: ColorConstants.slider,
                              value: 0,
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value as int;
                                });
                              },
                            ),
                            const Text(Parameters.female),
                            Radio(
                              activeColor: ColorConstants.slider,
                              value: 1,
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value as int;
                                });
                              },
                            ),
                            const Text(Parameters.male),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: Parameters.predictButton,
                          onPressed: isButtonEnabled()
                              ? () async {
                                  if (gender == -1) {
                                    Fluttertoast.showToast(
                                      msg: Parameters.pleaseSelectGender,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor:
                                          ColorConstants.backgroundErrorToast,
                                      textColor: ColorConstants.textErrorToast,
                                    );
                                    return;
                                  }
                                  showLoading();
                                  await _predictCalories();
                                  hideLoading();
                                }
                              : null,
                          activeBackground:
                              ColorConstants.backgroundButtonEnable,
                          disabledBackground:
                              ColorConstants.backgroundButtonDisable,
                          activeTextColor: ColorConstants.textButtonEnable,
                          disabledTextColor: ColorConstants.textButtonDisable,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Lottie.asset(
                ImageConstants.icLoading,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),
      ],
    );
  }

  _predictCalories() async {
    CaloriesRequest request = CaloriesRequest(
      gender: gender,
      age: age.toInt(),
      weight: weight.toInt(),
      duration: duration.toInt(),
      heartRate: heartRate.toInt(),
    );

    await _predictionUseCase.validateApiRest(request, context);
  }

  AppBar customAppbar() {
    return AppBar(
      title: const Text(
        Parameters.predictionTitle,
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
}
