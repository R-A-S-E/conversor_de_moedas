import 'package:flutter/material.dart';
//import para utilizar APIs
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//API utilizada
const request = "https://api.hgbrasil.com/finance?format=json&key=6551718e";

void main() async {
  //main async para utilizar dados futuros
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white)));
}

//mapa com dados futuros
Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //pegar dados dos formularios
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  double dolar;
  double euro;
  //apagar todos os dados quando um dado do formulario for apagado
  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  //conversor de moedas e apagar dados
  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  //em dolar
  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  //em euro
  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        //barra invertida para aparencia do sifrão
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      //para aparecer o corpo só depois do carregamento dos dados futuro
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          //caso ainda esteja carregando
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            //caso de error
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao Carregar Dados :(",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                //caso estiver carregado
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          size: 150.0, color: Colors.amber),
                      //função criada para minimizar linhas escritas
                      buildTextFuild(
                          "Reais", "R\$", realController, _realChanged),
                      Divider(),
                      buildTextFuild(
                          "Dólares", "\$", dolarController, _dolarChanged),
                      Divider(),
                      buildTextFuild(
                          "Euros", "€", euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

//funcao de widget de formulario
Widget buildTextFuild(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    //pegar informação do formulario
    controller: c,
    decoration: InputDecoration(
      //label para modificar o texto
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber, fontSize: 25.0),
      border: OutlineInputBorder(),
      //modificar o texto
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25.0,
    ),
    //chamar função de converso
    onChanged: f,
    //para só utilizar numeros
    keyboardType: TextInputType.number,
  );
}
