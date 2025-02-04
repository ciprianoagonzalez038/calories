import 'package:calories/infrastructure/models/request/calories_request.dart';
import 'package:calories/infrastructure/models/response/calories_response.dart';

class CaloriesMapper {
  static Map<String, dynamic> fromCaloriesRequestToMap(
      CaloriesRequest request) {
    return {
      "Gender": request.gender,
      "Age": request.age,
      "Weight": request.weight,
      "Duration": request.duration,
      "Heart_Rate": request.heartRate
    };
  }

  static CaloriesResponse fromMapToCaloriesResponse(
      Map<String, dynamic> response) {
    return CaloriesResponse(predictedCalories: response['predicted_calories']);
  }
}
