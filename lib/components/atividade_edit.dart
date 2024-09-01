import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../handlers/atividade_handler.dart';
import '../model/atividade.dart';

class AtividadeEdit extends StatefulWidget {
  final Atividade atividade;

  const AtividadeEdit({super.key, required this.atividade});

  @override
  AtividadeEditState createState() => AtividadeEditState();
}

class AtividadeEditState extends State<AtividadeEdit> {
  late TextEditingController atividadeTituloController;
  late TextEditingController atividadeDescricaoController;
  late Prioridade prioridadeSel;
  final _formKey = GlobalKey<FormState>(); // Chave para o formulário

  @override
  void initState() {
    super.initState();
    atividadeTituloController = TextEditingController(text: widget.atividade.titulo);
    atividadeDescricaoController = TextEditingController(text: widget.atividade.descricao);
    prioridadeSel = widget.atividade.prioridade;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Atividade')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Associar a chave do formulário
          child: Column(
            children: [
              TextFormField(
                controller: atividadeTituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O título não pode estar vazio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: atividadeDescricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A descrição não pode estar vazia';
                  }
                  return null;
                },
              ),
              DropdownButton<Prioridade>(
                value: prioridadeSel,
                onChanged: (Prioridade? novaPrioridade) {
                  if (novaPrioridade != null) {
                    setState(() {
                      prioridadeSel = novaPrioridade;
                    });
                  }
                },
                items: Prioridade.values.map((Prioridade prioridade) {
                  return DropdownMenuItem<Prioridade>(
                    value: prioridade,
                    child: Text(_toTitleCase(prioridade.toString().split('.').last)),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Se o formulário for válido, atualize a atividade
                    final novoTitulo = atividadeTituloController.text;
                    final novaDescricao = atividadeDescricaoController.text;
                    Provider.of<AtividadeHandler>(context, listen: false)
                        .atualizarAtividade(
                      widget.atividade.id,
                      novoTitulo,
                      novaDescricao,
                      prioridadeSel,
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _toTitleCase(String str) {
    return str.toLowerCase().split(' ').map((word) {
      return word.substring(0, 1).toUpperCase() + word.substring(1);
    }).join(' ');
  }
}