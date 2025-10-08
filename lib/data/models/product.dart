import 'dart:convert';

/// Modelo de domínio. Mantemos simples.
/// Em produção, você pode usar json_serializable.
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final bool favorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.favorite = false,
  });

  Product copyWith({bool? favorite}) =>
      Product(
        id: id,
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
        favorite: favorite ?? this.favorite,
      );

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map['id'] is int ? map['id'] : int.parse(map['id'].toString()),
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        price: (map['price'] as num?)?.toDouble() ?? 0.0,
        imageUrl: map['image'] ?? map['imageUrl'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'favorite': favorite,
      };

  static List<Product> listFromJson(String jsonStr) {
    final list = json.decode(jsonStr) as List<dynamic>;
    return list.map((e) => Product.fromMap(e)).toList();
  }
}
