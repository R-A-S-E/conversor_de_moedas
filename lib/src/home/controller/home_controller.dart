import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeController {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  double dolar = 0;
  double euro = 0;
  void clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  Future<Map<String, dynamic>> getData() async {
    var dio = Dio();
    try {
      print('oi');
      var response = await dio.get(
        'https://api.hgbrasil.com/finance?format=json&key=6551718e',
      );
      print(response.data);
      Map<String, dynamic> data = response.data;
      if (response.statusCode == 200) {
        return data;
      } else {
        return {};
      }
    } on DioError catch (e) {
      print('ERROOROROROEROOEROERO $e');
      return {};
    } finally {
      dio.close();
    }
  }

  void realChanged(String text) {
    if (text.isEmpty) {
      clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void dolarChanged(String text) {
    if (text.isEmpty) {
      clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void euroChanged(String text) {
    if (text.isEmpty) {
      clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }
}
