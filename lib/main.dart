import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const request = "INPUT YOUR API KEY HERE";

void main() async {

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white))
      )
    )
  ));
}

  Future<Map> getData() async{
    http.Response response = await http.get(request);
    return json.decode(response.body);

  }

  class Home extends StatefulWidget {
    @override
    _HomeState createState() => _HomeState();
  }
  
  class _HomeState extends State<Home> {

    final brlController = TextEditingController();
    final usdController = TextEditingController();
    final eurController = TextEditingController();
    final btcController = TextEditingController();

      double dolar;
      double euro;
      double btc;

    void _resetFields(){

      setState(() {
      brlController.text = '';
      usdController.text = '';
      eurController.text = '';
      btcController.text = '';
      });
    }

    void _realChanged(String text){
            if(text.isEmpty) {
      _clearAll();
      return;
    }
      double real = double.parse(text);
      usdController.text = (real/dolar).toStringAsFixed(2);
      eurController.text = (real/euro).toStringAsFixed(2);
      btcController.text = (real/btc).toStringAsFixed(6);
    }

    void _dolarChanged(String text){    
          if(text.isEmpty) {
      _clearAll();
      return;
    }
      double dolar = double.parse(text);  
      brlController.text = (dolar * this.dolar).toStringAsFixed(2);
      eurController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
      btcController.text = (dolar * this.dolar / btc).toStringAsFixed(2);
    }

    void _euroChanged(String text){  
          if(text.isEmpty) {
      _clearAll();
      return;
    }
      double euro = double.parse(text);
      brlController.text = (euro * this.euro).toStringAsFixed(2);
      usdController.text = (euro * this.euro / dolar).toStringAsFixed(2);
      btcController.text = (euro * this.euro / btc).toStringAsFixed(2);
    }

     void _btcChanged(String text){  
           if(text.isEmpty) {
      _clearAll();
      return;
    }
      double btc = double.parse(text);
      brlController.text = (btc * this.btc).toStringAsFixed(2);
      usdController.text = (btc * this.btc / dolar).toStringAsFixed(2);
      eurController.text = (btc * this.btc / euro).toStringAsFixed(2);
    }

    void _clearAll(){
        brlController.text = "";
        usdController.text = "";
        eurController.text = "";
        btcController.text = "";
      }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Coin Converter \$",
              style: TextStyle(
              color: Colors.black),),
          backgroundColor: Colors.amber,
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh),
            onPressed: _resetFields,)
          ],
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot){
            switch (snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text('Loading Data....',
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0),
                  textAlign: TextAlign.center,)
                );
              default:
                  if(snapshot.hasError){
                    return Center(
                      child: Text('Error Loading Data',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0),
                        textAlign: TextAlign.center),
                    );
                  }else{
                    dolar = snapshot.data['results']['currencies']['USD']['buy'];
                    euro = snapshot.data['results']['currencies']['EUR']['buy'];
                    btc = snapshot.data['results']['currencies']['BTC']['buy'];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Icon(Icons.monetization_on, 
                                    size: 100.0, 
                                    color: Colors.amber,),
                            buildTextField('BRL', 'R\$ ',brlController, _realChanged),
                              Divider(),
                            buildTextField('USD', 'U\$ ', usdController,_dolarChanged),
                              Divider(),
                            buildTextField('EUR', '€ ', eurController, _euroChanged),
                              Divider(),
                            buildTextField('BTC', '฿ ', btcController, _btcChanged),
                        ],),
                      );
                  }
               }
              })
            );
         }
}

 Widget buildTextField (String label, String prefix, TextEditingController coin, Function changed){
    return TextField(
      controller: coin,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
      style: TextStyle(
          color: Colors.amber,
          fontSize: 25.0),
      onChanged: changed,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      );
}