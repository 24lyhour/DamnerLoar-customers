import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_spacing.dart';
import '../../theme/app_color.dart';
import '../../theme/app_text_style.dart';

class LocationPickerSheet extends StatefulWidget {
  const LocationPickerSheet({
    super.key,
    required this.title,
    required this.locations,
    this.selectedLocation,
    this.showSearch = true,
    this.recentSearches,
    this.popularLocations,
  });

  final String title;
  final List<LocationItem> locations;
  final String? selectedLocation;
  final bool showSearch;
  final List<String>? recentSearches;
  final List<String>? popularLocations;

  static Future<String?> show({
    required String title,
    required List<LocationItem> locations,
    String? selectedLocation,
    bool showSearch = true,
    List<String>? recentSearches,
    List<String>? popularLocations,
  }) async {
    String? selected;
    await Get.bottomSheet(
      LocationPickerSheet(
        title: title,
        locations: locations,
        selectedLocation: selectedLocation,
        showSearch: showSearch,
        recentSearches: recentSearches,
        popularLocations: popularLocations,
      ),
      isScrollControlled: true,
    );
    return selected;
  }

  @override
  State<LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<LocationPickerSheet> {
  final _searchController = TextEditingController();
  List<LocationItem> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _filteredLocations = widget.locations;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredLocations = widget.locations;
      } else {
        _filteredLocations = widget.locations
            .where((loc) =>
                loc.name.toLowerCase().contains(query) ||
                (loc.subtitle?.toLowerCase().contains(query) ?? false))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  widget.title,
                  style: AppTextStyle.subtitle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Search field
          if (widget.showSearch)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search city or station',
                  hintStyle: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.textTertiary,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColor.textSecondary),
                  filled: true,
                  fillColor: AppColor.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),

          // Content
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recent searches
                  if (widget.recentSearches != null &&
                      widget.recentSearches!.isNotEmpty &&
                      _searchController.text.isEmpty) ...[
                    _buildSectionHeader('Recent searches'),
                    ...widget.recentSearches!.map((search) => _buildRecentItem(search)),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Popular locations
                  if (widget.popularLocations != null &&
                      widget.popularLocations!.isNotEmpty &&
                      _searchController.text.isEmpty) ...[
                    _buildSectionHeader('Popular'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: widget.popularLocations!
                            .map((loc) => _buildPopularChip(loc))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Cities & stations
                  _buildSectionHeader('Cities & stations'),
                  ..._filteredLocations.map((location) => _buildLocationTile(location)),

                  SizedBox(height: MediaQuery.of(context).padding.bottom + AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        title,
        style: AppTextStyle.bodySmall.copyWith(
          color: AppColor.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRecentItem(String search) {
    return ListTile(
      leading: const Icon(Icons.history, color: AppColor.textSecondary),
      title: Text(search, style: AppTextStyle.bodyMedium),
      dense: true,
      onTap: () => Get.back(result: search),
    );
  }

  Widget _buildPopularChip(String location) {
    return GestureDetector(
      onTap: () => Get.back(result: location),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Text(
          location,
          style: AppTextStyle.bodySmall,
        ),
      ),
    );
  }

  Widget _buildLocationTile(LocationItem location) {
    final isSelected = location.name == widget.selectedLocation;

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primarySelected : AppColor.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          location.icon ?? Icons.location_city,
          color: isSelected ? AppColor.primary : AppColor.textSecondary,
          size: 20,
        ),
      ),
      title: Text(
        location.name,
        style: AppTextStyle.bodyMedium.copyWith(
          color: isSelected ? AppColor.primary : AppColor.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      subtitle: location.subtitle != null
          ? Text(
              location.subtitle!,
              style: AppTextStyle.caption.copyWith(
                color: AppColor.textSecondary,
              ),
            )
          : null,
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColor.primary)
          : null,
      onTap: () => Get.back(result: location.name),
    );
  }
}

class LocationItem {
  const LocationItem({
    required this.name,
    this.subtitle,
    this.icon,
    this.type = LocationType.city,
  });

  final String name;
  final String? subtitle;
  final IconData? icon;
  final LocationType type;
}

enum LocationType { city, station, operator }

// Predefined Cambodia cities for transport
final cambodiaCities = [
  const LocationItem(
    name: 'Phnom Penh',
    subtitle: 'Capital · 15 stations',
    icon: Icons.location_city,
  ),
  const LocationItem(
    name: 'Siem Reap',
    subtitle: 'Angkor Wat · 12 stations',
    icon: Icons.location_city,
  ),
  const LocationItem(
    name: 'Sihanoukville',
    subtitle: 'Beach city · 8 stations',
    icon: Icons.beach_access,
  ),
  const LocationItem(
    name: 'Battambang',
    subtitle: '6 stations',
    icon: Icons.location_city,
  ),
  const LocationItem(
    name: 'Kampot',
    subtitle: '4 stations',
    icon: Icons.location_city,
  ),
  const LocationItem(
    name: 'Kep',
    subtitle: '2 stations',
    icon: Icons.beach_access,
  ),
  const LocationItem(
    name: 'Koh Kong',
    subtitle: '3 stations',
    icon: Icons.landscape,
  ),
  const LocationItem(
    name: 'Kratie',
    subtitle: 'Dolphins · 3 stations',
    icon: Icons.water,
  ),
  const LocationItem(
    name: 'Mondulkiri',
    subtitle: 'Highlands · 2 stations',
    icon: Icons.terrain,
  ),
  const LocationItem(
    name: 'Ratanakiri',
    subtitle: '2 stations',
    icon: Icons.forest,
  ),
];

// Predefined Cambodia destinations for hotels
final cambodiaHotelDestinations = [
  const LocationItem(
    name: 'Siem Reap, Cambodia',
    subtitle: 'Angkor Wat · 245 hotels',
    icon: Icons.temple_buddhist,
  ),
  const LocationItem(
    name: 'Phnom Penh, Cambodia',
    subtitle: 'Capital · 180 hotels',
    icon: Icons.location_city,
  ),
  const LocationItem(
    name: 'Sihanoukville, Cambodia',
    subtitle: 'Beaches · 120 hotels',
    icon: Icons.beach_access,
  ),
  const LocationItem(
    name: 'Kampot, Cambodia',
    subtitle: 'Riverside · 65 hotels',
    icon: Icons.water,
  ),
  const LocationItem(
    name: 'Kep, Cambodia',
    subtitle: 'Seafood · 35 hotels',
    icon: Icons.set_meal,
  ),
  const LocationItem(
    name: 'Koh Rong, Cambodia',
    subtitle: 'Island · 40 hotels',
    icon: Icons.sailing,
  ),
  const LocationItem(
    name: 'Battambang, Cambodia',
    subtitle: 'Heritage · 30 hotels',
    icon: Icons.account_balance,
  ),
];
