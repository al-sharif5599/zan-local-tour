import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> setUser(AppUser user) async {
    await _db.collection('users').doc(user.id).set(user.toFirestore());
  }

  Future<AppUser?> getUser(String userId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return AppUser.fromFirestore(doc);
    }
    return null;
  }

  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .where((p) => p.status == ProductStatus.approved)
          .toList();
    });
  }

  Stream<List<Product>> getPendingProducts(String role) {
    if (role != 'admin') return Stream.value([]);
    return _db
        .collection('products')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList(),
        );
  }

  Future<void> updateProductStatus(
    String productId,
    ProductStatus status,
  ) async {
    await _db.collection('products').doc(productId).update({
      'status': status.toString().split('.').last,
    });
  }

  Future<void> addProduct(Product product) async {
    await _db.collection('products').add(product.toFirestore());
  }

  Future<List<Product>> getProductsByLocation(
    GeoPoint location,
    double radius,
  ) async {
    // Simple query, for real use geospatial index
    QuerySnapshot snapshot = await _db.collection('products').get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).where((p) {
      double distance = _calculateDistance(p.location, location);
      return distance <= radius;
    }).toList();
  }

  double _calculateDistance(GeoPoint a, GeoPoint b) {
    // Haversine formula
    const double earthRadius = 6371000; // meters
    double dLat = (b.latitude - a.latitude) * math.pi / 180;
    double dLon = (b.longitude - a.longitude) * math.pi / 180;
    double aVal =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(a.latitude * math.pi / 180) *
            math.cos(b.latitude * math.pi / 180) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double cVal = 2 * math.atan2(math.sqrt(aVal), math.sqrt(1 - aVal));
    return earthRadius * cVal;
  }
}
