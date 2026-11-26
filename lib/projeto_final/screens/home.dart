import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../favorites_provider.dart';
import '../services/recipe_service.dart';
import '../widgets/app_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saborê'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant, size: 80, color: Colors.orange),
            const SizedBox(height: 24),
            const Text(
              'Saborê',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Descubra receitas deliciosas',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 220,
              child: FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecipeListScreen()),
                ),
                icon: const Icon(Icons.list),
                label: const Text('Ver receitas'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 220,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecipeSearchScreen()),
                ),
                icon: const Icon(Icons.search),
                label: const Text('Pesquisar receitas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final RecipeService _service = RecipeService();
  late Future<List<Map<String, dynamic>>> _receitas;
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    if (_carregando) return;
    setState(() => _carregando = true);
    _receitas = _service.listRecipes();
    try {
      await _receitas;
    } catch (_) {}
    if (mounted) setState(() => _carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _receitas,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const AppLoading();
          }
          if (snapshot.hasError) {
            return AppError(
              message: _erroMensagem(snapshot.error),
              onRetry: _carregar,
            );
          }
          final itens = snapshot.data ?? <Map<String, dynamic>>[];
          if (itens.isEmpty) {
            return const AppEmpty(message: 'Nenhuma receita encontrada');
          }
          return ListView.builder(
            itemCount: itens.length,
            itemBuilder: (_, i) {
              final receita = itens[i];
              return RecipeCard(
                recipe: receita,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(recipe: receita),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _erroMensagem(dynamic error) {
    final msg = error.toString();
    if (msg.contains('HTTP') || msg.contains('SocketException')) {
      return 'Falha de rede ao carregar receitas. Verifique sua conexão.';
    }
    if (error is FormatException) {
      return 'Dados recebidos estão incompatíveis.';
    }
    return 'Erro inesperado. Tente novamente.';
  }
}

class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({super.key});

  @override
  State<RecipeSearchScreen> createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final RecipeService _service = RecipeService();
  final TextEditingController _controller = TextEditingController();
  Future<List<Map<String, dynamic>>>? _resultado;
  bool _carregando = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pesquisar() async {
    final q = _controller.text.trim();
    if (q.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um nome para pesquisar')),
      );
      return;
    }
    if (_carregando) return;
    setState(() => _carregando = true);
    _resultado = _service.searchRecipes(q);
    try {
      await _resultado;
    } catch (_) {}
    if (mounted) setState(() => _carregando = false);
  }

  void _limpar() {
    _controller.clear();
    setState(() => _resultado = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar receitas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Nome da receita',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _limpar,
                      )
                    : null,
              ),
              onSubmitted: (_) => _pesquisar(),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _pesquisar,
              child: const Text('Pesquisar'),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _resultado == null
                ? const Center(child: Text('Digite o nome de uma receita'))
                : FutureBuilder<List<Map<String, dynamic>>>(
                    future: _resultado!,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const AppLoading();
                      }
                      if (snapshot.hasError) {
                        return AppError(
                          message: _erroMensagem(snapshot.error),
                          onRetry: _pesquisar,
                        );
                      }
                      final itens = snapshot.data ?? <Map<String, dynamic>>[];
                      if (itens.isEmpty) {
                        return const AppEmpty(
                          message: 'Nenhuma receita encontrada com esse nome',
                        );
                      }
                      return ListView.builder(
                        itemCount: itens.length,
                        itemBuilder: (_, i) {
                          final receita = itens[i];
                          return RecipeCard(
                            recipe: receita,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RecipeDetailScreen(recipe: receita),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _erroMensagem(dynamic error) {
    final msg = error.toString();
    if (msg.contains('HTTP') || msg.contains('SocketException')) {
      return 'Falha de rede ao pesquisar. Verifique sua conexão.';
    }
    if (error is FormatException) {
      return 'Dados recebidos estão incompatíveis.';
    }
    return 'Erro inesperado. Tente novamente.';
  }
}

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final image = recipe['image'] is String && recipe['image'] != null
        ? recipe['image'] as String
        : '';
    final name = recipe['name'] is String ? recipe['name'] as String : 'Sem nome';
    final ingredients = recipe['ingredients'] is List
        ? List<String>.from(recipe['ingredients'].whereType<String>())
        : <String>[];
    final instructions = recipe['instructions'] is List
        ? List<String>.from(recipe['instructions'].whereType<String>())
        : <String>[];
    final prepTime = recipe['prepTimeMinutes'] is int
        ? recipe['prepTimeMinutes'] as int
        : null;
    final cookTime = recipe['cookTimeMinutes'] is int
        ? recipe['cookTimeMinutes'] as int
        : null;
    final servings = recipe['servings'] is int ? recipe['servings'] as int : null;
    final rating = recipe['rating'] is num
        ? (recipe['rating'] as num).toDouble()
        : null;
    final mealType = recipe['mealType'] is List
        ? List<String>.from(recipe['mealType'].whereType<String>())
        : <String>[];
    final totalTimeMinutes =
        prepTime == null && cookTime == null ? null : (prepTime ?? 0) + (cookTime ?? 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoritos, _) {
              final id = recipe['id'] is int ? recipe['id'] as int : 0;
              final isFavorite = favoritos.isFavorite(id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () => favoritos.toggle(id, recipe),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image.isNotEmpty)
              Image.network(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.restaurant, size: 48, color: Colors.grey),
                  ),
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              )
            else
              Container(
                height: 200,
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(Icons.restaurant, size: 48, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (totalTimeMinutes != null)
              Text(
                'Tempo total: $totalTimeMinutes min',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            if (servings != null)
              Text(
                'Porções: $servings',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            if (rating != null)
              Text(
                'Avaliação: ${rating.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            if (mealType.isNotEmpty)
              Text(
                'Tipo: ${mealType.join(', ')}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            const SizedBox(height: 24),
            const Text(
              'Ingredientes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (ingredients.isEmpty)
              const Text('Sem ingredientes listados.')
            else
              ...ingredients.map(
                (ing) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('• $ing'),
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              'Instruções',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (instructions.isEmpty)
              const Text('Sem instruções disponíveis.')
            else
              ...List.generate(instructions.length, (i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('${i + 1}. ${instructions[i]}'),
                  )),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritos = context.watch<FavoritesProvider>();
    final itens = favoritos.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: itens.isEmpty
          ? const AppEmpty(message: 'Nenhuma receita favoritada ainda')
          : ListView.builder(
              itemCount: itens.length,
              itemBuilder: (_, i) {
                final receita = itens[i];
                final name = receita['name'] is String
                    ? receita['name'] as String
                    : 'Sem nome';
                return ListTile(
                  title: Text(name),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(recipe: receita),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
