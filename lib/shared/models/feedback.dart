import 'package:cloud_firestore/cloud_firestore.dart';

enum FeedbackCategory {
  lookAndFeel('Look and Feel'),
  functionality('Functionality'),
  others('Others');

  final String displayName;
  const FeedbackCategory(this.displayName);
}

class FeedbackEntry {
  final String? id;
  final String userId;
  final String userName;
  final FeedbackCategory category;
  final String description;
  final DateTime createdAt;

  FeedbackEntry({
    this.id,
    required this.userId,
    required this.userName,
    required this.category,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'category': category.name,
        'description': description,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
