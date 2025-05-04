import 'package:flutter/material.dart';
import 'package:isis3510_team32_flutter/constants/errors.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isis3510_team32_flutter/models/data_models/user_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:isis3510_team32_flutter/models/repositories/auth_repository.dart';
import 'package:isis3510_team32_flutter/models/repositories/connectivity_repository.dart';

class VenueDetailImageWidget extends StatefulWidget {
  final VenueModel venue;
  final UserModel user;
  final ConnectivityRepository connectivityRepository;
  final AuthRepository authRepository;

  const VenueDetailImageWidget({super.key, required this.venue, required this.user, required this.connectivityRepository, required this.authRepository});

  @override
  State<VenueDetailImageWidget> createState() => _VenueDetailImageWidgetState();

}

class _VenueDetailImageWidgetState extends State<VenueDetailImageWidget>{
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    _isLiked = widget.user.containsLikedVenue(widget.venue);

    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          child: AspectRatio(
            aspectRatio: 25 / 20,
            child: CachedNetworkImage(
              imageUrl: widget.venue.image,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image)),
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: AppColors.contrast900,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.black, size: 16),
                const SizedBox(width: 4),
                Text(
                  widget.venue.rating.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(179),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.venue.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.primaryNeutral,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/location.svg',
                      width: 16,
                      height: 16,
                      color: AppColors.contrast900,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.venue.locationName,
                        style: const TextStyle(
                          color: AppColors.primaryNeutral,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/sport_logo.svg',
                      width: 16,
                      height: 16,
                      color: AppColors.contrast900,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.venue.sport.name,
                        style: const TextStyle(
                          color: AppColors.primaryNeutral,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: GestureDetector(
            onTap: () async {
              bool hasInternet = await widget.connectivityRepository.hasInternet;
              if (hasInternet) {
                setState(() {
                _isLiked = !_isLiked;
                if (_isLiked) {
                  widget.user.addLikedVenue(widget.venue);
                } else {
                  widget.user.removeLikedVenue(widget.venue);
                }
                widget.authRepository.uploadUser(widget.user);
                });
              } else {
                showNoConnectionError(context);
              }
            },
            child: SvgPicture.asset(
              _isLiked ? 'assets/icons/heart_added.svg' : 'assets/icons/heart_add.svg',
              width: 32,
              height: 32,
              color: AppColors.contrast900,
            ),
          ),
        ),
      ],
    );
  }
}
