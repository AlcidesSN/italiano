class Publicacao {
  const Publicacao(this.id, this.titulo);
  final int id;
  final String titulo;

  factory Publicacao.fromJson(Map<String,dynamic> json){
    final id = json['id'];
    final titulo  = json['title'];

    if(id is! int || titulo is! String){
      throw const FormatException("Publicação Invalida");
    }
    return Publicacao(id, titulo);
  }
}