import 'package:dsi_app/constants.dart';
import 'package:dsi_app/dsi_widgets.dart';
import 'package:dsi_app/infra.dart';
import 'package:dsi_app/pessoa.dart';
import 'package:flutter/material.dart';

/// A classe aluno representa um aluno do sistema e é uma subclasse de Pessoa.
/// Assim, tudo o que Pessoa possui, um aluno também possui.
/// E todas as operações que podem ser feitas com uma pessoa, também podem ser
/// feitas com um aluno. Assim, todos os métodos e funções que recebiam uma
/// Pessoa como parâmetro, também podem receber também um Aluno.
class Aluno extends Pessoa {
  String matricula;

  //TIP Observe que o construtor de aluno repassa alguns dos parâmetros recebidos
  //para o construtor da super classe (Pessoa).
  Aluno({cpf, nome, endereco, this.matricula})
      : super(cpf: cpf, nome: nome, endereco: endereco);

  //TIP Observe que é delegada para a superclasse a conversão dos seus
  //atributos específicos. Esta chamada deve ser a última coisa a ser feita
  //no construtor.
  Aluno.fromJson(Map<String, dynamic> json)
      : matricula = json['matricula'],
        super.fromJson(json);

  ///TIP este método converte o objeto atual para um mapa que representa um
  ///objeto JSON. Observe que a conversão do objeto endereço é delegada para
  ///o próprio objeto, seguindo o princípio do encapsulamento.
  ///Observe o uso do cascade notation do flutter. Caso este atalho não fosse
  ///usado, seria preciso criar o método com corpo, chamando o super.toJson()
  ///e atribuindo o mapa a uma variável, em seguida adicionar as novas entradas
  ///no mapa, para só então retornar o mapa como resultado do método:
  ///``
  ///var result = super.toJson();
  ///result.addAll({
  ///       'matricula': matricula,
  ///     });
  ///return result;
  ///``
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'matricula': matricula,
    });
}

var alunoController = AlunoController();

class AlunoController {
  Future<List<Aluno>> getAll() async {
    List<Pessoa> result = await pessoaController.getAll();
    return result.whereType<Aluno>().toList();
  }

  Future<Aluno> save(Aluno aluno) async {
    Pessoa pessoa = await pessoaController.save(aluno);
    //TIP aqui foi feito um cast de pessoa para aluno, para garantir que o
    // objeto retornado é um aluno e não uma pessoa. Caso isso não fosse feito,
    // daria uma erro no 'Future' que seria de pessoa e não de aluno, como
    // declarado no retorno da função. A outra alternativa, seria usar o
    // retorno dinâmico.
    return pessoa as Aluno;
  }

  Future<bool> remove(Aluno aluno) async {
    return pessoaController.remove(aluno);
  }
}

class ListAlunoPage extends StatefulWidget {
  @override
  ListAlunoPageState createState() => ListAlunoPageState();
}

class ListAlunoPageState extends State<ListAlunoPage> {
  Future<List<Aluno>> _alunos;

  @override
  void initState() {
    super.initState();
    _alunos = alunoController.getAll();
  }

  ///TIP Como a listagem agora trabalha sobre o Future de alunos ao invés
  ///do aluno em si, é necessário envolver o ListView em um FutureBuilder.
  @override
  Widget build(BuildContext context) {
    return DsiScaffold(
      title: 'Listagem de Alunos',
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => dsiHelper.go(context, '/maintain_aluno'),
      ),
      body: FutureBuilder(
          future: _alunos,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              //TIP apresenta o indicador de progresso enquanto carrega a página.
              return Center(child: CircularProgressIndicator());
            }
            var alunos = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: alunos.length,
              itemBuilder: (context, index) =>
                  _buildListTileAluno(context, alunos[index]),
            );
          }),
    );
  }

  Widget _buildListTileAluno(context, aluno) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          alunoController.remove(aluno);
        });
        dsiHelper.showMessage(
          context: context,
          message: '${aluno.nome} foi removido.',
        );
      },
      background: Container(
        color: Colors.red,
        child: Row(
          children: <Widget>[
            Constants.boxSmallWidth,
            Icon(Icons.delete, color: Colors.white),
            Spacer(),
            Icon(Icons.delete, color: Colors.white),
            Constants.boxSmallWidth,
          ],
        ),
      ),
      child: ListTile(
        title: Text(aluno.nome),
        subtitle: Text('mat. ${aluno.matricula}'),
        onTap: () => dsiHelper.go(context, "/maintain_aluno", arguments: aluno),
      ),
    );
  }
}

class MaintainAlunoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Aluno aluno = dsiHelper.getRouteArgs(context);
    if (aluno == null) {
      aluno = Aluno();
    }

    return DsiBasicFormPage(
      title: 'Aluno',
      onSave: () {
        alunoController.save(aluno);
        dsiHelper.go(context, '/list_aluno');
      },
      body: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: Constants.boxSmallHeight.height,
        children: <Widget>[
          MaintainPessoaBody(aluno),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Matrícula*'),
            validator: (String value) {
              return value.isEmpty ? 'Matrícula inválida.' : null;
            },
            initialValue: aluno.matricula,
            onSaved: (newValue) => aluno.matricula = newValue,
          ),
        ],
      ),
    );
  }
}
