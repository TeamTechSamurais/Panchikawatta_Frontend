import 'package:flutter/material.dart';
import 'package:panchikawatta/models/sparepart.dart';
import 'package:panchikawatta/screens/User/buy_screen.dart';

class FilteredSparePartsScreen extends StatelessWidget {
  final List<SparePart> filteredSpareParts;

  const FilteredSparePartsScreen({Key? key, required this.filteredSpareParts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Filtered Spare Parts',
          style: TextStyle(
            color: Color(0xFFFF5C01),
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0), // Add padding here
        child: GridView.builder(
          itemCount: filteredSpareParts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, i) {
            var sparePart = filteredSpareParts[i];
            final imageWidget = sparePart.imageUrls.isNotEmpty
                ? Image.network(
                    sparePart.imageUrls[0],
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
                : Image.asset(
                    'assets/images/no_image.png',
                    height: 73,
                    width: 81,
                  );
            return InkWell(
              onTap: () {
                print('Tapped Sparepart ID: ${sparePart.id}');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuyScreen(sparePartId: sparePart.id),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 5, right: 5, left: 5),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 73,
                        width: 81,
                        child: imageWidget,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sparePart.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Rs. ${sparePart.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            sparePart.make,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
