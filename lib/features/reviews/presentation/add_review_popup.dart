import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/core/storage/secure_storage.dart';
import 'package:grow_first/core/utils/snackbar.dart';
import 'package:grow_first/features/reviews/presentation/bloc/reviews_cubit.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Review",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
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
                   Container(
  height: 38,
  decoration: BoxDecoration(
    color: Colors.grey[500],
    borderRadius: BorderRadius.circular(8),
  ),
  child: TextButton(
    onPressed: () => Navigator.pop(context),
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero, // Ensures text stays centered in small height
      minimumSize: const Size(0, 38),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    child: const Text(
      "   Cancel   ",
      style: TextStyle(
        color: Color.fromARGB(115, 0, 0, 0),
        fontWeight: FontWeight.w500,
        fontSize: 12
      ),
    ),
  ),
),
                    
                    SizedBox(width: 5),
                    GradientButton(
                      borderRadius: 7,
                      text: "Submit",
                      padding: const EdgeInsets.all(10),
                      onTap: state is ReviewsLoading
                          ? null
                          : () async {
                              debugPrint("SUBMIT BUTTON CLICKED");

                              final token = await sl<ISecureStore>().read(
                                "token",
                              );

                              if (token == null || token.isEmpty) {
                                // ❌ User not logged in
                                AppSnackBar.show(
                                  context,
                                  message: "Please login first",
                                );
                                Navigator.of(context).pop();

                                return;
                              }

                              // ✅ User logged in → submit review
                              context.read<ReviewsCubit>().submitReview(
                                serviceId: widget.serviceId,
                                title: titleCtrl.text,
                                email: emailCtrl.text,
                                rating: rating,
                                details: detailsCtrl.text,
                              );
                            },
                    ),

                    // GradientButton(
                    //   borderRadius: 7,
                    //   text: "Submit",
                    //   padding: const EdgeInsets.all(10),
                    //   onTap: state is ReviewsLoading
                    //       ? null
                    //       : () {
                    //           debugPrint("SUBMIT BUTTON CLICKED");

                    //           context.read<ReviewsCubit>().submitReview(
                    //             serviceId: widget.serviceId,
                    //             title: titleCtrl.text,
                    //             email: emailCtrl.text,
                    //             rating: rating,
                    //             details: detailsCtrl.text,
                    //           );
                    //         },
                    // ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}
