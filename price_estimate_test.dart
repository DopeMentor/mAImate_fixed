import 'package:flutter/material.dart';
import 'package:maimate_fixed/services/price_estimate_service.dart';

class PriceEstimateTest extends StatelessWidget {
  const PriceEstimateTest({super.key});

  Future<void> _getEstimate(BuildContext context) async {
    try {
      final result = await PriceEstimateService.getPriceEstimate(
        location: 'kaleva',
        size: 72.0,
        rooms: 3,
        balcony: true,
      );

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Hinta-arvio'),
          content: Text(
            '''
Sijainti: ${result['location']}
Koko: ${result['size']} m²
Huoneet: ${result['rooms']}
Parveke: ${result['balcony']}
Hinta/m²: ${result['pricePerSqm']} €
Kerroin: ${result['adjustmentFactor']}
Arvio

