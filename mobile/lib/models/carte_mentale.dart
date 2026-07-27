/// Modèle "CarteMentale" du diagramme de classes.
class CarteMentale {
  final int id;
  final String contenu;
  final String? image; // optionnel

  CarteMentale({required this.id, required this.contenu, this.image});

  factory CarteMentale.fromMap(Map<String, dynamic> map) {
    return CarteMentale(
      id: map['id'] as int,
      contenu: map['contenu'] as String,
      image: map['image'] as String?,
    );
  }
}
