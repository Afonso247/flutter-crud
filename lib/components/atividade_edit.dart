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
            ElevatedButton(
              onPressed: () {
                final novoTitulo = atividadeTituloController.text;
                final novaDescricao = atividadeDescricaoController.text;

                if (novoTitulo.isNotEmpty && novaDescricao.isNotEmpty) {
                  Provider.of<AtividadeHandler>(context, listen: false)
                    .atualizarAtividade(atividade.id, novoTitulo, novaDescricao);
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
}