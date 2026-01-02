import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/global_review_card.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class CustomerBookingAdditionalServiceCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double price;
  final String duration;
  final double rating;
  final int reviews;
  final bool isSelected;
  final VoidCallback onAdd;
  final bool isCardSelectionEnabled;

  const CustomerBookingAdditionalServiceCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.duration,
    required this.rating,
    required this.reviews,
    required this.isSelected,
    required this.onAdd,
    this.isCardSelectionEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: allPadding12,
      margin: bottomPadding16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              horizontalMargin12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    verticalMargin8,
                    Text.rich(
                      TextSpan(
                        text: "₹ $price ",
                        children: [
                          TextSpan(
                            text: "/ $duration",
                            style: context.labelLarge.copyWith(
                              fontWeight: FontWeight.w400,
                              color: lightGreyTextColor,
                            ),
                          ),
                        ],
                      ),
                      style: context.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCardSelectionEnabled) ...[
                CheckboxTheme(
                  data: CheckboxThemeData(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    checkColor: WidgetStatePropertyAll(whiteColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(5),
                    ),
                  ),
                  child: Checkbox(
                    fillColor: WidgetStatePropertyAll(aquaGreenColor),
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ],
          ),
          if (isCardSelectionEnabled) ...[
            verticalMargin12,
            Divider(color: greyButttonColor),
            Row(
              children: [
                GlobalReviewCard(),
                const Spacer(),
                GradientButton(
                  text: "Add",
                  onTap: () {},
                  hideGradient: true,
                  showIconFirst: true,
                  iconWithTitle: Icon(
                    Icons.add_circle_outline_rounded,
                    size: 13,
                  ),
                  backgroundColor: greyButttonColor,
                  padding: verticalPadding8 + horizontalPadding12,
                  textStyle: context.labelMedium,
                  borderRadius: 8,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
