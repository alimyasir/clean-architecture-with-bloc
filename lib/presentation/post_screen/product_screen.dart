import 'package:clean_architecture_with_bloc/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'bloc/product_bloc.dart';
import 'bloc/product_event.dart';
import 'bloc/product_state.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Set<int> _favorites = {};
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(LoadProductsEvent());
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFavorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      _favorites = storedFavorites.map(int.parse).toSet();
    });
  }

  Future<void> _toggleFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites.contains(productId)
          ? _favorites.remove(productId)
          : _favorites.add(productId);
    });
    await prefs.setStringList(
      'favorites',
      _favorites.map((id) => id.toString()).toList(),
    );
  }

  void _onRefresh() {
    context.read<PostBloc>().add(LoadProductsEvent());
  }

  List<Product> _filterProducts(List<Product> products) {
    if (_searchQuery.isEmpty) return products;
    return products
        .where((product) =>
            product.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Widget _buildShimmerItem(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      // Card styling now comes from cardTheme in AppTheme.dart
      child: Shimmer.fromColors(
        baseColor: colorScheme.surfaceVariant, // Using theme color
        highlightColor: colorScheme.onSurface.withOpacity(0.1), // Using theme color
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Container(color: colorScheme.surfaceVariant.withOpacity(0.5))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 14, color: colorScheme.surfaceVariant.withOpacity(0.5)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(height: 14, width: 60, color: colorScheme.surfaceVariant.withOpacity(0.5)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Catalog", style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary)), // AppBar title style from theme
      ),
      body: BlocBuilder<PostBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7, // Adjust as needed for your content
              ),
              itemCount: 6,
              itemBuilder: (ctx, __) => _buildShimmerItem(ctx),
            );
          }
          if (state is ProductLoaded) {
            final products = _filterProducts(state.products);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0), // Increased padding
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: textTheme.bodyLarge, // TextField text style from theme
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      // InputDecoration styling now primarily from inputDecorationTheme
                      prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    // Using DropdownButtonFormField for better integration with InputDecorationTheme
                    value: state.selectedCategory,
                    hint: Text('Filter by Category', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                    decoration: const InputDecoration(), // Uses inputDecorationTheme
                    items: [
                      DropdownMenuItem<String>(
                          value: null, child: Text('All Categories', style: textTheme.bodyMedium)),
                      ...state.categories.map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category, style: textTheme.bodyMedium),
                          )),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        context.read<PostBloc>().add(LoadProductsEvent());
                      } else {
                        context
                            .read<PostBloc>()
                            .add(FilterByCategoryEvent(value));
                      }
                    },
                    isExpanded: true,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => _onRefresh(),
                    color: colorScheme.primary, // RefreshIndicator color from theme
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12, // Spacing between cards
                        mainAxisSpacing: 12,  // Spacing between card rows
                        childAspectRatio: 0.7, // Adjust as needed
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final isFavorite = _favorites.contains(product.id);

                        return GestureDetector(
                          onTap: () => _toggleFavorite(product.id),
                          child: Card(
                            // Card styling now comes from cardTheme
                            // No need to set shape or elevation here explicitly
                            clipBehavior: Clip.antiAlias, // Ensures content respects card shape
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    product.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: colorScheme.onSurface.withOpacity(0.5),
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0), // Adjusted padding
                                  child: Text(
                                    product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600), // Using theme text style
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0), // Adjusted padding
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "\$${product.price.toStringAsFixed(2)}",
                                        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                                      ),
                                      AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        transitionBuilder:
                                            (child, animation) {
                                          return ScaleTransition(
                                              scale: animation, child: child);
                                        },
                                        child: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          key: ValueKey<bool>(isFavorite),
                                          color: isFavorite
                                              ? colorScheme.primary // Favorite color from theme
                                              : colorScheme.onSurface.withOpacity(0.6), // Default icon color from theme
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          if (state is ProductError) {
            return Center(child: Text("Error: ${state.message}", style: textTheme.bodyLarge?.copyWith(color: colorScheme.error)));
          }
          return Center(child: Text("No products found.", style: textTheme.bodyLarge));
        },
      ),
    );
  }
}
