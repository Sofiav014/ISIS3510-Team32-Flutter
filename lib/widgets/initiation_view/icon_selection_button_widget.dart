import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';

class IconSelectionButton extends StatelessWidget {
  final String text;
  final bool changeWithTheme;
  final String imageAsset;
  final double size;
  final Function()? onPressed;

  const IconSelectionButton({
    required this.text,
    required this.changeWithTheme,
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
          color: changeWithTheme
              ? AppColors.titleText(context)
              : AppColors.primary,
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
              color: changeWithTheme
                  ? AppColors.titleText(context)
                  : AppColors.primary,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              text,
              style: TextStyle(
                  color: changeWithTheme
                      ? AppColors.titleText(context)
                      : AppColors.primary),
            )
          ],
        ),
      ),
    );
  }
}
