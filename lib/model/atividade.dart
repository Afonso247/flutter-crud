import 'package:uuid/uuid.dart';

enum Prioridade { urgente, alta, media, baixa }

class Atividade {
  final String id;
  String titulo;
  String descricao;
  Prioridade prioridade;
  bool status;

  Atividade({
    required this.titulo, 
    required this.descricao,
    this.prioridade = Prioridade.baixa, 
    this.status = false
  }) : id = const Uuid().v4();
}
