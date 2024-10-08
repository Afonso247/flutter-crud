import 'package:app_flutter/model/atividade.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../handlers/atividade_handler.dart';
import '../components/atividade_edit.dart';

class HomeAtividade extends StatefulWidget {
  const HomeAtividade({super.key});

  @override
  _HomeAtividadeState createState() => _HomeAtividadeState();
}

class _HomeAtividadeState extends State<HomeAtividade> {
  Prioridade prioridadeSel = Prioridade.baixa; // Estado para o valor do dropdown

  @override
  Widget build(BuildContext context) {
    final atividadeHandler = Provider.of<AtividadeHandler>(context);
    final atividades = atividadeHandler.atividades;

    return Scaffold(
      appBar: AppBar(title: const Text('Atividade Manager')),
      body: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final atividade = atividades.removeAt(oldIndex);
            atividades.insert(newIndex, atividade);
          });
        },
        children: <Widget>[
          for (int index = 0; index < atividades.length; index++)
            Padding(
              key: ValueKey(atividades[index].id),
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Container(
                color: _getPrioridadeColor(atividades[index].prioridade),
                child: Opacity(
                  opacity: atividades[index].status ? 0.5 : 1.0,
                  child: ListTile(
                    leading: _getCategoriaIcon(atividades[index].categoria),
                    title: Text(
                      atividades[index].titulo,
                      style: TextStyle(
                        decoration: atividades[index].status ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          atividades[index].descricao,
                          style: TextStyle(
                            decoration: atividades[index].status ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        Text(
                          'Categoria: ${_toTitleCase(atividades[index].categoria.toString().split('.').last)}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AtividadeEdit(atividade: atividades[index]),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: atividades[index].status ? const Icon(Icons.check_circle) : const Icon(Icons.check),
                          onPressed: () => atividadeHandler.atualizarAtividadeStatus(atividades[index].id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => atividadeHandler.removerAtividade(atividades[index].id),
                        ),
                      ],
                    ),
                  ),
                )
              ),
            ),
        ],
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

  Widget _getCategoriaIcon(Categoria categoria) {
    IconData iconData;
    switch (categoria) {
      case Categoria.trabalho:
        iconData = Icons.work;
        break;
      case Categoria.estudo:
        iconData = Icons.school;
        break;
      case Categoria.lazer:
        iconData = Icons.beach_access;
        break;
      case Categoria.saude:
        iconData = Icons.favorite;
        break;
      case Categoria.outros:
      default:
        iconData = Icons.category;
        break;
    }
    return Icon(iconData);
  }

  void _abrirAddAtividadeDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final tituloAtividadeController = TextEditingController();
    final descricaoAtividadeController = TextEditingController();
    Prioridade prioridadeSel = Prioridade.baixa;
    Categoria categoriaSel = Categoria.outros;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Adicionar Atividade'),
              content: Form(
                key: _formKey, // Chave para o formulário
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: tituloAtividadeController,
                      decoration: const InputDecoration(labelText: 'Título'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O título não pode estar vazio';
                        }
                        return null;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(15),
                      ],
                    ),
                    TextFormField(
                      controller: descricaoAtividadeController,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'A descrição não pode estar vazia';
                        }
                        return null;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(100),
                      ],
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
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        const Text(
                          'Categoria',
                          style: TextStyle(fontSize: 16),
                        ),
                        DropdownButton<Categoria>(
                          value: categoriaSel,
                          onChanged: (Categoria? novaCategoria) {
                            if (novaCategoria != null) {
                              setState(() {
                                categoriaSel = novaCategoria;
                              });
                            }
                          },
                          items: Categoria.values.map((Categoria categoria) {
                            return DropdownMenuItem<Categoria>(
                              value: categoria,
                              child: Text(_toTitleCase(categoria.toString().split('.').last)),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Se o formulário for válido, adicione a atividade
                      final titulo = tituloAtividadeController.text;
                      final descricao = descricaoAtividadeController.text;

                      Provider.of<AtividadeHandler>(context, listen: false).addAtividade(
                        titulo,
                        descricao,
                        prioridadeSel,
                        categoriaSel,
                      );

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            );
          },
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