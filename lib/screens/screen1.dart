import 'package:cindy_weather/homeWidget.dart';
import 'package:cindy_weather/model/current_response_data.dart';
import 'package:cindy_weather/model/current_weather.dart';
import 'package:cindy_weather/model/response_data.dart';
import 'package:cindy_weather/service/current_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      new Screen1();
    });
    return null;
  }

  void initState() {
    super.initState();
    CurrentAPI().fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CurrentWeather>(
        future: CurrentAPI().fetchWeather(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.hasData) {
            return RefreshIndicator(
                color: Colors.black,
                key: refreshKey,
                onRefresh: refreshList,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) {
                    DateTime datetime = DateTime.now().add(Duration(
                        seconds:
                            CurrentResponseData.weatherResponseModel.timezone -
                                DateTime.now().timeZoneOffset.inSeconds));

                    return Column(children: [
                      // elevation: 2,

                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(20, 50, 0, 5),
                        child: Text(
                          '${CurrentResponseData.weatherResponseModel.name},\nNigeria',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20, bottom: 50),
                          child: Text(
                            DateFormat.MMMEd().format(datetime),
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          )),
                      Text(
                        'Today',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CurrentResponseData.weather[i].icon != null
                              ? Image.network(
                                  "https://openweathermap.org/img/w/" +
                                      CurrentResponseData.weather[i].icon +
                                      ".png",
                                  fit: BoxFit.contain,
                                )
                              : Text(''),
                          Text(
                            '${CurrentResponseData.weatherResponseModel.wind.deg.toString()}°',
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        CurrentResponseData
                            .weatherResponseModel.weather[i].description,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                  
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Text(
                              '5 DAYS WEATHER FORECAST',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                      ),
                      HomeWidget(),
                    ]);
                  },
                  itemCount: CurrentResponseData.weather.length,
                ));
          } else {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                backgroundColor: Colors.black,
                valueColor: new AlwaysStoppedAnimation(Colors.yellow),
              ),
            );
          }
        },
      ),
      backgroundColor: Colors.blue,
    );
  }
}
