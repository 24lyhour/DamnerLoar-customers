import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/locations_controller.dart';

class LocationsView extends GetView<LocationsController> {
  const LocationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocationsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LocationsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
