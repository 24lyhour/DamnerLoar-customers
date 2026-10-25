import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/package_controller.dart';

class PackageView extends GetView<PackageController> {
  const PackageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PackageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PackageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
