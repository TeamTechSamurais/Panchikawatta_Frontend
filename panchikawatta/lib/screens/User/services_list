import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:panchikawatta/models/service.dart';
import 'package:panchikawatta/screens/User/service_screen.dart';

class ServicesList extends StatelessWidget {
  final Future<List<Service>> services;

  const ServicesList({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Service>>(
      future: services,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Services found'));
        } else {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) {
                var service = snapshot.data![i];
                print(
                    'Service ID: ${service.id}'); // Debugging: Print service ID

                final isBase64 = service.imageUrl.startsWith('/9j');
                final imageWidget = isBase64
                    ? Image.memory(
                        base64Decode(service.imageUrl),
                        height: 65,
                        width: 75,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/no_image.png',
                            height: 73,
                            width: 81,
                          );
                        },
                      )
                    : Image.network(
                        service.imageUrl,
                        height: 65,
                        width: 75,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/no_image.png',
                            height: 73,
                            width: 81,
                          );
                        },
                      );

                return InkWell(
                  onTap: () {
                    print('Tapped service ID: ${service.id}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ServiceScreen(serviceId: service.id)),
                    );
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 15, right: 10, left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xffF7F7F7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        imageWidget,
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                service.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                service.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Rs. ${service.price}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}