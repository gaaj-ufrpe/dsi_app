import 'package:dsi_app/constants.dart';
import 'package:dsi_app/dsi_widgets.dart';
import 'package:dsi_app/infra.dart';
import 'package:flutter/material.dart';

class Aluno {
  int id;
  String nome, matricula;
  Aluno({this.id, this.nome, this.matricula});
}

var alunoController = AlunoController();

class AlunoController {
  var _nextId = 1;
  var _alunos = <Aluno>[];
  AlunoController() {
    for (var i = 1; i <= 20; i++) {
      var id = _nextId++;
      var aluno = Aluno(
        id: id,
        nome: 'Aluno $id',
        matricula: id.toString().padLeft(10, '0'),
      );
      _alunos.add(aluno);
    }
  }

  List<Aluno> getAll() {
    return _alunos;
  }

  Aluno save(aluno) {
    //se o aluno não possui id, está inserindo.
    //caso contrário, está alterando.
    //na alteração, remove o elemento do índice e substitui pelo novo.
    if (aluno.id == null) {
      aluno.id = _nextId++;
      _alunos.add(aluno);
    } else {
      var idx = _alunos.indexWhere((element) => element.id == aluno.id);
      _alunos.setRange(idx, idx + 1, [aluno]);
    }
    return aluno;
  }

  bool remove(aluno) {
    var result = false;
    var idx = _alunos.indexWhere((element) => element.id == aluno.id);
    if (idx != -1) {
      result = true;
      _alunos.removeAt(idx);
    }
    return result;
  }
}

class ListAlunoPage extends StatefulWidget {
  @override
  ListAlunoPageState createState() => ListAlunoPageState();
}

class ListAlunoPageState extends State<ListAlunoPage> {
  List<Aluno> _alunos = alunoController.getAll();

  @override
  Widget build(BuildContext context) {
    return DsiScaffold(
      title: 'Listagem de Alunos',
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => dsiHelper.go(context, '/maintain_aluno'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        // physics: NeverScrollableScrollPhysics(),
        itemCount: _alunos.length,
        itemBuilder: _buildListTileAluno,
      ),
    );
  }

  Widget _buildListTileAluno(context, index) {
    var aluno = _alunos[index];
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          alunoController.remove(aluno);
          _alunos.remove(index);
        });
        dsiHelper.showMessage(context, '${aluno.nome} foi removido.');
      },
      background: Container(
        color: Colors.red,
        child: Row(
          children: <Widget>[
            Constants.spaceSmallWidth,
            Icon(Icons.delete, color: Colors.white),
            Spacer(),
            Icon(Icons.delete, color: Colors.white),
            Constants.spaceSmallWidth,
          ],
        ),
      ),
      child: ListTile(
        title: Text(aluno.nome),
        subtitle: Column(
          children: <Widget>[
            Text('id. ${aluno.id} (NUNCA APRENSETE O ID DE UM REGISTRO!)'),
            SizedBox(width: 8.0),
            Text('mat. ${aluno.matricula}'),
          ],
        ),
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
      body: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: 'Nome*'),
            validator: (String value) {
              return value.isEmpty ? 'Nome inválido.' : null;
            },
            initialValue: aluno.nome,
            onSaved: (newValue) => aluno.nome = newValue,
          ),
          Constants.spaceSmallHeight,
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
