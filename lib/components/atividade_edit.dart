import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../handlers/atividade_handler.dart';
import '../model/atividade.dart';

class AtividadeEdit extends StatelessWidget {
  final Atividade atividade;

  const AtividadeEdit({super.key, required this.atividade});

  @override
  Widget build(BuildContext context) {
    final atividadeTituloController = TextEditingController(text: atividade.titulo);
    final atividadeDescricaoController = TextEditingController(text: atividade.descricao);

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Atividade')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: atividadeTituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: atividadeDescricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            DropdownButton<Prioridade>(
              value: atividade.prioridade,
              onChanged: (Prioridade? novaPrioridade) {
                if (novaPrioridade != null) {
                  atividade.prioridade = novaPrioridade;
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
                final novoTitulo = atividadeTituloController.text;
                final novaDescricao = atividadeDescricaoController.text;

                if (novoTitulo.isNotEmpty && novaDescricao.isNotEmpty) {
                  Provider.of<AtividadeHandler>(context, listen: false)
                    .atualizarAtividade(
                      atividade.id, 
                      novoTitulo, 
                      novaDescricao,
                      atividade.prioridade
                    );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
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