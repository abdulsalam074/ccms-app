import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {

  Future<Map<String,dynamic>> getWeather(
      String city) async {

    final response = await http.get(

      Uri.parse(
          "https://wttr.in/$city?format=j1"),

    );

    if(response.statusCode==200){

      return jsonDecode(response.body);

    }else{

      throw Exception(
          "Failed to load weather");

    }
  }
}
