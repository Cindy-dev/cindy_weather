import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as Client;
import 'dart:async';

import 'package:cindy_weather/model/response_data.dart';
import 'package:cindy_weather/model/weather.dart';

class WeatherAPI {
  Future<Weather> fetchWeather() async {
    final url =
        "https://api.openweathermap.org/data/2.5/forecast?q=lagos,ng&appid={apikey}";
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
        ResponseData.weatherResponseModel = Weather.fromJson(respBody);
        ResponseData.weather = ResponseData.weatherResponseModel.list;
  
      }
    } on Exception catch (e) {
      
      print(e.toString());
    }
    return ResponseData.weatherResponseModel;
  }
}
