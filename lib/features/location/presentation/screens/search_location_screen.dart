import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/common/navigation/route_paths.dart';
import 'package:weather_app/common/widget/app_loading.dart';
import 'package:weather_app/core/utils/app_toast.dart';
import 'package:weather_app/core/utils/focus_utils.dart';
import 'package:weather_app/features/location/data/models/location_model.dart';
import 'package:weather_app/features/location/presentation/providers/location_providers.dart';
import 'package:weather_app/features/location/presentation/widgets/location_tile.dart';
import 'package:weather_app/resources/color.dart';
import 'package:weather_app/resources/string.dart';

class SearchLocationScreen extends ConsumerStatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  ConsumerState createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends ConsumerState<SearchLocationScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    ref.listenManual(searchLocationProvider, (previous, next) {
      if (next.error != null) AppToast.showError(next.error!);
    });
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(searchLocationProvider.notifier);
    final state = ref.watch(searchLocationProvider);

    return GestureDetector(
      onTap: () => unFocus(context),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B1437), Color(0xFF1B1050), Color(0xFF0B1437)],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, notifier),
                Expanded(child: _buildBody(state)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SearchLocationNotifier notifier) {
    final canPop = GoRouter.of(context).canPop();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: back button + title
          Row(
            children: [
              if (canPop)
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 38,
                    height: 38,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: AppColors.glass,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white70, size: 16),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    canPop ? 'Add Location' : 'Get Started',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Search for a city',
                    style: TextStyle(fontSize: 13, color: Colors.white38),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search field
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: notifier.find,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.glass,
                  hintText: AppString.hintSearchLocation,
                  hintStyle:
                      const TextStyle(color: Colors.white38, fontSize: 14),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: AppColors.accent, width: 1.5),
                  ),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: Colors.white38, size: 20),
                  suffixIcon: ValueListenableBuilder(
                    valueListenable: _searchController,
                    builder: (_, value, __) => value.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              notifier.find('');
                            },
                            child: const Icon(Icons.close_rounded,
                                color: Colors.white38, size: 18),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SearchLocationState state) {
    if (state.loading) {
      return CircleLoadingWidget.centered(
        message: AppString.msgLoadingLocations,
      );
    }

    if (state == const SearchLocationState.init()) {
      return _EmptyState(
        icon: Icons.travel_explore_rounded,
        message: AppString.msgInitSearch,
      );
    }

    if (state.noLocationFound) {
      return _EmptyState(
        icon: Icons.location_off_outlined,
        message: AppString.msgNoLocationFound(state.searchText),
      );
    }

    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(top: 4, bottom: 24),
      itemCount: state.locations.length,
      itemBuilder: (context, index) {
        final item = state.locations[index];
        return LocationTile(
          location: item,
          staggerIndex: index,
          onTap: () => _handleChooseLocation(item),
        );
      },
    );
  }

  void _handleChooseLocation(LocationModel item) async {
    final notifier = ref.read(localLocationsProvider.notifier);
    await Future.delayed(Duration.zero, () async => notifier.addLocation(item));
    if (mounted) context.goNamed(RoutePaths.main);
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.white12),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white38,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
