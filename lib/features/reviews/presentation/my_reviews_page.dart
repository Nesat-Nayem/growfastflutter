import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/app_store/app_store.dart';
import 'package:grow_first/core/config/app_config.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/reviews/presentation/bloc/reviews_cubit.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';

class MyReviewsPage extends StatefulWidget {
  const MyReviewsPage({super.key});

  @override
  State<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  late ReviewsCubit _reviewsCubit;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _reviewsCubit = sl<ReviewsCubit>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadReviewsIfLoggedIn();
  }

  void _loadReviewsIfLoggedIn() {
    final appStore = sl<AppStore>();
    if (!appStore.isLoggedIn) {
      if (_isFirstLoad) {
        _isFirstLoad = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.goNamed(AppRouterNames.signIn);
        });
      }
    } else {
      _reviewsCubit.loadReviews();
    }
  }

  void _handleUnauthorized() async {
    await sl<AppStore>().clear();
    if (mounted) {
      context.goNamed(AppRouterNames.signIn);
    }
  }


  @override
  void dispose() {
    _reviewsCubit.close();
    super.dispose();
  }

  String _getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    if (imagePath.startsWith('http')) return imagePath;
    final config = sl<AppConfig>();
    return '${config.imageBaseUrl}/storage/$imagePath';
  }

  void _confirmDelete(int reviewId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reviewsCubit.deleteReview(reviewId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _reviewsCubit,
      child: Scaffold(
        appBar: CustomerHomeAppBar(singleTitle: "My Reviews"),
        body: BlocConsumer<ReviewsCubit, ReviewsState>(
          listener: (context, state) {
            if (state is ReviewsUnauthorized) {
              _handleUnauthorized();
            }
          },
          builder: (context, state) {
            if (state is ReviewsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ReviewsUnauthorized) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ReviewsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    verticalMargin16,
                    Text('Failed to load reviews'),
                    verticalMargin8,
                    ElevatedButton(
                      onPressed: () => _reviewsCubit.loadReviews(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is ReviewsLoaded) {
              if (state.reviews.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.rate_review_outlined, size: 48, color: Colors.grey),
                      verticalMargin16,
                      const Text('No Reviews Yet'),
                      verticalMargin8,
                      const Text(
                        'Your reviews will appear here',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => _reviewsCubit.loadReviews(),
                child: ListView.builder(
                  padding: horizontalPadding16,
                  itemCount: state.reviews.length,
                  itemBuilder: (context, index) {
                    final review = state.reviews[index];
                    final service = review['service'];
                    final user = review['user'];
                    final gallery = service?['gallery'] as List?;
                    String? serviceImageUrl;
                    if (gallery != null && gallery.isNotEmpty) {
                      serviceImageUrl = _getImageUrl(gallery[0]['img']);
                    }

                    final int rating = int.tryParse(review['rating']?.toString() ?? '0') ?? 0;
                    final String reviewText = review['review'] ?? '';
                    final String createdAt = review['created_at']?.toString().split('T')[0] ?? '';

                    return Container(
                      padding: allPadding12,
                      margin: verticalPadding8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: serviceImageUrl != null && serviceImageUrl.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: serviceImageUrl,
                                        width: 60,
                                        height: 65,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => Container(
                                          width: 60,
                                          height: 65,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.image_not_supported),
                                        ),
                                      )
                                    : Container(
                                        width: 60,
                                        height: 65,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.image),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      service?['title'] ?? 'Service',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (starIndex) => Icon(
                                          starIndex < rating ? Icons.star : Icons.star_border,
                                          size: 16,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                onPressed: () => _confirmDelete(review['id']),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: user?['image'] != null
                                    ? CachedNetworkImageProvider(_getImageUrl(user['image']))
                                    : null,
                                child: user?['image'] == null
                                    ? const Icon(Icons.person, size: 16)
                                    : null,
                              ),
                              horizontalMargin12,
                              Expanded(
                                child: Text(
                                  user?['name'] ?? 'User',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Text(
                                createdAt,
                                style: const TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                          if (reviewText.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              reviewText,
                              style: const TextStyle(fontSize: 14, height: 1.4),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
