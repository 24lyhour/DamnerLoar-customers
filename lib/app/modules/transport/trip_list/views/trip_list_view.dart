import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/trip_list_controller.dart';

class TripListView extends GetView<TripListController> {
  const TripListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TripListView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TripListView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
