import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/seat_selection_controller.dart';

class SeatSelectionView extends GetView<SeatSelectionController> {
  const SeatSelectionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SeatSelectionView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SeatSelectionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
