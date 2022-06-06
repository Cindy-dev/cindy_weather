import 'package:cindy_weather/model/response_data.dart';
import 'package:cindy_weather/model/weather.dart';
import 'package:cindy_weather/screens/screen1.dart';
import 'package:cindy_weather/service/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
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
    WeatherAPI().fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Weather>(
      future: WeatherAPI().fetchWeather(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.hasData) {
          return RefreshIndicator(
              color: Colors.black,
              key: refreshKey,
              onRefresh: refreshList,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white54),
                height: MediaQuery.of(context).size.height * .3,
                padding: EdgeInsets.all(5),
                width: double.infinity,
                margin: EdgeInsets.only(left: 20, right: 10, top: 5),
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, i) {
                    String iconpath =
                        ResponseData.weather[i].weather[0].icon == null
                            ? ""
                            : ResponseData.weather[i].weather[0].icon
                                    .toString()
                                    .split("_")[1] +
                                ResponseData.weather[i].weather[0].icon
                                    .toString()
                                    .split("_")[2]
                                    .toLowerCase();
                    // ["CON.THE",, 04, "N"]

                    String date =
                        ResponseData.weather[i].dtTxt.toString().split(" ")[1];

                    return Container(
                      width: MediaQuery.of(context).size.width * .2,
                      height: MediaQuery.of(context).size.height * .06,
                      child: Card(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(50)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateFormat.MMMd().format(ResponseData.weather[i].dtTxt),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              Text(
                                DateFormat.jm()
                                    .format(DateFormat("hh:mm:ss").parse(date)),
                                style: TextStyle(color: Colors.white),
                              ),
                              ResponseData.weather[i].weather[0].icon != null
                                  ? Image.network(
                                      "https://openweathermap.org/img/w/" +
                                          iconpath +
                                          ".png")
                                  : SizedBox(
                                      height: 50,
                                    ),
                              Text(
                                '${ResponseData.weather[i].wind.deg}°'
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    );
                  },
                  itemCount: ResponseData.weather.length,
                ),
              ));
        } else {
          return Container();
        }
      },
    );
  }
}
