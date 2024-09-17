import 'package:uuid/uuid.dart';

enum Prioridade { urgente, alta, media, baixa }
enum Categoria { trabalho, estudo, lazer, saude, outros }

class Atividade {
  final String id;
  String titulo;
  String descricao;
  Prioridade prioridade;
  Categoria categoria;
  bool status;

  Atividade({
    required this.titulo, 
    required this.descricao,
    this.prioridade = Prioridade.baixa, 
    this.categoria = Categoria.outros,
    this.status = false
  }) : id = const Uuid().v4();
}
