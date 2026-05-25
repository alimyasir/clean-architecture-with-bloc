import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'bloc/product_bloc.dart';
import 'bloc/product_event.dart';
import 'bloc/product_state.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping Catalog',
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        // Only show snackbar when state becomes an error
        listenWhen: (previous, current) =>
            current is ProductError && previous is! ProductError,
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: colorScheme.error,
                  action: SnackBarAction(
                    label: 'Retry',
                    textColor: colorScheme.onError,
                    onPressed: () => context
                        .read<ProductBloc>()
                        .add(const LoadProductsEvent()),
                  ),
                ),
              );
          }
        },
        builder: (context, state) {
          // Dart 3 exhaustive switch — compiler catches missing cases
          return switch (state) {
            ProductInitial() => const SizedBox.shrink(),
            ProductLoading() => const _ShimmerGrid(),
            ProductLoaded() => _ProductContent(state: state),
            ProductError() => _ErrorView(message: state.message),
          };
        },
      ),
    );
  }
}

// ── Shimmer skeleton ─────────────────────────────────────────────────────────

class _ShimmerGrid extends StatelessWidget {
  const _ShimmerGrid();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Card(
        clipBehavior: Clip.antiAlias,
        child: Shimmer.fromColors(
          baseColor: colorScheme.surfaceContainerHighest,
          highlightColor: colorScheme.onSurface.withValues(alpha: 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: Container(color: colorScheme.surfaceContainerHighest)),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(height: 14, color: colorScheme.surfaceContainerHighest),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                    height: 14, width: 60, color: colorScheme.surfaceContainerHighest),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Loaded content ───────────────────────────────────────────────────────────

class _ProductContent extends StatefulWidget {
  final ProductLoaded state;

  const _ProductContent({required this.state});

  @override
  State<_ProductContent> createState() => _ProductContentState();
}

class _ProductContentState extends State<_ProductContent> {
  // Controller lives here only to support programmatic clear (X button).
  // All search logic lives in ProductBloc.
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.state.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final state = widget.state;

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: TextField(
            controller: _searchController,
            style: textTheme.bodyLarge,
            onChanged: (value) =>
                context.read<ProductBloc>().add(SearchProductsEvent(value)),
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon:
                  Icon(Icons.search, color: colorScheme.onSurfaceVariant),
              suffixIcon: state.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context
                            .read<ProductBloc>()
                            .add(const SearchProductsEvent(''));
                      },
                    )
                  : null,
            ),
          ),
        ),

        // Category filter
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: DropdownButtonFormField<String>(
            initialValue: state.selectedCategory,
            isExpanded: true,
            decoration: const InputDecoration(),
            hint: Text(
              'Filter by Category',
              style: textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text('All Categories', style: textTheme.bodyMedium),
              ),
              ...state.categories.map(
                (c) => DropdownMenuItem<String>(
                  value: c,
                  child: Text(c, style: textTheme.bodyMedium),
                ),
              ),
            ],
            // null → FilterByCategoryEvent(null) resets without API call
            onChanged: (value) =>
                context.read<ProductBloc>().add(FilterByCategoryEvent(value)),
          ),
        ),

        const SizedBox(height: 8),

        // Grid or empty state
        Expanded(
          child: RefreshIndicator(
            color: colorScheme.primary,
            onRefresh: () async =>
                context.read<ProductBloc>().add(const LoadProductsEvent()),
            child: state.products.isEmpty
                ? _EmptyState(searchQuery: state.searchQuery)
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      // Reads from BLoC state — single source of truth
                      final isFavorite = state.favorites.contains(product.id);

                      return GestureDetector(
                        onTap: () => context
                            .read<ProductBloc>()
                            .add(ToggleFavoriteEvent(product.id)),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
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
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      transitionBuilder: (child, animation) =>
                                          ScaleTransition(
                                              scale: animation, child: child),
                                      child: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        key: ValueKey<bool>(isFavorite),
                                        color: isFavorite
                                            ? colorScheme.primary
                                            : colorScheme.onSurface
                                                .withValues(alpha: 0.6),
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
}

// ── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String searchQuery;

  const _EmptyState({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off,
              size: 64, color: colorScheme.onSurface.withValues(alpha: 0.35)),
          const SizedBox(height: 16),
          Text(
            searchQuery.isEmpty
                ? 'No products found.'
                : 'No results for "$searchQuery".',
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Error view ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: textTheme.bodyLarge?.copyWith(color: colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context
                  .read<ProductBloc>()
                  .add(const LoadProductsEvent()),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
