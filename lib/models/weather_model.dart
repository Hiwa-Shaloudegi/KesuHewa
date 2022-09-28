
class Weather {
  String? cityName;
  var lon;
  var lat;
  String? main;
  String? description;
  String? icon;
  var temp;
  var tempMin;
  var tempMax;
  var pressure;
  var humidity;
  var windSpeed;
  var dataTime;
  String? country;
  var sunrise;
  var sunset;

  Weather({
    this.cityName,
    this.lon,
    this.lat,
    this.main,
    this.description,
    this.icon,
    this.temp,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    this.windSpeed,
    this.dataTime,
    this.country,
    this.sunrise,
    this.sunset,
  });

  Weather.fromJson(Map<String, dynamic> jsonResponse) {
    cityName = jsonResponse['name'];
    lon = jsonResponse['lon'];
    lat = jsonResponse['lat'];
    main = jsonResponse['weather'][0]['main'];
    description = jsonResponse['weather'][0]['description'];
    icon = setIconPath(description);
    temp = jsonResponse['main']['temp'];
    tempMin = jsonResponse['main']['temp_min'];
    tempMax = jsonResponse['main']['temp_max'];
    pressure = jsonResponse['main']['pressure'];
    pressure = jsonResponse['main']['pressure'];
    humidity = jsonResponse['main']['humidity'];
    windSpeed = jsonResponse['wind']['speed'];
    dataTime = jsonResponse['dt'];
    country = jsonResponse['sys']['country'];
    sunrise = fromUnixTimestamp(jsonResponse['sys']['sunrise']);
    sunset = fromUnixTimestamp(jsonResponse['sys']['sunset']);
  }

  String fromUnixTimestamp(int unixTimestamp) {
    var date = DateTime(unixTimestamp * 1000);
    var hour = date.hour;
    var minutes = date.minute;
    // TODO return fromUTCToLocal('$hour:$minutes');
    // print(fromUTCToLocal('$hour:$minutes'));
    return '$hour:$minutes';
  }

  String fromUTCToLocal(String utcDatetimeString) {
    var timeList = utcDatetimeString.split(':');

    var hour = int.parse(timeList[0]);
    var minute = int.parse(timeList[1]);

    var now = DateTime.now();

    var nowList = now.toString().substring(0, 10).split('-');
    var year = int.parse(nowList[0]);
    var month = int.parse(nowList[1]);
    var day = int.parse(nowList[2]);

    final utcTime = DateTime.utc(year, month, day, hour, minute);

    final localTime = utcTime.toLocal();
    return localTime.toString().substring(11, 16);
  }


  String setIconPath(String? description) {
    if (description == "clear sky") {
      return "assets/images/icons8-sun-96.png";
    } else if (description == "few clouds") {
      return 'assets/images/icons8-partly-cloudy-day-80.png';
    } else if (description!.contains("clouds")) {
      return 'assets/images/icons8-clouds-80.png';
    } else if (description.contains("thunderstorm")) {
      return 'assets/images/icons8-storm-80.png';
    } else if (description.contains("drizzle")) {
      return 'assets/images/icons8-storm-80.png';
    } else if (description.contains("rain")) {
      return 'assets/images/icons8-heavy-rain-80.png';
    } else if (description.contains("snow")) {
      return 'assets/images/icons8-snow-cloud-80.png';
    } else {
      return 'assets/images/icons8-clouds-80.png';
    }
  }
}
