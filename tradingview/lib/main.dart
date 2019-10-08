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
  final euroController =TextEditingController();
  final fmt = NumberFormat("#,##0.00", "pt_BR");

  double dollar, euro;
  Future<Map> dados;

  @override
  void initState() {
    dados = _getData();
    super.initState();
  }

  Future<Map> _getData() async{
    http.Response response = await http.get(request);
    return json.decode(response.body);
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: dados,
      builder: (context,snapshot){
        return null;
      },
    );
  }
}
