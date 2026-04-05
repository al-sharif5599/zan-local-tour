import 'package:flutter/material.dart';
import '../../../services/firestore_service.dart';
import '../../../models/product_model.dart';

class ApprovalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: FirestoreService().getPendingProducts('admin'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        final products = snapshot.data!;
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final p = products[index];
            return Card(
              child: ListTile(
                title: Text(p.title),
                subtitle: Text(p.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: Icon(Icons.check), onPressed: () => FirestoreService().updateProductStatus(p.id, ProductStatus.approved)),
                    IconButton(icon: Icon(Icons.close), onPressed: () => FirestoreService().updateProductStatus(p.id, ProductStatus.rejected)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
