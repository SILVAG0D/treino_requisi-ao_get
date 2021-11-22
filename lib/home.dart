import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List> pegarUsuarios() async {
    var url = Uri.parse('https://servicodados.ibge.gov.br/api/v2/censos/nomes/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro ao carregar dados do servidor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuários'),
      ),
      body: FutureBuilder<List>(
        future: pegarUsuarios(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Center(
              child: Text('Erro ao carregar usuários'),
            );
          }

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context,index){
                return ListTile(
                  title: Text(snapshot.data![index]['nome']),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
      );
    
  }
}
