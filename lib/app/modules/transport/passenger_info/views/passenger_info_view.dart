import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/passenger_info_controller.dart';

class PassengerInfoView extends GetView<PassengerInfoController> {
  const PassengerInfoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PassengerInfoView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PassengerInfoView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
