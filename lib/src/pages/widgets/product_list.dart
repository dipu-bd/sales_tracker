import 'package:flutter/material.dart';
import 'package:sales_tracker/src/models/product.dart';
import 'package:sales_tracker/src/pages/widgets/product_item.dart';

class ProductListView extends StatefulWidget {
  final List<Product> products;

  ProductListView(this.products, {Key? key}) : super(key: key);

  @override
  State createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  String filter = '';
  final filterInput = TextEditingController();

  List<Product> get filteredProducts => filter.isEmpty
      ? widget.products
      : widget.products.where((product) {
          return product.name.toLowerCase().contains(filter);
        }).toList();

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return buildEmptyView();
    }

    List<Product> filteredProducts = filter.isEmpty
        ? widget.products
        : widget.products.where((product) {
            return product.name.toLowerCase().contains(filter);
          }).toList();

    return ListView.separated(
      itemCount: filteredProducts.length + 2,
      padding: EdgeInsets.only(bottom: 100, top: 0),
      separatorBuilder: (context, index) => Container(height: 5),
      itemBuilder: (context, index) {
        if (index == 0) {
          return buildFilterInput();
        } else if (index <= filteredProducts.length) {
          return ProductItemTile(filteredProducts[index - 1]);
        } else if (index == 1) {
          return buildEmptyFilter();
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildEmptyView() {
    return Container(
      padding: EdgeInsets.all(15),
      alignment: Alignment.center,
      child: Text(
        'Click on the + button below to add new items',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget buildEmptyFilter() {
    return Container(
      padding: EdgeInsets.all(15),
      alignment: Alignment.center,
      child: Text(
        'No items found containing "$filter"',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget buildFilterInput() {
    if (widget.products.length < 7) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.all(10),
      child: TextField(
        controller: filterInput,
        textInputAction: TextInputAction.search,
        onChanged: (text) {
          filter = text.trim().toLowerCase();
          if (mounted) setState(() {});
        },
        decoration: InputDecoration(
          isDense: true,
          fillColor: Colors.white,
          labelText: 'Filter Items',
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          prefixIcon: Icon(Icons.search),
          suffixIcon: SizedBox(
            height: 24,
            child: filter.isEmpty
                ? null
                : IconButton(
                    onPressed: clearFilter,
                    icon: Icon(Icons.clear),
                  ),
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  void clearFilter() {
    filter = '';
    filterInput.clear();
    if (mounted) setState(() {});
    Future.delayed(
      Duration(milliseconds: 100),
      () => FocusScope.of(context).unfocus(),
    );
  }
}