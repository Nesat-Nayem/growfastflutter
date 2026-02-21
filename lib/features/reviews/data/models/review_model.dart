import 'package:grow_first/features/reviews/domain/entities.dart/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.userName,
    required super.userImage,
    required super.rating,
    required super.description,
    required super.time,
    required super.dateTime,
    required super.likes,
    required super.dislikes,
    required super.replies,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final repliesJson = json['replies'] as List? ?? [];
    return ReviewModel(
      id: json['id'] ?? 0,
      userName: json['user_name'] ?? 'Unknown User',
      userImage: json['user_image'] ??
          'http://127.0.0.1:8000/assets/img/default.png',
      rating: json['rating']?.toString() ?? '0',
      description: json['description'] ?? '',
      time: json['time'] ?? '',
      dateTime: json['date_time'] ?? '',
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      replies: repliesJson.map((e) => ReviewReplyModel.fromJson(e)).toList(),
    );
  }
}

class ReviewReplyModel extends ReviewReply {
  const ReviewReplyModel({
    required super.id,
    required super.reviewId,
    required super.userId,
    required super.reply,
    super.parentId,
    required super.userName,
    super.userImage,
    required super.time,
    required super.children,
  });

  factory ReviewReplyModel.fromJson(Map<String, dynamic> json) {
    final childrenJson = json['children'] as List? ?? [];
    return ReviewReplyModel(
      id: json['id'] ?? 0,
      reviewId: json['review_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      reply: json['reply'] ?? '',
      parentId: json['parent_id'],
      userName: json['user']?['name'] ?? 'Unknown User',
      userImage: json['user']?['image'],
      time: json['created_at'] != null
          ? _formatTime(json['created_at'])
          : '',
      children: childrenJson.map((e) => ReviewReplyModel.fromJson(e)).toList(),
    );
  }

  static String _formatTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (_) {
      return '';
    }
  }
}
