class SparePart {
  final int id;
  final int sellerId;
  final String title;
  final String description;
  final int price;
  final String type;
  final String make;
  final String model;
  final String origin;
  final String condition;
  final String fuel;
  final int year;
  final List<String> imageUrls;

  SparePart({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    required this.make,
    required this.model,
    required this.origin,
    required this.condition,
    required this.fuel,
    required this.year,
    required this.imageUrls,
  });

  factory SparePart.fromJson(Map<String, dynamic> json) {
    return SparePart(
      id: json['sparePartId'],
      sellerId: json['sellerId'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      type: json['type'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      origin: json['origin'] ?? '',
      condition: json['condition'] ?? '',
      fuel: json['fuel'] ?? '',
      year: json['year'] ?? 0,
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
    );
  }
}
