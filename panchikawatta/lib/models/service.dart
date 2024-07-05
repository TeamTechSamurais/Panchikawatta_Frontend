class Service {
  final int id;
  final String title;
  final String description;
  final int price;
  String imageUrl;

  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    String? imageUrl,
  }) : imageUrl = imageUrl ?? 'no_image.png';

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['serviceId'] ?? 0,
      title: json['title'] ?? 'Unknown',
      description: json['description'] ?? 'No description',
      price: json['price'] ?? 0,
      imageUrl: json['imageUrl'] ?? 'No image',
    );
  }
}
