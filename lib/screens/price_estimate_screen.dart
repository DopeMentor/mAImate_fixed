import 'package:flutter/material.dart';
import '../services/price_estimate_service.dart';

class PriceEstimateScreen extends StatefulWidget {
  const PriceEstimateScreen({super.key});

  @override
  State<PriceEstimateScreen> createState() => _PriceEstimateScreenState();
}

class _PriceEstimateScreenState extends State<PriceEstimateScreen> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController roomsController = TextEditingController();
  bool balcony = false;

  String result = '';
  bool isLoading = false;

  void getEstimate() async {
    setState(() {
      isLoading = true;
      result = '';
    });

    try {
      final estimate = await PriceEstimateService.getPriceEstimate(
        location: locationController.text.trim(),
        size: double.tryParse(sizeController.text.trim()) ?? 0,
        rooms: int.tryParse(roomsController.text.trim()) ?? 0,
        balcony: balcony,
      );

      setState(() {
        result = 'Arvioitu hinta: ${estimate['estimatedPrice']} €\n\nSelitys: ${estimate['explanation']}';
      });
    } catch (e) {
      setState(() {
        result = 'Virhe: $e';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hinta-arvio')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Sijainti (esim. Kaleva)'),
            ),
            TextField(
              controller: sizeController,
              decoration: const InputDecoration(labelText: 'Koko m²'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: roomsController,
              decoration: const InputDecoration(labelText: 'Huoneiden lukumäärä'),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Checkbox(
                  value: balcony,
                  onChanged: (value) {
                    setState(() {
                      balcony = value ?? false;
                    });
                  },
                ),
                const Text('Parveke')
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : getEstimate,
              child: const Text('Laske arvio'),
            ),
            const SizedBox(height: 16),
            if (isLoading) const CircularProgressIndicator(),
            if (result.isNotEmpty) Text(result),
          ],
        ),
      ),
    );
  }
}

