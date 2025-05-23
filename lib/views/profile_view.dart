// ignore_for_file: use_build_context_synchronously
// dont worry i know what im doing /s

import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:isis3510_team32_flutter/constants/errors.dart';
import 'package:isis3510_team32_flutter/constants/exceptions.dart';
import 'package:isis3510_team32_flutter/constants/sports.dart';
import 'package:isis3510_team32_flutter/core/app_colors.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_event.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_state.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_state.dart';
import 'package:isis3510_team32_flutter/view_models/theme/theme_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/theme/theme_event.dart';
import 'package:isis3510_team32_flutter/view_models/theme/theme_state.dart';
import 'package:isis3510_team32_flutter/widgets/navbar/bottom_navigation_widget.dart';
import 'package:isis3510_team32_flutter/widgets/search_view_widgets/venue_list_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseCrashlytics.instance.setCustomKey('screen', 'Profile View');

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
            style: TextStyle(
              color: AppColors.titleText(context),
              fontWeight: FontWeight.w600,
            )),
        centerTitle: true,
        backgroundColor: AppColors.appBarBackground(context),
        automaticallyImplyLeading: false,
        shadowColor: AppColors.text(context),
        elevation: 1,
      ),
      backgroundColor: AppColors.background(context),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileCardWidget(),
                FavoriteVenuesWidget(),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationWidget(selectedIndex: 4, reLoad: false,),
    );
  }
}

class LogoutProfileWidget extends StatelessWidget {
  const LogoutProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, foregroundColor: Colors.white),
          onPressed: () => authBloc.add(AuthLogOutEvent()),
          child: const Text(
            'Logout',
          )),
    );
  }
}

class SettingsProfileWidget extends StatelessWidget {
  const SettingsProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary, foregroundColor: Colors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const SettingsProfileDialogWidget(),
          );
        },
        child: const Text(
          'Settings',
        ),
      ),
    );
  }
}

class SettingsProfileDialogWidget extends StatelessWidget {
  const SettingsProfileDialogWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Settings",
        style: TextStyle(fontSize: 16),
      ),
      content: SizedBox(
        width: 250,
        height: 200,
        child: Column(
          children: [
            TextButton(
              onPressed: () {},
              child: const Text("Edit Profile Name"),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Change Gender"),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Update Birth Date"),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Update Sports"),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteVenuesWidget extends StatelessWidget {
  const FavoriteVenuesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My favorite venues',
            style: TextStyle(
              color: AppColors.lighterPurple,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          BlocBuilder<AuthBloc, AuthState>(builder: (bloc, state) {
            return SizedBox(
              height: 200,
              child: (state.userModel != null &&
                      state.userModel!.venuesLiked.isNotEmpty)
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.userModel!.venuesLiked.length,
                      itemBuilder: (context, index) => VenueListWidget(
                          venue: state.userModel!.venuesLiked[index]),
                    )
                  : Center(
                      child: Text(
                        "You do not have any favorite venues to show",
                        style: TextStyle(color: AppColors.text(context)),
                      ),
                    ),
            );
          })
        ],
      ),
    );
  }
}

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: state is ThemeLightState
              ? AppColors.lightestPurple
              : AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfileCardAvatarWidget(),
                ProfileCardTextWidget(),
              ],
            ),
            ProfileCardFavoriteSportsWidget(),
            ProfileCardLightModeSwitchWidget(),
            SettingsProfileWidget(),
            LogoutProfileWidget()
          ],
        ),
      );
    });
  }
}

class ProfileCardSettingsButtonWidget extends StatelessWidget {
  const ProfileCardSettingsButtonWidget({
    super.key,
  });

  void _showSelectionDialog(BuildContext context) {
    const fontSize = 16.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF3F3F3F),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: const Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize + 1,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    'Edit profile name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text(
                    'Change gender',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text(
                    'Update birth date',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text(
                    'Update favorite sports',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(color: Colors.green),
                      )),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary, foregroundColor: Colors.white),
        onPressed: () => _showSelectionDialog(context),
        child: const Text('Settings'),
      ),
    );
  }
}

class ProfileCardLightModeSwitchWidget extends StatelessWidget {
  const ProfileCardLightModeSwitchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final themeState = context.watch<ThemeBloc>().state;

      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Row(
              children: [
                Icon(
                  themeState is ThemeLightState
                      ? Icons.sunny
                      : Icons.nightlight,
                  size: 24,
                  color: AppColors.titleText(context),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: Text(
                      'Light mode',
                      style: TextStyle(color: AppColors.text(context)),
                    ))
              ],
            ),
            const Spacer(),
            BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
              return Transform.scale(
                scale: 0.7,
                child: Switch.adaptive(
                  activeColor: AppColors.primary,
                  activeTrackColor: AppColors.lightererPurple,
                  value: state is ThemeLightState,
                  onChanged: (_) =>
                      context.read<ThemeBloc>().add(ThemeSwitchEvent()),
                ),
              );
            })
          ],
        ),
      );
    });
  }
}

