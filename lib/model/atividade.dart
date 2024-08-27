import 'package:uuid/uuid.dart';

class Atividade {
  final String id;
  String titulo;
  String descricao;
  bool status;

  Atividade({required this.titulo, required this.descricao, this.status = false}) : id = const Uuid().v4();
}
