import 'package:flutter/material.dart';
import 'package:reposit/servicos/autenticacao_servico.dart';

class InicioTela extends StatelessWidget {
  const InicioTela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tela Inicial"),),
      drawer: Drawer(
        child: ListView(children: [
          ListTile(leading: Icon(Icons.logout), title: Text("Deslogar"), onTap: (){
            AutenticacaoServico().deslogar();
          },),
        ],),
      ),
    );
  }
}