class ProfileCardFavoriteSportsWidget extends StatelessWidget {
  const ProfileCardFavoriteSportsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 5),
          child: Text(
            "Favorite sports",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.text(context),
            ),
          ),
        ),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (bloc, state) => Row(
            children: state.userModel != null
                ? state.userModel!.sportsLiked.map(
                    (sport) {
                      return Container(
                        width: 48,
                        height: 48,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Center(
                            child: SvgPicture.asset(
                              sportLocal[sport.id]!.logo,
                              width: 40,
                              height: 40,
                              colorFilter: const ColorFilter.mode(
                                AppColors.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList()
                : [],
          ),
        ),
      ],
    );
  }
}

class ProfileCardTextWidget extends StatelessWidget {
  const ProfileCardTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final authState = context.watch<AuthBloc>().state;
      return Container(
        margin: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 210,
              child: Text(
                authState.userModel != null
                    ? authState.userModel!.name
                    : "Unknown user",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.text(context),
                ),
              ),
            ),
            Text(
              "Gender: ${authState.userModel != null ? authState.userModel!.gender : "Unknown"}",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.text(context),
              ),
            ),
            Text(
              "Born in ${authState.userModel != null ? DateFormat('dd/MM/yyyy').format(authState.userModel!.birthDate) : "Unknown"}",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.text(context),
              ),
            )
          ],
        ),
      );
    });
  }
}

class ProfileCardAvatarWidget extends StatelessWidget {
  const ProfileCardAvatarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              const ProfileCardImageSelectorDialog(),
        );
      },
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          final imageUrl = state.userModel?.imageUrl;
          return Stack(
            children: [
              ClipOval(
                child: Center(
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          placeholder: (_, __) =>
                              const CircularProgressIndicator(),
                          errorWidget: (_, __, ___) {
                            showNoConnectionError(context);
                            return const ProfileCardAvatarPlaceholderPicture();
                          })
                      : const ProfileCardAvatarPlaceholderPicture(),
                ),
              ),
              if (imageUrl == null) const ProfileCardAvatarPlusWidget(),
            ],
          );
        }),
      ),
    );
  }
}

class ProfileCardAvatarPlaceholderPicture extends StatelessWidget {
  const ProfileCardAvatarPlaceholderPicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/avatar.svg',
      width: 64,
      height: 64,
      colorFilter: const ColorFilter.mode(
        AppColors.primary,
        BlendMode.srcIn,
      ),
    );
  }
}

class ProfileCardAvatarPlusWidget extends StatelessWidget {
  const ProfileCardAvatarPlusWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/plus.svg',
              width: 32,
              height: 32,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileCardImageSelectorDialog extends StatelessWidget {
  const ProfileCardImageSelectorDialog({
    super.key,
  });

  Future<void> setNewImage(ImageSource source, BuildContext context) async {
    final authBloc = context.read<AuthBloc>();
    final connectivityBloc = context.read<ConnectivityBloc>();

    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage == null) {
      throw ImageNotFoundException("Could not fetch image");
    }
    final file = File(pickedImage.path);

    if (connectivityBloc.state is ConnectivityOfflineState) {
      throw ConnectivityException("Could not confirm connectivity status");
    }
    authBloc.add(AuthUpdateImageEvent(file));
  }

  Future<void> attemptSetNewImage(
      ImageSource source, BuildContext context) async {
    final connectivityBloc = context.read<ConnectivityBloc>();
    if (connectivityBloc.state is ConnectivityOfflineState) {
      Navigator.of(context).pop();
      showNoConnectionError(context);
      return;
    }
    try {
      await setNewImage(source, context);
      Navigator.of(context).pop();
      showImageUploadedSuccessfully(context);
    } on ImageNotFoundException catch (_) {
      Navigator.of(context).pop();
      showCouldNotLoadImage(context);
    } on ConnectivityException catch (_) {
      Navigator.of(context).pop();
      showNoConnectionError(context);
    }
  }

  void showImageUploadedSuccessfully(BuildContext context) {
    Flushbar(
      title: "Image uploaded successfully",
      message:
          "If you wish to rewrite it, hit the image icon again to put a new one",
      icon: const Icon(
        Icons.info_rounded,
        size: 16,
        color: AppColors.primary,
      ),
      leftBarIndicatorColor: AppColors.primary,
      duration: const Duration(seconds: 5),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Select a profile image",
        style: TextStyle(fontSize: 16),
      ),
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: 200,
          height: 100,
          child: Center(
            child: Column(
              children: [
                TextButton(
                    onPressed: () {
                      attemptSetNewImage(ImageSource.camera, context);
                    },
                    child: const Text("Camera")),
                TextButton(
                    onPressed: () async {
                      attemptSetNewImage(ImageSource.gallery, context);
                    },
                    child: const Text("Gallery"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
