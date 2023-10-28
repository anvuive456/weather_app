import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/common/app_constants.dart';
import 'package:weather_app/common/general_utils/app_toast.dart';
import 'package:weather_app/common/general_utils/focus_utils.dart';
import 'package:weather_app/common/mixin/setting_mixin.dart';
import 'package:weather_app/common/model/location.dart';
import 'package:weather_app/common/navigation/route_paths.dart';
import 'package:weather_app/common/widget/app_button.dart';
import 'package:weather_app/common/widget/app_loading.dart';
import 'package:weather_app/modules/search_location/provider/search_location_provider.dart';
import 'package:weather_app/modules/search_location/widget/location_tile.dart';
import 'package:weather_app/modules/setting/provider/setting_provider.dart';
import 'package:weather_app/modules/setting/screen/setting_dialog.dart';
import 'package:weather_app/modules/weather/provider/local_location_provider.dart';
import 'package:weather_app/resources/string.dart';

import '../../../resources/color.dart';

class SearchLocationScreen extends ConsumerStatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  ConsumerState createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends ConsumerState<SearchLocationScreen>
    with AppSettingMixin {
  @override
  void initState() {
    //listen to error and show toast error
    ref.listenManual(
      searchLocationProvider,
      (previous, next) {
        if (next.error != null) {
          AppToast.showError(next.error!);
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(searchLocationProvider.notifier);
    final state = ref.watch(searchLocationProvider);

    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButton(onPressed: () {
                      context.goNamed(RoutePaths.main);
                    },),

                    Expanded(
                      flex: 13,
                      child: TextFormField(
                        initialValue: state.searchText,
                        onChanged: notifier.find,
                        decoration: InputDecoration(
                          isDense: true,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: AppColors.greyText,
                          ),
                          hintText: AppString.hintSearchLocation,
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildLocations(state))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocations(SearchLocationState state) {
    //if finding locations
    if (state.loading) {
      return CircleLoadingWidget.centered(
        message: AppString.msgLoadingLocations,
      );
    }

    //if haven't entered any text
    if (state == const SearchLocationState.init()) {
      return  const Center(
        child: Text(
          AppString.msgInitSearch,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      );
    }

    //if not found any locations
    if (state.noLocationFound) {
      return Center(
        child: Text(
          AppString.msgNoLocationFound(state.searchText),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      );
    }

    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: state.locations.length,
      itemBuilder: (context, index) {
        final item = state.locations[index];

        return LocationTile(
          location: item,
          searchText: state.searchText,
          onTap: () {
            _handleChooseLocation(item);
          },
        );
      },
    );
  }

  void _handleChooseLocation(Location item) {
    ref.read(localLocationsProvider.notifier).addLocation(item);

    context.goNamed(RoutePaths.main);
  }
}
