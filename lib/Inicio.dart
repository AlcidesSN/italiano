import 'package:flutter/material.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pizzaria Bella Massa"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho / boas-vindas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red),
              ),
              child: const Column(
                children: [
                  Icon(Icons.local_pizza, size: 64, color: Colors.red),
                  SizedBox(height: 12),
                  Text(
                    "Bem-vindo à Bella Massa!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "A melhor pizza artesanal da cidade, direto do forno a lenha.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Cardápio
            const Text(
              "Nossos Sabores",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.local_pizza, color: Colors.orange),
                SizedBox(width: 12),
                Expanded(child: Text("Margherita - molho, mussarela e manjericão")),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.local_pizza, color: Colors.orange),
                SizedBox(width: 12),
                Expanded(child: Text("Calabresa - calabresa fatiada e cebola")),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.local_pizza, color: Colors.orange),
                SizedBox(width: 12),
                Expanded(child: Text("Quatro Queijos - mussarela, provolone, parmesão e gorgonzola")),
              ],
            ),
            const SizedBox(height: 24),

            // Informações de contato
            const Text(
              "Informações",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 12),
                Expanded(child: Text("Rua das Pizzas, 123 - Londrina, PR")),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.access_time, color: Colors.red),
                SizedBox(width: 12),
                Expanded(child: Text("Terça a domingo, das 18h às 23h")),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.phone, color: Colors.red),
                SizedBox(width: 12),
                Expanded(child: Text("(43) 3333-0000")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}