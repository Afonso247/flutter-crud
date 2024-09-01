import 'package:flutter/material.dart';
import '../model/atividade.dart';

class AtividadeHandler with ChangeNotifier {
  
  final List<Atividade> _atividades = [];

  List<Atividade> get atividades => _atividades;

  // Cria uma nova atividade
  void addAtividade(String titulo, String descricao, Prioridade prioridade) {
    _atividades.add(Atividade(
      titulo: titulo, 
      descricao: descricao,
      prioridade: prioridade,
    ));
    notifyListeners();
  }

  // Atualiza uma atividade
  void atualizarAtividade(String id, String titulo, String descricao, Prioridade prioridade) {
    final atividade = _atividades.firstWhere((atividade) => atividade.id == id);
    atividade.titulo = titulo;
    atividade.descricao = descricao;
    atividade.prioridade = prioridade;
    notifyListeners();
  }

  // Atualiza o status da atividade
  void atualizarAtividadeStatus(String id) {
    final atividade = _atividades.firstWhere((atividade) => atividade.id == id);
    atividade.status = !atividade.status;
    notifyListeners();
  }

  // Remove uma atividade
  void removerAtividade(String id) {
    _atividades.removeWhere((atividade) => atividade.id == id);
    notifyListeners();
  }

  // Reordena as atividades
  void reordenarAtividades(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1; // Ajusta o índice para a movimentação correta
    }
    final atividade = _atividades.removeAt(oldIndex); // Remove a atividade do índice antigo
    _atividades.insert(newIndex, atividade); // Insere a atividade no novo índice
    notifyListeners();
  }

}