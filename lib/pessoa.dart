import 'package:dsi_app/constants.dart';
import 'package:dsi_app/dsi_widgets.dart';
import 'package:dsi_app/infra.dart';
import 'package:flutter/material.dart';

class Estado {
  static final Estado AC = Estado._('Acre', 'AC');
  static final Estado AL = Estado._('Alagoas', 'AL');
  static final Estado AP = Estado._('Amapa', 'AP');
  static final Estado AM = Estado._('Amazonas', 'AM');
  static final Estado BA = Estado._('Bahia', 'BA');
  static final Estado CE = Estado._('Ceará', 'CE');
  static final Estado DF = Estado._('Distrito Federal', 'DF');
  static final Estado ES = Estado._('Espírito Santo', 'ES');
  static final Estado GO = Estado._('Goias', 'GO');
  static final Estado MA = Estado._('Maranhão', 'MA');
  static final Estado MT = Estado._('Mato Grosso', 'MT');
  static final Estado MS = Estado._('Mato Grosso do Sul', 'MS');
  static final Estado MG = Estado._('Minas Gerais', 'MG');
  static final Estado PA = Estado._('Pará', 'PA');
  static final Estado PB = Estado._('Paraíba', 'PB');
  static final Estado PR = Estado._('Paraná', 'PR');
  static final Estado PE = Estado._('Pernambuco', 'PE');
  static final Estado PI = Estado._('Piauí', 'PI');
  static final Estado RJ = Estado._('Rio de Janeiro', 'RJ');
  static final Estado RN = Estado._('Rio Grande do Norte', 'RN');
  static final Estado RS = Estado._('Rio Grande do Sul', 'RS');
  static final Estado RO = Estado._('Rondônia', 'RO');
  static final Estado RR = Estado._('Roraima', 'RR');
  static final Estado SC = Estado._('Santa Catarina', 'SC');
  static final Estado SP = Estado._('São Paulo', 'SP');
  static final Estado SE = Estado._('Sergipe', 'SE');
  static final Estado TO = Estado._('Tocantins', 'TO');

  String nome, sigla;

  /// Construtor privado para evitar que instâncias de estado sejam
  /// criadas fora deste módulo
  Estado._(this.nome, this.sigla);

  static List<Estado> values() {
    return [
      AC,
      AL,
      AP,
      AM,
      BA,
      CE,
      DF,
      ES,
      GO,
      MA,
      MT,
      MS,
      MG,
      PA,
      PB,
      PR,
      PE,
      PI,
      RJ,
      RN,
      RS,
      RO,
      RR,
      SC,
      SP,
      SE,
      TO
    ];
  }

  static Estado getByNome(nome) {
    return values().firstWhere((element) => element.nome == nome);
  }

  static Estado getBySigla(sigla) {
    return values().firstWhere((element) => element.sigla == sigla);
  }

  static Estado getByIndex(idx) {
    return values()[idx];
  }
}

class Endereco {
  int id;
  String logradouro, numero, bairro, cidade, cep;
  Estado estado = Estado.AC;

  Endereco(
      {this.logradouro,
      this.numero,
      this.bairro,
      this.cidade,
      this.estado,
      this.cep});

  //TIP observe que o estado é retornado pela sua sigla, uma vez que na
  //conversão do objeto para um objeto JSON, o que é salvo é a sigla. Veja que
  //no método toJson o que é incluído no mapa é a sigla.
  Endereco.fromJson(Map<String, dynamic> json)
      : logradouro = json['logradouro'],
        numero = json['numero'],
        bairro = json['bairro'],
        cidade = json['cidade'],
        estado = Estado.getBySigla(json['estado']),
        cep = json['cep'];

  //TIP observe que não é necessário salvar todos os dados do estado, apenas
  //a sua sigla. No construtor, basta pegar a sigla salva, e recuperar o estado
  //equivalente pela sigla.
  Map<String, dynamic> toJson() => {
        'logradouro': logradouro,
        'numero': numero,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado.sigla,
        'cep': cep
      };
}

