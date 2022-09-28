import 'package:KesuHewa/models/weather_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  var weather = Weather().obs;
  var loading = true.obs;
  var isSnackBar = false.obs;

  @override
  void onInit() {
    super.onInit();
    getWeatherData('new york');
  }

  Future getWeatherData(String cityName) async {
    loading.value = true;
    var apiKey = '86713447866bb60ff99b2b1e6760c9f9';
    var city = cityName;

    var url = 'https://api.openweathermap.org/data/2.5/weather';

    var response = await Dio().get(url,
        queryParameters: {'q': city, 'appid': apiKey, 'units': 'metric'});

    print('STATUS CODE: ${response.statusCode}');
    if (response.statusCode == 200) {
      weather.value = Weather.fromJson(response.data);

    // TODO what is "no city" condition?
    } else if (response.statusCode == 404) {
      isSnackBar.value = true;
    }

    loading.value = false;
    return response.data;
  }




}

// homePageController.snackBarMessage != "" ? Get.snackbar('Error', "Looks like this city doesn't exist!"):
