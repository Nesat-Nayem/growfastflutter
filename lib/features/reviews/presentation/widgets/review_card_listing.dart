import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/core/storage/secure_storage.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/reviews/domain/entities.dart/review.dart';
import 'package:grow_first/features/reviews/presentation/bloc/reviews_cubit.dart';

class ReviewCardListing extends StatefulWidget {
  final Review review;
  final VoidCallback? onReviewUpdated;

  const ReviewCardListing({
    super.key,
    required this.review,
    this.onReviewUpdated,
  });

  @override
  State<ReviewCardListing> createState() => _ReviewCardListingState();
}

class _ReviewCardListingState extends State<ReviewCardListing> {
  late int _likes;
  late int _dislikes;
  bool _showReplyField = false;
  bool _showReplies = false;
  final _replyController = TextEditingController();
  bool _isSubmittingReply = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.review.likes;
    _dislikes = widget.review.dislikes;
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _handleLike(bool isLike) async {
    final isLoggedIn = await sl<ISecureStore>().read("isLoggedIn") == "true";
    if (!isLoggedIn) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to like/dislike')),
        );
      }
      return;
    }

    final result = await sl<ReviewsCubit>().likeReview(
      widget.review.id,
      isLike,
    );
    if (result != null && mounted) {
      setState(() {
        _likes = result['like_count'] ?? _likes;
        _dislikes = result['dislike_count'] ?? _dislikes;
      });
    }
  }

  Future<void> _submitReply() async {
    if (_replyController.text.trim().isEmpty) return;

    final isLoggedIn = await sl<ISecureStore>().read("isLoggedIn") == "true";
    if (!isLoggedIn) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please login to reply')));
      }
      return;
    }

    setState(() => _isSubmittingReply = true);

    final success = await sl<ReviewsCubit>().replyReview(
      widget.review.id,
      _replyController.text.trim(),
    );

    setState(() => _isSubmittingReply = false);

    if (success && mounted) {
      _replyController.clear();
      setState(() => _showReplyField = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reply submitted!')));
      widget.onReviewUpdated?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: topPadding12,
      padding: topPadding8 + horizontalPadding8 + bottomPadding8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: CachedNetworkImageProvider(
                  widget.review.userImage,
                ),
              ),
              horizontalMargin8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.review.userName, style: context.labelLarge),
                    Text(widget.review.time, style: context.labelSmall),
                  ],
                ),
              ),
              Container(
                padding: verticalPadding2 + horizontalPadding8,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 118, 192, 121),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      widget.review.rating,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalMargin12,
          Text(
            widget.review.description,
            style: context.labelMedium.copyWith(
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          verticalMargin12,
          // Like/Dislike/Reply Row
          Row(
            children: [
              InkWell(
                onTap: () => setState(() => _showReplyField = !_showReplyField),
                child: Row(
                  children: [
                    Icon(
                      Icons.message_outlined,
                      size: 18,
                      color: lightGreyTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Reply',
                      style: context.labelSmall.copyWith(
                        color: lightGreyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              horizontalMargin16,
              InkWell(
                onTap: () => _handleLike(true),
                child: Row(
                  children: [
                    Icon(
                      Icons.thumb_up_outlined,
                      size: 18,
                      color: lightGreyTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Like',
                      style: context.labelSmall.copyWith(
                        color: lightGreyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              horizontalMargin16,
              InkWell(
                onTap: () => _handleLike(false),
                child: Row(
                  children: [
                    Icon(
                      Icons.thumb_down_outlined,
                      size: 18,
                      color: lightGreyTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Dislike',
                      style: context.labelSmall.copyWith(
                        color: lightGreyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.thumb_up, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text('$_likes', style: context.labelSmall),
                ],
              ),
              horizontalMargin12,
              Row(
                children: [
                  Icon(Icons.thumb_down, size: 16, color: Colors.red),
                  const SizedBox(width: 4),
                  Text('$_dislikes', style: context.labelSmall),
                ],
              ),
            ],
          ),
          // Reply Input Field
          if (_showReplyField) ...[
            verticalMargin12,
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: 'Write a reply...',
                      hintStyle: context.labelSmall.copyWith(
                        color: lightGreyTextColor,
                      ),
                      contentPadding: horizontalPadding12 + verticalPadding8,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    style: context.labelMedium,
                  ),
                ),
                horizontalMargin8,
                ElevatedButton(
                  onPressed: _isSubmittingReply ? null : _submitReply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: horizontalPadding12 + verticalPadding8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmittingReply
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Send',
                          style: context.labelSmall.copyWith(color: whiteColor),
                        ),
                ),
              ],
            ),
          ],
          // Show Replies
          if (widget.review.replies.isNotEmpty) ...[
            verticalMargin8,
            InkWell(
              onTap: () => setState(() => _showReplies = !_showReplies),
              child: Text(
                _showReplies
                    ? 'Hide replies (${widget.review.replies.length})'
                    : 'View replies (${widget.review.replies.length})',
                style: context.labelSmall.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (_showReplies) ...[
              verticalMargin8,
              ...widget.review.replies.map(
                (reply) => _buildReplyCard(context, reply),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildReplyCard(BuildContext context, ReviewReply reply) {
    return Container(
      margin: const EdgeInsets.only(left: 24, top: 8),
      padding: allPadding12,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: Colors.grey.shade300, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundImage: reply.userImage != null
                    ? CachedNetworkImageProvider(reply.userImage!)
                    : null,
                child: reply.userImage == null
                    ? Text(reply.userName[0].toUpperCase())
                    : null,
              ),
              horizontalMargin8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reply.userName,
                      style: context.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      reply.time,
                      style: context.labelSmall.copyWith(
                        color: lightGreyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalMargin8,
          Text(reply.reply, style: context.labelMedium),
          // Nested replies
          if (reply.children.isNotEmpty) ...[
            verticalMargin8,
            ...reply.children.map((child) => _buildReplyCard(context, child)),
          ],
        ],
      ),
    );
  }
}