abstract class Pessoa {
  int id;
  String cpf, nome;
  Endereco endereco;
  Pessoa({this.id, this.cpf, this.nome, this.endereco}) {
    if (endereco == null) endereco = Endereco();
  }

  //TIP construtor 'fromJson' permite a construção de um objeto a partir de um
  //mapa que representa um objeto JSON.
  //Para maiores informações sobre JSON consulte:
  //https://pt.wikipedia.org/wiki/JSON
  //
  //Observe que ao criar a pessoa, a criação do objeto endereco é delegada para
  //a classe Endereco, seguindo o princípio do encapsulamento.
  Pessoa.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        cpf = json['cpf'],
        nome = json['nome'],
        endereco = Endereco.fromJson(json['endereco']);

  //TIP este método converte o objeto atual para um mapa que representa um
  //objeto JSON. Observe que a conversão do objeto endereço é delegada para
  //o próprio objeto, seguindo o princípio do encapsulamento.
  Map<String, dynamic> toJson() => {
        'id': id,
        'cpf': cpf,
        'nome': nome,
        'endereco': endereco.toJson(),
      };
}

var pessoaController = PessoaController();

class PessoaController {
  var _nextId = 1;
  var _pessoas = <Pessoa>[];

  List<Pessoa> getAll() {
    return _pessoas;
  }

  Pessoa getByCPF(String cpf) {
    for (Pessoa p in _pessoas) {
      if (p.cpf == cpf) return p;
    }
    return null;
  }

  void _validateOnSave(pessoa) {
    Pessoa p = getByCPF(pessoa.cpf);
    if (p != null && p.id != pessoa.id)
      throw Exception('Já existe uma pessoa com o cpf ${pessoa.cpf}.');
  }

  Pessoa save(pessoa) {
    _validateOnSave(pessoa);
    //Lógica:
    //1) se a pessoa não possui id, está inserindo.
    //2) se a pessoa tem id e o id não está na lista do banco, está inserindo
    //3) caso contrário, está alterando.
    //
    //No caso 2, altera o próximo ID para o máximo entre o id da pessoa
    //e o atual;
    //
    //No caso 3, substitui a pessoa da lista, na mesma posição.
    if (pessoa.id == null) {
      pessoa.id = _nextId++;
      pessoa.endereco.id = pessoa.id;
      _pessoas.add(pessoa);
    } else {
      var idx = _pessoas.indexWhere((element) => element.id == pessoa.id);
      if (idx == -1) {
        _pessoas.add(pessoa);
        _nextId = pessoa.id > _nextId ? pessoa.id + 1 : _nextId + 1;
      } else {
        _pessoas.setRange(idx, idx + 1, [pessoa]);
      }
    }
    return pessoa;
  }

  bool remove(pessoa) {
    var result = false;
    var idx = _pessoas.indexWhere((element) => element.id == pessoa.id);
    if (idx != -1) {
      result = true;
      _pessoas.removeAt(idx);
    }
    return result;
  }
}

class ListPessoaPage extends StatefulWidget {
  @override
  ListPessoaPageState createState() => ListPessoaPageState();
}

class ListPessoaPageState extends State<ListPessoaPage> {
  List<Pessoa> _pessoas = pessoaController.getAll();

  @override
  Widget build(BuildContext context) {
    return DsiScaffold(
      title: 'Listagem de Pessoas',
      body: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _pessoas.length,
        itemBuilder: _buildListTilePessoa,
      ),
    );
  }

  Widget _buildListTilePessoa(context, index) {
    var pessoa = _pessoas[index];
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          pessoaController.remove(pessoa);
          _pessoas.remove(index);
        });
        dsiHelper.showMessage(
          context: context,
          message: '${pessoa.nome} foi removido.',
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
        title: Text(pessoa.nome),
        subtitle:
            Text('${pessoa.endereco.cidade} - ${pessoa.endereco.estado.sigla}'),
        onTap: () =>
            dsiHelper.go(context, "/maintain_pessoa", arguments: pessoa),
      ),
    );
  }
}

class MaintainPessoaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Pessoa pessoa = dsiHelper.getRouteArgs(context);
    //Não existe inserção de Pessoa. Apenas de aluno ou professor.
    return DsiBasicFormPage(
      title: 'Pessoa',
      onSave: () {
        pessoaController.save(pessoa);
        dsiHelper.go(context, '/list_pessoa');
      },
      body: MaintainPessoaBody(pessoa),
    );
  }
}

class MaintainPessoaBody extends StatelessWidget {
  final Pessoa _pessoa;
  MaintainPessoaBody(this._pessoa);
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: Constants.boxSmallHeight.height,
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'CPF*'),
          validator: (String value) {
            return value.isEmpty ? 'CPF inválido.' : null;
          },
          initialValue: _pessoa.cpf,
          onSaved: (newValue) => _pessoa.cpf = newValue,
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(labelText: 'Nome*'),
          validator: (String value) {
            return value.isEmpty ? 'Nome inválido.' : null;
          },
          initialValue: _pessoa.nome,
          onSaved: (newValue) => _pessoa.nome = newValue,
        ),
        _buildEndereco(context, _pessoa.endereco),
      ],
    );
  }

  _buildEndereco(context, Endereco endereco) {
    //TIP a classe [BorderSide] é usada na renderização da borda do container.
    //por padrão, a largura da borda é definida como 1.0. Assim, é preciso dar
    //uma margem de 1.0 para ter espaço de renderizar a borda.

    //TIP o component Stack é usado para sobrepor componentes. Ele é bastante
    //usado para a criação de uma interface mais amigável. Neste caso, estamos
    //sobrepondo um label sobre a borda de um container. Note que o label tem
    //que ser incluído depois, senão a borda passaria por cima do label e não
    //o inverso.
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            top: Constants.spaceSmall,
            bottom: Constants.spaceSmall,
          ),
          padding: Constants.insetsMedium,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Theme.of(context).textTheme.caption.color,
            ),
            borderRadius: Constants.defaultBorderRadius,
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: Constants.boxSmallHeight.height,
            children: _buildEnderecoFields(context, endereco),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            margin: EdgeInsets.only(left: Constants.spaceSmall),
            padding: EdgeInsets.only(
              left: Constants.spaceSmall,
              right: Constants.spaceSmall,
            ),
            color: Colors.white,
            child: Text(
              'Endereço*',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ),
      ],
    );
  }

  _buildEnderecoFields(context, Endereco endereco) {
    //TIP observe o uso do DropdownButtonFormField para o campo de estado.
    //este componente precisa tanto do onChanged quanto do onSaved. O onChanged
    //não precisa de nenhuma implementação específica no nosso caso, já que a
    //alteração só precisa ocorrer quando o usuário salva o formulário.
    return <Widget>[
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(labelText: 'Logradouro*'),
        validator: (String value) {
          return value.isEmpty ? 'Logradouro inválido.' : null;
        },
        initialValue: endereco.logradouro,
        onSaved: (newValue) => endereco.logradouro = newValue,
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(labelText: 'Número'),
        initialValue: endereco.numero,
        onSaved: (newValue) => endereco.numero = newValue,
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(labelText: 'Bairro*'),
        validator: (String value) {
          return value.isEmpty ? 'Bairro inválido.' : null;
        },
        initialValue: endereco.bairro,
        onSaved: (newValue) => endereco.bairro = newValue,
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(labelText: 'Cidade*'),
        validator: (String value) {
          return value.isEmpty ? 'Cidade inválida.' : null;
        },
        initialValue: endereco.cidade,
        onSaved: (newValue) => endereco.cidade = newValue,
      ),
      DropdownButtonFormField(
        decoration: const InputDecoration(labelText: 'Estado*'),
        items: Estado.values().map<DropdownMenuItem<Estado>>((estado) {
          return DropdownMenuItem<Estado>(
            value: estado,
            child: Text(estado.nome),
          );
        }).toList(),
        value: endereco.estado,
        onChanged: (value) {},
        onSaved: (newValue) => endereco.estado = newValue,
      ),
      TextFormField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'CEP*'),
        validator: (String value) {
          return value.isEmpty ? 'CEP inválido.' : null;
        },
        initialValue: endereco.cep,
        onSaved: (newValue) => endereco.cep = newValue,
      ),
    ];
  }
}
