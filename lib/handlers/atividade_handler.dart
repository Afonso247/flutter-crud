import 'package:flutter/material.dart';
import '../model/atividade.dart';

class AtividadeHandler with ChangeNotifier {
  
  final List<Atividade> _atividades = [];

  List<Atividade> get atividades => _atividades;

  // Cria uma nova atividade
  void addAtividade(String titulo, String descricao) {
    _atividades.add(Atividade(titulo: titulo, descricao: descricao));
    notifyListeners();
  }

  // Atualiza uma atividade
  void atualizarAtividade(String id, String titulo, String descricao) {
    final atividade = _atividades.firstWhere((atividade) => atividade.id == id);
    atividade.titulo = titulo;
    atividade.descricao = descricao;
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

}