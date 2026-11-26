# italiano

Aplicativo de receitas **Saborê** desenvolvido em Flutter.

## Descrição

O **Saborê** é um aplicativo móvel para listar, buscar e visualizar receitas, com possibilidade de marcar receitas como favoritas. Os dados são consumidos da API pública [DummyJSON](https://dummyjson.com/). O gerenciamento de estado é feito com o pacote `Provider`.

---

## Técnicas e padrões de projeto utilizados

### Gerenciamento de estado com Provider
A aplicação utiliza o pacote `provider` para gerenciar o estado global dos favoritos. A classe `FavoritesProvider` estende `ChangeNotifier`, permitindo que qualquer widget que observe o provedor seja reconstruído automaticamente quando a lista de favoritos é alterada (adicionar ou remover receita). Isso evita a necessidade de passar callbacks manualmente entre telas.

### Consumo de API REST com http
O pacote `http` é usado para fazer requisições GET à API do DummyJSON. O serviço `RecipeService` encapsula toda a lógica de comunicação, incluindo:
- Montagem de URLs com parâmetros de consulta (`/recipes/search?q=...`)
- Controle de tempo limite de requisição (`timeout`)
- Validação de código de status HTTP (`200`)
- Decodificação de corpos JSON com `dart:convert`
- Tratamento de exceções de rede e formato inválido

### Arquitetura por camadas (simplificada)
O código está organizado separando responsabilidades:
- **Camada de serviço**: `recipe_service.dart` — lida apenas com requisições HTTP e parsing de dados.
- **Camada de estado**: `favorites_provider.dart` — gerencia o estado dos favoritos.
- **Camada de interface**: `screens/home.dart` e `widgets/app_widgets.dart` — contêm os widgets e telas que exibem os dados ao usuário.

### Widgets reutilizáveis
Componentes visuais repetitivos (indicador de carregamento, tela de erro, tela vazia, card de receita) estão centralizados em `app_widgets.dart`, facilitando a manutenção e garantindo consistência visual.

### Tratamento de estados de interface
A aplicação lida explicitamente com:
- **Carregamento**: `CircularProgressIndicator` enquanto aguarda resposta da API.
- **Erro**: mensagens amigáveis para falha de rede, dados incompatíveis ou erro genérico, com botão de tentar novamente.
- **Vazio**: mensagens quando não há receitas encontradas ou nenhum favorito adicionado.

---

## Dependências

Definidas em `pubspec.yaml`:

| Dependência | Versão | Uso |
|-------------|--------|-----|
| `flutter` | SDK do Flutter | Framework principal para interface multiplataforma |
| `cupertino_icons` | `^1.0.8` | Ícones com estilo iOS |
| `http` | `^1.6.0` | Requisições HTTP REST à API DummyJSON |
| `provider` | `^6.1.2` | Gerenciamento de estado reativo |


SDK utilizado:
- **Dart SDK** `^3.13.5` (definido em `environment.sdk`)

---

## Estrutura da pasta `lib/projeto_final`

Todos os arquivos do projeto final estão organizados dentro de `lib/projeto_final`, divididos em pastas por responsabilidade.

## `main.dart`
**Ponto de entrada da aplicação.**

Responsável por iniciar o app Flutter com `runApp`. Configura o widget raiz `SaborApp`, que é um `StatelessWidget` contendo um `MaterialApp`. Dentro do `MaterialApp`, utiliza `ChangeNotifierProvider` para disponibilizar a instância de `FavoritesProvider` em toda a árvore de widgets, tornando o estado de favoritos acessível a qualquer tela. Define o título como "Saborê", o tema com esquema de cores baseado no laranja (`ColorScheme.fromSeed`) e Material Design 3, e define `HomeScreen` como a rota inicial (`home`). Desativa o banner de debug (`debugShowCheckedModeBanner: false`).

## `favorites_provider.dart`
**Gerenciador de estado dos favoritos.**

Classe `FavoritesProvider` que estende `ChangeNotifier`. Mantém um mapa privado (`_favoritos`) onde a chave é o ID da receita e o valor é o mapa de dados da receita. Oferece três membros principais:
- `isFavorite(int id)`: verifica se uma receita já está nos favoritos.
- `toggle(int id, Map<String, dynamic> receita)`: adiciona a receita aos favoritos se ainda não estiver, ou remove se já estiver. Após alterar o mapa, chama `notifyListeners()` para avisar todos os widgets que estão observando o provedor.
- `items`: getter que retorna a lista de todas as receitas favoritas armazenadas.

Essa abordagem permite que telas como `FavoritesScreen` e widgets como `RecipeCard` reajam automaticamente quando o usuário marca ou desmarca uma receita.

## `screens/home.dart`
**Contém todas as telas da aplicação.**

Esse arquivo concentra cinco classes de widget, cada uma responsável por uma tela diferente:

1. **`HomeScreen`** — Tela inicial. Exibe o logotipo/nome "Saborê", uma descrição curta e dois botões principais ("Ver receitas" e "Pesquisar receitas") que navegam para as respectivas telas. Possui um botão de favoritos na barra superior que abre a `FavoritesScreen`.

2. **`RecipeListScreen`** — Lista todas as receitas. É um `StatefulWidget` que usa `RecipeService` para carregar os dados de forma assíncrona. Utiliza um `FutureBuilder` para reconstruir a interface conforme o estado do futuro (carregando, erro ou dados prontos). Quando carregado, exibe uma `ListView.builder` com cards de receita (`RecipeCard`). Ao tocar em um card, navega para `RecipeDetailScreen`. Inclui tratamento de erros com mensagem amigável e botão de tentar novamente.

3. **`RecipeSearchScreen`** — Tela de busca. Possui um `TextField` controlado por `TextEditingController` para o usuário digitar o nome da receita. Ao submeter a busca, chama `RecipeService.searchRecipes` e exibe os resultados em uma lista. Exibe mensagens orientativas (digite um nome), estado vazio (nenhuma receita encontrada) e erro de rede. Inclui um ícone para limpar o campo de busca.

4. **`RecipeDetailScreen`** — Detalhes da receita. Recebe um mapa com os dados da receita e exibe imagem, nome, tempo total, porções, avaliação, tipo de refeição, lista de ingredientes e instruções numeradas. A imagem usa `Image.network` com `errorBuilder` e `loadingBuilder` para lidar com falhas e carregamento. Na barra superior, há um `Consumer<FavoritesProvider>` que exibe um botão de favorito (ícone cheio ou vazio) e permite alternar o estado ao pressionar.

5. **`FavoritesScreen`** — Lista de receitas favoritas. Usa `context.watch<FavoritesProvider>()` para reagir a mudanças na lista de favoritos. Exibe uma `ListView.builder` com os nomes das receitas favoritadas, permitindo navegar para os detalhes de cada uma. Mostra mensagem vazia quando nenhum favorito existe.

## `services/recipe_service.dart`
**Camada de serviço para consumo da API.**

Classe `RecipeService` que encapsula todas as requisições HTTP à API do DummyJSON (`dummyjson.com`). Define a URL base e um tempo limite de 10 segundos para as requisições. Três métodos principais:
- `listRecipes()`: faz GET para `/recipes`, valida o status 200, decodifica o JSON e retorna a lista de receitas contida na chave `"recipes"`.
- `searchRecipes(String query)`: faz GET para `/recipes/search` com parâmetro `q`, valida a resposta e retorna receitas filtradas pelo nome.
- `getRecipe(int id)`: faz GET para `/recipes/{id}` e retorna os dados completos de uma receita específica.

Cada método valida se o corpo da resposta é um mapa válido e se a lista de receitas é realmente uma lista, lançando `FormatException` ou `Exception` em caso de problemas. Isso permite que as telas tratem os erros de forma apropriada.

## `widgets/app_widgets.dart`
**Widgets reutilizáveis da interface.**

Agrupa componentes visuais usados por várias telas:

- **`AppLoading`**: widget simples que exibe um `CircularProgressIndicator` centralizado, usado enquanto dados estão sendo carregados.
- **`AppError`**: exibe um ícone de erro, uma mensagem informativa e um botão "Tentar novamente" que executa um callback fornecido pelo pai. Usado quando ocorre falha na requisição HTTP.
- **`AppEmpty`**: exibe um ícone e uma mensagem centralizada quando não há dados para mostrar (ex.: nenhuma receita encontrada ou nenhum favorito).
- **`RecipeCard`**: card visual usado nas listas de receitas. Exibe a imagem da receita em um `Stack` com um botão de favorito posicionado (`Positioned`) no canto superior direito. O botão consome o `FavoritesProvider` via `context.watch` para atualizar automaticamente quando o estado muda. Ao tocar no card, executa o callback `onTap` passado pelo pai. O nome da receita é exibido com limite de duas linhas e reticências (`TextOverflow.ellipsis`).

---

## Como executar

1. Certifique-se de ter o Flutter SDK instalado.
2. No diretório do projeto, instale as dependências:
   ```bash
   flutter pub get
   ```
3. Execute o aplicativo em um emulador ou dispositivo físico:
   ```bash
   flutter run
   ```

O aplicativo consome a API pública do DummyJSON para listar e buscar receitas, e permite marcar receitas como favoritas usando `Provider` para gerenciamento de estado.
