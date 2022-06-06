import 'dart:convert';
import 'dart:io';
import 'package:cindy_weather/model/current_response_data.dart';
import 'package:cindy_weather/model/current_weather.dart';
import 'package:http/http.dart' as Client;
import 'dart:async';

class CurrentAPI {
  Future<CurrentWeather> fetchWeather() async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=lagos,ng&appid={api key}";
    var respBody;

    print(url);
    


    try {
      final httpResponse = await Client.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      print(json.decode(httpResponse.statusCode.toString()));
      print(json.decode(httpResponse.body));

      if (httpResponse.statusCode == 200) {
        respBody = jsonDecode(httpResponse.body);
        CurrentResponseData.weatherResponseModel = CurrentWeather.fromJson(respBody);
        CurrentResponseData.weather = CurrentResponseData.weatherResponseModel.weather;
      }
    } on Exception catch (e) {
      
      print(e.toString());
    }
    return CurrentResponseData.weatherResponseModel;
  }
}
