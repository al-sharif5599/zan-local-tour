import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../admin/approvals_screen.dart';
import '../upload/upload_screen.dart';
import '../gallery/gallery_screen.dart';
import '../../services/firestore_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    if (user == null)
      return Scaffold(body: Center(child: CircularProgressIndicator()));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Zan Local Store'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Products'),
              Tab(text: 'Gallery'),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => auth.logout(),
            ),
          ],
        ),
        body: TabBarView(
          children: [_buildProductsBody(user.role), GalleryScreen()],
        ),
        floatingActionButton: user.role == UserRole.local
            ? FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UploadScreen()),
                ),
                child: Icon(Icons.add),
              )
            : null,
      ),
    );
  }

  Widget _buildProductsBody(UserRole role) {
    if (role == UserRole.admin) {
      return ApprovalsScreen();
    }
    // Default list products
    return StreamBuilder<List<dynamic>>(
      stream: FirestoreService().getProducts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        final products = snapshot.data!;
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final p = products[index];
            return ListTile(
              title: Text(p.title),
              subtitle: Text(p.location.toString()),
            );
          },
        );
      },
    );
  }
}
