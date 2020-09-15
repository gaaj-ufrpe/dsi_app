import 'package:dsi_app/constants.dart';
import 'package:dsi_app/dsi_widgets.dart';
import 'package:dsi_app/infra.dart';
import 'package:dsi_app/pessoa.dart';
import 'package:flutter/material.dart';

/// A classe aluno representa um aluno do sistema e possui uma Pessoa.
/// Caso aluno fosse uma subclasse de pessoa (como aconteceu nos branches
/// anteriores), não seria possível ter uma pessoa que fosse ao mesmo tempo
/// um aluno e um professor.
/// Assim, caso a mesma pessoa seja aluno e professor, basta que ambos registros
/// (de aluno e de professor) apontem para a mesma pessoa.
class Aluno {
  String id, matricula;
  Pessoa pessoa;

  Aluno({this.id, this.matricula, this.pessoa});

  //TIP Observe que é delegada para a superclasse a conversão dos seus
  //atributos específicos. Esta chamada deve ser a última coisa a ser feita
  //no construtor.
  Aluno.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        matricula = json['matricula'],
        pessoa = Pessoa.fromJson(json['pessoa']);

  ///TIP este método converte o objeto atual para um mapa que representa um
  ///objeto JSON.
  Map<String, dynamic> toJson() =>
      {'id': id, 'matricula': matricula, 'id_pessoa': pessoa.id};
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
          MaintainPessoaBody(aluno.pessoa),
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
