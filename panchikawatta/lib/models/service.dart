class Service {
  final int id;
  String type;
  final int sellerId;
  final String title;
  final String description;
  final int price;
  final List<String> imageUrls;

  Service({
    required this.id,
    this.type = '',
    required this.sellerId,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrls,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['serviceId'],
      type: json['type'] ?? '',
      sellerId: json['sellerId'],
      title: json['title'] ?? 'Unknown',
      description: json['description'] ?? 'No description',
      price: json['price'] ?? 0,
      imageUrls:
          json['imageUrls'] != null ? List<String>.from(json['imageUrls']) : [],
    );
  }
}
