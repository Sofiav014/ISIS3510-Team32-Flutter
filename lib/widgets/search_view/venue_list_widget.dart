import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VenueListWidget extends StatelessWidget {
  final VenueModel venue;

  const VenueListWidget({
    super.key,
    required this.venue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.push('/venue_detail/${venue.sport.name}/${venue.id}');
        },
        child: Container(
          margin: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: venue.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Center(child: Icon(Icons.broken_image)),
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
                          venue.rating.toString(),
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
                          venue.name,
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
                                venue.locationName,
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
                                venue.distance ?? 'Distance not available',
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
              ],
            ),
          ),
        ));
  }
}
