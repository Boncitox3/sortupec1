import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceConfigScreen extends StatefulWidget {
  final Function(String category, String price, String capacity, String access) onAddPrice;

  const PriceConfigScreen({required this.onAddPrice, Key? key}) : super(key: key);

  @override
  PriceConfigScreenState createState() => PriceConfigScreenState();
}

class PriceConfigScreenState extends State<PriceConfigScreen> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _accessController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Precio nuevo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Categoría *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(
                labelText: 'Precio *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _capacityController,
              decoration: const InputDecoration(
                labelText: 'Aforo (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _accessController,
              decoration: const InputDecoration(
                labelText: 'Accesos (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onAddPrice(
                  _categoryController.text,
                  _priceController.text,
                  _capacityController.text,
                  _accessController.text,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('AÑADIR'),
            ),
          ],
        ),
      ),
    );
  }
}
