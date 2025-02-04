import 'package:calories/config/constants/color_constants.dart';
import 'package:calories/config/constants/image_constants.dart';
import 'package:calories/config/networking/api_service.dart';
import 'package:calories/config/parameters/parameters.dart';
import 'package:calories/infrastructure/models/request/calories_request.dart';
import 'package:calories/infrastructure/models/response/calories_response.dart';
import 'package:calories/presentation/widget/custom_dialog.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PredictionUseCase {
  final String baseUrl;

  PredictionUseCase({required this.baseUrl});

  Future<void> validateApiRest(
      CaloriesRequest request, BuildContext context) async {
    ApiService apiService = ApiService(baseUrl);
    final Either<String, CaloriesResponse> result =
        await apiService.predictCalories(request);
    await Future.delayed(const Duration(seconds: 1));
    result.fold(
      (String failure) {
        Fluttertoast.showToast(
          msg: Parameters.failedToGetPrediction,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorConstants.backgroundErrorToast,
          textColor: Colors.white,
        );
      },
      (CaloriesResponse response) {
        double calories = response.predictedCalories;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              title: Parameters.caloriePrediction,
              message: "${calories.toStringAsFixed(2)} Kcal",
              imageUrl: ImageConstants.icCalories,
              backgroundColor: ColorConstants.background,
              textColor: Colors.black,
              onClose: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
    );
  }
}
