class FoodModel {
  final String id;
  final String image;
  final String name;
  final double price;

  FoodModel({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
  });

  factory FoodModel.fromMap(Map<String, dynamic> map, String id) {
    return FoodModel(
      id: id,
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "image": image,
      "name": name,
      "price": price,
    };
  }
}
