import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/features/reviews/presentation/bloc/reviews_cubit.dart';

class AddReviewPopup extends StatefulWidget {
  final int serviceId;

  const AddReviewPopup({super.key, required this.serviceId});

  @override
  State<AddReviewPopup> createState() => _AddReviewPopupState();
}

class _AddReviewPopupState extends State<AddReviewPopup> {
  int rating = 0;
  final titleCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final detailsCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<ReviewsCubit, ReviewsState>(
          listener: (context, state) {
            if (state is ReviewSubmitSuccess) {
              Navigator.pop(context, true);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add Review", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),

                /// ⭐ Rating
                Row(
                  children: List.generate(5, (i) {
                    return IconButton(
                      onPressed: () => setState(() => rating = i + 1),
                      icon: Icon(
                        i < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                    );
                  }),
                ),

                _field("Review Title", titleCtrl),
                _field("Email Address", emailCtrl),
                _field("Write Your Review", detailsCtrl, maxLines: 3),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: state is ReviewsLoading
                          ? null
                          : () {
                              context.read<ReviewsCubit>().submitReview(
                                    serviceId: widget.serviceId,
                                    title: titleCtrl.text,
                                    email: emailCtrl.text,
                                    rating: rating,
                                    details: detailsCtrl.text,
                                  );
                            },
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
