import 'package:flutter/material.dart';

class CaseReportPage extends StatelessWidget {
  const CaseReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del caso de dengue'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Caso de dengue'),
      ),
    );
  }
}
