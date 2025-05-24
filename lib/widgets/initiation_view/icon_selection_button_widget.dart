import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';

class IconSelectionButton extends StatelessWidget {
  final String text;
  final String imageAsset;
  final double size;
  final Function()? onPressed;

  const IconSelectionButton({
    required this.text,
    required this.imageAsset,
    required this.size,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(
          color: AppColors.titleText(context),
          width: 2,
        ),
      ),
      onPressed: onPressed != null ? () => onPressed!.call() : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: Column(
          children: [
            SvgPicture.asset(
              imageAsset,
              width: size,
              height: size,
              color: AppColors.titleText(context),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              text,
              style: TextStyle(color: AppColors.titleText(context)),
            )
          ],
        ),
      ),
    );
  }
}
