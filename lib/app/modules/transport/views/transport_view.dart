import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/transport_controller.dart';

class TransportView extends GetView<TransportController> {
  const TransportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TransportView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TransportView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
