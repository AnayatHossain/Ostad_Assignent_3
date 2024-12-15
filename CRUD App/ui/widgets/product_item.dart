import 'package:crud_app/models/product.dart';
import 'package:crud_app/ui/screens/update_product_screen.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product, required Future<void> Function() onDelete});
  final Product product;
  @override
  Widget build(BuildContext context) {
    return ListTile(
         leading: Image.network(product.Image ?? ''),
          title: Text(product.ProductName  ?? ''),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Code:${ product.ProductCode ?? ''} '),
          Text('Product Quantity: ${ product.Quantity ?? ''}'),
          Text('Price:${ product.UnitPrice ?? ''}'),
          Text('Total Price:${ product.TotalPrice ?? ''}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, UpdateProductScreen.name, arguments: product);
            },
            icon: Icon(Icons.edit),
          )
        ],
      ),
    );
  }
}
