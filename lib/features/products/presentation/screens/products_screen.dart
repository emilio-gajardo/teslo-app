import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_provider.dart';
import 'package:teslo_shop/features/products/presentation/widgets/widgets.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu( scaffoldKey: scaffoldKey ),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon( Icons.search_rounded)
          )
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon( Icons.add ),
        onPressed: () {},
      ),
    );
  }
}


class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);// infinite scroll
    ref.read(productsProvider.notifier).loadNextPage();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // infinite scroll
  void _scrollListener() {
    if ((scrollController.position.pixels + 400) >= scrollController.position.maxScrollExtent) {
      ref.read(productsProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {

    final productsState = ref.watch(productsProvider);

    Padding padding = Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,// columnas
        crossAxisSpacing: 35,
        mainAxisSpacing: 20,
        itemCount: productsState.products.length,// cantidad de registros/productos
        itemBuilder: (context, index) {
          final product = productsState.products[index];
          // return Text(product.title);
          return GestureDetector(
            onTap: () => context.push('/product/${product.id}'),
            child: ProductCard(product: product)
          );
        },
      ),
    );
    // const SizedBox(height: 25,);
    return padding;
  }
}