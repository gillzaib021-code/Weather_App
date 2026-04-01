

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// const String apikey="1f135bb660eb45d28da91507261003";

// class WeatherApiServices {
//   final String _baseurl="https://www.weatherapi.com/v1";
//   Future<Map<String, dynamic>> getHourlyForcast(String location)async{
//        final url=Uri.parse("$_baseurl/forecast.json?key=$apikey&s=$location&days=7");

//        final res= await http.get(url);
       
//        if (res.statusCode!=200) {
//          throw
//          Exception("Faild to fetch data: ${res.body}");
//        }

//        final data=json.decode(res.body);

//        //if data give  error

//        if (data.containskey("error")) {
//          throw Exception(data['error']['message']??'invalid location');
//        }

//        return data;
       
//   }
//   // for Previous 7 day forcast

//   Future<List<Map<String, dynamic>>> getPastsevenDayWeather(String location)async{

//      final List<Map<String, dynamic>> pastweather=[];

//      final tody=DateTime.now();
//      for (int i = 1; i <=7; i++) {
//        final data=tody.subtract(Duration(days: i));
//        final formattedDate="${data.year}-${data.month.toString().padLeft(2,"0")}-${data.day.toString().padLeft(2,"0")}";

//        final url=Uri.parse("$_baseurl/history.json?key=$apikey&s=$location&dt=$formattedDate"
//        );
//        final res=await http.get(url);

//        if (res.statusCode==200) {
        
//          final data=json.decode(res.body);
         
//        if (data.containskey("error")) {
//          throw Exception(data['error']['message']??'invalid location');
//        }
//        if (data['forcast']?['forecastday']!=null) {
//          pastweather.add(data);
//        }

//        } else(

//         debugPrint('faild to fetch past data for $formattedDate: ${res.body}')
//               );

       
//        //if data give  error

       
//      }
//     return pastweather;

//   }

// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apikey = "1f135bb660eb45d28da91507261003";

class WeatherApiServices {

  final String _baseurl = "https://api.weatherapi.com/v1";

  // Hourly Forecast
  Future<Map<String, dynamic>> getHourlyForcast(String location) async {

    final url = Uri.parse("$_baseurl/forecast.json?key=$apikey&q=$location&days=7");

    final res = await http.get(url);

    if (res.statusCode != 200) {
      throw Exception("Failed to fetch data: ${res.body}");
    }

    final data = json.decode(res.body);

    // if API gives error
    if (data.containsKey("error")) {
      throw Exception(data['error']['message'] ?? 'Invalid location');
    }

    return data;
  }

  // Previous 7 Day Forecast

  Future<List<Map<String, dynamic>>> getPastsevenDayWeather(String location) async {

    final List<Map<String, dynamic>> pastweather = [];

    final today = DateTime.now();

    for (int i = 1; i <= 7; i++) {

      final date = today.subtract(Duration(days: i));

      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}";

      final url = Uri.parse(
        "$_baseurl/history.json?key=$apikey&q=$location&dt=$formattedDate",
      );

      final res = await http.get(url);

      if (res.statusCode == 200) {

        final jsonData = json.decode(res.body);

        // if API gives error
        if (jsonData.containsKey("error")) {
          throw Exception(jsonData['error']['message'] ?? 'Invalid location');
        }

        if (jsonData['forecast']?['forecastday'] != null) {
          pastweather.add(jsonData);
        }

      } else {

        debugPrint("Failed to fetch past data for $formattedDate: ${res.body}");

      }
    }

    return pastweather;
  }
}