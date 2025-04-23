import 'package:flutter/material.dart';

// Função principal que inicia o app
void main(){
  runApp(MyApp());
}

// MyApp é um StatefulWidget porque o quiz muda de estado (pontuação, perguntas, etc.)
class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

// Estado do MyApp onde a lógica do quiz acontece
class _MyAppState extends State<MyApp>{

  // Lista com as perguntas, opções, respostas corretas e imagens
  final List<Map<String, dynamic>> perguntas = [
    {
      'pergunta': 'O MPB Nasceu qual década?',
      'opcoes': ['1960', '1970', '1980', '1990'],
      'respostaCorreta': '1960' ,
      'imagem': 'https://vestibulares.estrategia.com/portal/wp-content/uploads/2021/10/mpb-vestibular-1.jpg'
    }, 
    {
      'pergunta' : 'Qual é o tema central da canção “Cálice”?',
      'opcoes': ['Revolta da Chibata', 'Guerra dos canudos', 'Revolta da Vacina', 'Ditadura Militar'],
      'respostaCorreta': 'Ditadura Militar',
      'imagem': 'https://www.jornaltornado.pt/wp-content/uploads/2019/05/Milton-Nascimento-e-Chico-Buarque-Primeiro-de-Maio.jpg'
    },
    {
      'pergunta': 'A canção “Pais e Filhos” é de qual banda brasileira que também é considerada parte da MPB contemporânea?',
      'opcoes': ['Legião Urbana', 'Titãs', 'Skank', 'Charlie Brown Jr'],
      'respostaCorreta': 'Legião Urbana',
      'imagem':'https://curtafm.com/wp-content/uploads/2023/05/legiao-urbana.jpg'
    },
    {
      'pergunta': 'Qual o estado o cantor Djavan é natural?',
      'opcoes': ['Piauí', 'Rio de Janeiro', 'Bahia', 'Alagoas'],
      'respostaCorreta': 'Alagoas',
      'imagem': 'https://djavan.com.br/content/uploads/2022/08/bio-1-960x0-c-default.jpg'
    },
    {
      'pergunta': 'A música "Vilarejo" é de qual cantora abaixo?',
      'opcoes': ['Elis Regina', 'Adriana Calcanhoto', 'Marisa Monte', 'Cássia Eller'],
      'respostaCorreta': 'Marisa Monte',
      'imagem': 'https://otrecocerto.com/wp-content/uploads/2015/10/civita-di-bagnoregio-italy.jpg?w=650&h=433'
    }
  ];

  // Variáveis de estado do quiz
  int perguntaAtual = 0;         // Índice da pergunta atual
  int pontos = 0;                // Pontuação do jogador
  String? mensagem;             // Mensagem de feedback (correta ou errada)
  bool quizFinalizado = false; // Indica se o quiz terminou

  // Função para verificar a resposta selecionada
  void verificarResposta(String respostaEscolhida){
    String respostaCorreta = perguntas[perguntaAtual]['respostaCorreta'];

    // Atualiza o estado conforme a resposta
    setState(() {
      if (respostaEscolhida == respostaCorreta){
        pontos++;
        mensagem = "Resposta Certa! +1";
      } else {
        mensagem = "Resposta Errada!";
      }
    });

    // Espera 2 segundos e avança para próxima pergunta ou finaliza
    Future.delayed(Duration(seconds: 2), (){
      setState(() {
        mensagem = null;
        if (perguntaAtual < perguntas.length - 1){
          perguntaAtual++;
        } else {
          quizFinalizado = true;
        }
      }); 
    });
  }

  // Função que reinicia o quiz
  void reiniciarQuiz(){
    setState(() {
      perguntaAtual = 0;
      pontos = 0;
      quizFinalizado = false;
      mensagem = null;
    });
  }

  // Método de construção da interface
  @override
  Widget build(BuildContext context){
    final perguntaAtualData = perguntas[perguntaAtual]; // Dados da pergunta atual
    return MaterialApp(
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "MPB",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.brown, 
        ),
        body: Center(
          child: quizFinalizado 
          // Tela final quando o quiz acaba
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Parabéns! , você terminou o quiz",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24)
                ),
                SizedBox(height: 20),
                Text("Sua pontuação: $pontos/${perguntas.length}"),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: reiniciarQuiz,
                  child: Text('Recomeçar')
                )
              ],
            )
          // Tela com a pergunta e as opções
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Exibe imagem da pergunta ou uma imagem padrão
                if (perguntaAtualData.containsKey('imagem'))
                  Image.network(
                    perguntaAtualData['imagem'],
                    width: 200,
                    height: 150,
                  )
                else
                  Image.network(
                    "https://vestibulares.estrategia.com/portal/wp-content/uploads/2021/10/mpb-vestibular-1.jpg",
                    width: 200,
                    height: 150,
                  ),
                SizedBox(height: 20),

                // Texto da pergunta
                Text(
                  perguntas[perguntaAtual]["pergunta"],
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                // Botões com as opções de resposta
                ...perguntas[perguntaAtual]["opcoes"].map<Widget>((opcao){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown
                      ),
                      onPressed: mensagem == null ? () => verificarResposta(opcao) : null,
                      child: Text(
                        opcao,
                        style: TextStyle(color: Colors.white),
                      )
                    )
                  );
                }).toList(),
                SizedBox(height: 20),

                // Mostra mensagem de acerto ou erro
                if (mensagem != null)
                  Text(
                    mensagem!,
                    style: TextStyle(
                      color: mensagem == "Resposta Certa! +1"
                          ? Colors.green 
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    )
                  ),

                SizedBox(height: 20),
                
                // Pontuação atual do jogador
                Text('Pontuação: $pontos')
              ],
            )
        ),
      )
    );
  }
}