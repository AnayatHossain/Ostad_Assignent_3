import 'dart:convert';
import 'package:crud_app/models/product.dart';
import 'package:crud_app/ui/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'add_new_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productlist = [];
  bool _getProductListInProgress = false;

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            onPressed: _getProductList,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _getProductList,
        child: _getProductListInProgress
            ? const Center(child: CircularProgressIndicator()) // Show loading indicator
            : ListView.builder(
          itemCount: productlist.length,
          itemBuilder: (context, index) {
            return ProductItem(
              product: productlist[index], // Pass the product
              onDelete: () {
                final productId = productlist[index].id;
                if (productId != null) {
                  _deleteProduct(productId);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error: Product ID is null.')),
                  );
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNewProductScreen.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _getProductList() async {
    productlist.clear();
    _getProductListInProgress = true;
    setState(() {});
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct');
    Response response = await get(uri);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      print(decodedData['status']);
      for (Map<String, dynamic> p in decodedData['data']) {
        Product product = Product(
            id: p['_id'],
            ProductName: p['ProductName'],
            ProductCode: p['ProductCode'],
            Image: p["Img"],
            UnitPrice: p['UnitPrice'],
            Quantity: p['Qty'],
            TotalPrice: p['TotalPrice'],
            CreatedDate: p['CreatedDate']);
        productlist.add(product);
      }
      setState(() {});
    }
    _getProductListInProgress = false;
    setState(() {});
  }
}

  Future<void> _deleteProduct(String productId) async {
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId');
    Response response = await delete(
      uri,
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        productlist.removeWhere((product) => product.id == productId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete product. Please try again.')),
      );
    }
  }
}
