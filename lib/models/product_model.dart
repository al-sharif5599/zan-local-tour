import 'package:cloud_firestore/cloud_firestore.dart';

enum ProductStatus { pending, approved, rejected }

class Product {
  final String id;
  final String userId;
  final String title;
  final String description;
  final List<String> mediaUrls; // images/videos
  final GeoPoint location;
  final String language;
  final ProductStatus status;
  final Timestamp createdAt;

  Product({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.mediaUrls = const [],
    required this.location,
    required this.language,
    this.status = ProductStatus.pending,
    required this.createdAt,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      mediaUrls: List<String>.from(data['mediaUrls'] ?? []),
      location: data['location'] ?? GeoPoint(0, 0),
      language: data['language'] ?? 'en',
      status: ProductStatus.values.firstWhere((s) => s.toString() == 'ProductStatus.${data['status'] ?? 'pending'}'),
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'mediaUrls': mediaUrls,
      'location': location,
      'language': language,
      'status': status.toString().split('.').last,
      'createdAt': createdAt,
    };
  }
}
