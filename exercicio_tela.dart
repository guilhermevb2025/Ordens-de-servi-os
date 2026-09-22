import 'package:flutter/material.dart';
import 'package:reposit/_comum/minhas_cores.dart';
import 'package:reposit/modelos/exercicio_modelos.dart';
import 'package:reposit/modelos/sentimento_modelo.dart';

class ExercicioTela extends StatefulWidget {
  const ExercicioTela({super.key});

  @override
  State<ExercicioTela> createState() => _ExercicioTelaState();
}

class _ExercicioTelaState extends State<ExercicioTela> {
  // Dados do exercício
  final ExercicioModelos exercicioModelos = ExercicioModelos(
    id: "EX001",
    nome: "MAICON SOUZA",
    treino: "PESO 02",
    comoFazer: "Segure a barra e puxe",
  );

  // Transformado em uma lista não-final para permitir remoções/adições
  List<SentimentoModelo> listSentimentos = [
    SentimentoModelo(
      id: "SE001",
      sentimento: "Pouca ativação hoje",
      data: "2026-04-26",
    ),
    SentimentoModelo(
      id: "SE002",
      sentimento: "Já senti alguma ativação",
      data: "2026-04-27",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Column(children: [
          Text(exercicioModelos.nome, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          Text(exercicioModelos.treino, style: TextStyle(fontSize: 15),),
        ],),
      centerTitle: true,
      backgroundColor: MinhasCores.azulEscuro,
      elevation: 0,
      toolbarHeight: 72,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(32),
      ),
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("FOI CLICADO!");
          // Exemplo de como adicionar algo no futuro:
          // setState(() {
          //   listSentimentos.add(...);
          // });
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Enviar foto"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Tirar foto"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Como fazer?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
            ),
            Text(exercicioModelos.comoFazer),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(color: Colors.black),
            ),
            const Text(
              "Como você está?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
            ),
            const SizedBox(height: 8),
            
            // Usando o Spread Operator (...) para jogar os widgets direto no ListView
            ...List.generate(listSentimentos.length, (index) {
              SentimentoModelo sentimentoAgora = listSentimentos[index];
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(sentimentoAgora.sentimento),
                subtitle: Text(sentimentoAgora.data),
                leading: const Icon(Icons.double_arrow),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Agora a exclusão funciona na tela graças ao setState!
                    setState(() {
                      listSentimentos.removeAt(index);
                    });
                    print("DELETADO: ${sentimentoAgora.sentimento}");
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}