import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/room_selection_controller.dart';

class RoomSelectionView extends GetView<RoomSelectionController> {
  const RoomSelectionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RoomSelectionView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RoomSelectionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
