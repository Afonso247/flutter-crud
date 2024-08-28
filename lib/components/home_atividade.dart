import 'package:app_flutter/model/atividade.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../handlers/atividade_handler.dart';
import '../components/atividade_edit.dart';

class HomeAtividade extends StatelessWidget {
  const HomeAtividade({super.key});

  @override

  Widget build(BuildContext context) {
    final atividadeHandler = Provider.of<AtividadeHandler>(context);
    final atividades = atividadeHandler.atividades;

    return Scaffold(
      appBar: AppBar(title: const Text('Atividade Manager')),
      body: ListView.builder(
        itemCount: atividades.length,
        itemBuilder: (context, index) {
          final atividade = atividades[index];
          return Opacity(
            opacity: atividade.status ? 0.5 : 1.0,
            child: Container(
              color: _getPrioridadeColor(atividade.prioridade),
              child: ListTile(
                title: Text(
                  atividade.titulo,
                  style: TextStyle(
                    decoration: atividade.status ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(atividade.descricao),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AtividadeEdit(atividade: atividade),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: atividade.status ? const Icon(Icons.check_circle) : const Icon(Icons.check),
                      onPressed: () => atividadeHandler.atualizarAtividadeStatus(atividade.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => atividadeHandler.removerAtividade(atividade.id),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirAddAtividadeDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getPrioridadeColor(Prioridade prioridade) {
    switch (prioridade) {
      case Prioridade.urgente:
        return Colors.redAccent.shade100;
      case Prioridade.alta:
        return Colors.orangeAccent.shade100;
      case Prioridade.media:
        return Colors.yellowAccent.shade100;
      case Prioridade.baixa:
        return Colors.greenAccent.shade100;
      default:
        return Colors.white;
    }
  }

  void _abrirAddAtividadeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final tituloAtividadeController = TextEditingController();
        final descricaoAtividadeController = TextEditingController();
        Prioridade prioridadeSel = Prioridade.baixa;

        return AlertDialog(
          title: const Text('Adicionar Atividade'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloAtividadeController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: descricaoAtividadeController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  const Text(
                    'Prioridade',
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButton<Prioridade>(
                    value: prioridadeSel,
                    onChanged: (Prioridade? novaPrioridade) {
                      if (novaPrioridade != null) {
                        prioridadeSel = novaPrioridade;
                      }
                    },
                    items: Prioridade.values.map((Prioridade prioridade) {
                      return DropdownMenuItem<Prioridade>(
                        value: prioridade,
                        child: Text(_toTitleCase(prioridade.toString().split('.').last)),
                      );
                    }).toList(),
                  ),
                ],
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final titulo = tituloAtividadeController.text;
                final descricao = descricaoAtividadeController.text;

                if (titulo.isNotEmpty && descricao.isNotEmpty) {
                  Provider.of<AtividadeHandler>(context, listen: false).addAtividade(
                    titulo, 
                    descricao,
                    prioridadeSel
                    );
                }

                Navigator.of(context).pop();
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  String _toTitleCase(String str) {
    return str.toLowerCase().split(' ').map((word) {
      return word.substring(0, 1).toUpperCase() + word.substring(1);
    }).join(' ');
  }
}