class Review {
  final int id;
  final String userName;
  final String userImage;
  final String rating;
  final String description;
  final String time;
  final String dateTime;
  final int likes;
  final int dislikes;
  final List<ReviewReply> replies;

  const Review({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.description,
    required this.time,
    required this.dateTime,
    required this.likes,
    required this.dislikes,
    required this.replies,
  });

  Review copyWith({
    int? id,
    String? userName,
    String? userImage,
    String? rating,
    String? description,
    String? time,
    String? dateTime,
    int? likes,
    int? dislikes,
    List<ReviewReply>? replies,
  }) {
    return Review(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      time: time ?? this.time,
      dateTime: dateTime ?? this.dateTime,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      replies: replies ?? this.replies,
    );
  }
}

class ReviewReply {
  final int id;
  final int reviewId;
  final int userId;
  final String reply;
  final int? parentId;
  final String userName;
  final String? userImage;
  final String time;
  final List<ReviewReply> children;

  const ReviewReply({
    required this.id,
    required this.reviewId,
    required this.userId,
    required this.reply,
    this.parentId,
    required this.userName,
    this.userImage,
    required this.time,
    required this.children,
  });
}
