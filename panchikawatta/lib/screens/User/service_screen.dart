import 'package:flutter/material.dart';
import 'package:panchikawatta/models/service.dart';
import 'package:panchikawatta/services/get_api_services.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceScreen extends StatefulWidget {
  final int serviceId;

  const ServiceScreen({Key? key, required this.serviceId}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late Future<Service> futureService;
  final double _padding = 20.0;

  @override
  void initState() {
    super.initState();
    print('ServiceScreen serviceId: ${widget.serviceId}');
    futureService = GetApiService().getServiceById(widget.serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_rounded,
              size: 30, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Details",
          style: TextStyle(
              color: Color(0xFFFF5C01),
              fontSize: 28,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: FutureBuilder<Service>(
        future: futureService,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Service not found'));
          } else {
            var service = snapshot.data!;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: _padding),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      height: 270,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Image.network(
                        service.imageUrls.isNotEmpty
                            ? service.imageUrls[0]
                            : 'placeholder_image_url',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.grey, thickness: 1.5),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        service.title,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 30),
                      Text(
                        'Rs. ${service.price}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      const SizedBox(width: 100),
                      GestureDetector(
                        onTap: () async {
                          try {
                            String businessPhoneNo = await GetApiService()
                                .getBusinessPhoneNo(service.sellerId);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Call',
                                      style: TextStyle(
                                          color: Color(0xFFFF5C01),
                                          fontWeight: FontWeight.bold)),
                                  content: Text(businessPhoneNo,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20)),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel',
                                          style: TextStyle(
                                              color: Color(0xFFFF5C01))),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Call',
                                          style: TextStyle(
                                              color: Color(0xFFFF5C01))),
                                      onPressed: () async {
                                        final url = 'tel:$businessPhoneNo';
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } catch (e) {
                            print('Error fetching business phone number: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Error fetching phone number: $e')),
                            );
                          }
                        },
                        child: const Icon(Icons.call_rounded,
                            color: Color(0xFFFF5C01), size: 35),
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onTap: () async {
                          // Implement chat functionality similar to BuyScreen if required
                        },
                        child: const Icon(Icons.mail_rounded,
                            color: Color(0xFFFF5C01), size: 35),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                  const Divider(color: Colors.grey, thickness: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Description",
                              style: TextStyle(
                                  color: Color(0xFFFF5C01),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              service.description,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
