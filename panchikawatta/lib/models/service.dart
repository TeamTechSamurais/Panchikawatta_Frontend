class Service {
  final int id;
  final String title;
  final String description;
  final int price;
  final List<String> imageUrls;

  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrls,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      description: json['description'] ?? 'No description',
      price: json['price'] ?? 0,
      imageUrls: List<String>.from(json['imageUrls']),
    );
  }
}
