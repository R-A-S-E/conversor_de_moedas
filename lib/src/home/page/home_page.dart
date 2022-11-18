import 'package:conversor_de_moedas/src/home/controller/home_controller.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController controller = HomeController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: controller.getData(),
        builder: (context, snapshot) {
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
                print(snapshot.data!);
                controller.dolar =
                    snapshot.data!["results"]["currencies"]["USD"]["buy"];
                controller.euro =
                    snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          size: 150.0, color: Colors.amber),
                      buildTextFuild("Reais", "R\$", controller.realController,
                          controller.realChanged),
                      Divider(),
                      buildTextFuild("Dólares", "\$",
                          controller.dolarController, controller.dolarChanged),
                      Divider(),
                      buildTextFuild("Euros", "€", controller.euroController,
                          controller.euroChanged),
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
    String label, String prefix, TextEditingController c, Function(String) f) {
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
