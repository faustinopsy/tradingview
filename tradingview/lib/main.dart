import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(

MaterialApp(
  home: Home(),
  theme: ThemeData(
    primaryColor:Colors.white,
    accentColor: Colors.amber,
    primarySwatch: Colors.amber,
    brightness: Brightness.dark,
  ),

)
);
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
const request ="https://api.hgbrasil.com/finance?format=json&key=c8572271";
class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final btcController =TextEditingController();
  final fmt = NumberFormat("#,##0.00", "pt_BR");


  double dollar, btc;
  Future<Map> dados;

  @override
  void initState() {
    dados = _getData();
    //print(dados['results']['currencies']['USD']['buy']);
    super.initState();
  }

  Future<Map> _getData() async{
    http.Response response = await http.get(request);
    return json.decode(response.body);
  }

  void realChanged(String texto){
    double real=fmt.parse(texto);
    dollarController.text =fmt.format(real/dollar);
    btcController.text =fmt.format(real/btc);
  }
  void dollarChanged(String texto){
    double valorEmReal=fmt.parse(texto)*dollar;
    realController.text =fmt.format(valorEmReal);
    btcController.text =fmt.format(valorEmReal/btc);
  }
  void btcChanged(String texto){
    double valorEmReal=fmt.parse(texto)*btc;
    realController.text =fmt.format(valorEmReal);
    dollarController.text =fmt.format(valorEmReal/dollar);
  }

  Widget buildTextField(String label,String prefixo,
      TextEditingController controller, Function converter){
    return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      prefixText: prefixo,
      border: OutlineInputBorder(),
      labelStyle: TextStyle(color: Colors.amber)
    ),
    style: TextStyle(color: Colors.teal, fontSize: 25),
    onChanged: converter,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250 - 0.3 * MediaQuery.of(context).size.width),
        child: Stack(
          fit: StackFit.expand,
            children:[
            Container(
              height: 200,
                child: Image.asset('imagens/money.jpeg',fit: BoxFit.cover)
              ),
              Text(
                "Tredin View",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 40,
                  letterSpacing: 1.2,
                  shadows: [
                    BoxShadow(color: Colors.white38,offset: Offset(3,3))
                  ]
                ),
              )
            ]
        ),
      ),
      body: DefaultTextStyle.merge(
        style: TextStyle(
          color: Colors.teal,
          fontSize: 25,
          decoration: TextDecoration.none
        ),
        textAlign: TextAlign.center,
        child: FutureBuilder<Map>(
          future: dados,
          builder: (context,snapshot)
        {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: Text('Carregando dados...'));
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar Dados:('));
              } else {
                dollar = snapshot.data['results']['currencies']['USD']['buy'];
                btc = snapshot.data['results']['currencies']['BTC']['buy'];

                return SingleChildScrollView(
                padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 16),
                      buildTextField('Reais', 'R\$', realController, realChanged),
                      SizedBox(height: 16),
                      buildTextField('Dólares', 'US\$', dollarController, dollarChanged),
                      SizedBox(height: 16),
                      buildTextField('BTC', '₿', btcController, btcChanged)
                    ],
                  ),
                );
              }
          }
        },
        ),
      ),
    );
  }
}
