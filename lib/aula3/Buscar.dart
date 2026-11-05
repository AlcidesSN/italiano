import 'package:flutter/material.dart';

const _sections = [
  {'name': 'Pizzas', 'items': [
    {'name': 'Margherita', 'price': '\$12', 'desc': 'Tomato, mozzarella, basil'},
    {'name': 'Pepperoni', 'price': '\$14', 'desc': 'Pepperoni, mozzarella'},
    {'name': 'Hawaiian', 'price': '\$13', 'desc': 'Ham, pineapple, mozzarella'},
  ]},
  {'name': 'Sides', 'items': [
    {'name': 'Garlic Bread', 'price': '\$5', 'desc': 'With herb butter'},
    {'name': 'Caesar Salad', 'price': '\$8', 'desc': 'Romaine, parmesan, croutons'},
  ]},
  {'name': 'Drinks', 'items': [
    {'name': 'Cola', 'price': '\$3', 'desc': '330ml'},
    {'name': 'Lemonade', 'price': '\$4', 'desc': 'Fresh squeezed'},
  ]},
];

class Buscar extends StatefulWidget {
  const Buscar({super.key});

  @override
  State<Buscar> createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  final buscarController = TextEditingController();
  String termo = '';


  void limpar(){
    buscarController.clear();
    setState(() => termo = '');
  }

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final busca = termo.toLowerCase();

    final secoesFiltradas = _sections
        .map((section) {
      final itens = (section['items'] as List)
          .where((item) =>
          ((item['name'] as String).toLowerCase().contains(busca)) ||
          (item['desc'] as String).toLowerCase().contains(busca))
          .toList();
      return {'name': section['name'], 'items': itens};
    })
        .where((section) => (section['items'] as List).isNotEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar"),
      ),
      body: Column(
        children: [
          // Formulário fora da lista: aparece uma única vez
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  //controller: text,
                  decoration: InputDecoration(
                    labelText: "Nome do item",
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (valor) {
                    setState(() => termo = valor.trim());
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: secoesFiltradas.length,
              itemBuilder: (context, si) {
                final section = secoesFiltradas[si];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        section['name'] as String,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    ...(section['items'] as List).map((item) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(item['name'] as String),
                        subtitle: Text(item['desc'] as String),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item['price'] as String,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}