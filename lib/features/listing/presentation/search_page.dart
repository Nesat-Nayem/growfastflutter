import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/listing/di/listing_injections.dart';
import 'package:grow_first/features/listing/domain/usecases/params/listing_param.dart';
import 'package:grow_first/features/listing/presentation/bloc/listing_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final ListingBloc _listingBloc;
  Timer? _debounce;
  
  List<String> _recentSearches = [];
  final List<String> _popularSearches = [
    'Plumber',
    'Electrician',
    'AC Repair',
    'Cleaning',
    'Carpenter',
    'Painter',
    'Pest Control',
    'Salon',
  ];

  @override
  void initState() {
    super.initState();
    _listingBloc = sl<ListingBloc>();
    // Auto focus on search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    _listingBloc.close();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty) {
        _listingBloc.add(LoadListings(GetListingsParams(
          keyword: query.trim(),
          page: 1,
          perPage: 5,
        )));
      }
    });
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    
    // Add to recent searches
    setState(() {
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 10) {
        _recentSearches = _recentSearches.take(10).toList();
      }
    });
    
    // Navigate to listing page with keyword using go (replaces current route)
    context.go('/listings?keyword=${Uri.encodeComponent(query.trim())}');
  }

  void _clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _listingBloc,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: textBlackColor),
            onPressed: () => context.pop(),
          ),
          title: _buildSearchField(),
          titleSpacing: 0,
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 46,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFF1F3)),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.search, color: Color(0xFF7D8FAB), size: 22),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              style: context.labelMedium.copyWith(fontWeight: FontWeight.w400),
              textInputAction: TextInputAction.search,
              onChanged: _onSearchChanged,
              onSubmitted: _performSearch,
              decoration: InputDecoration(
                hintText: 'Search services...',
                hintStyle: context.labelMedium.copyWith(
                  color: const Color(0xFF7D8FAB),
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, color: Color(0xFF7D8FAB), size: 20),
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ListingBloc, ListingState>(
      bloc: _listingBloc,
      builder: (context, state) {
        // Show search results if user is typing and has results
        if (_searchController.text.isNotEmpty && state.listings.isNotEmpty) {
          return _buildSearchResults(state);
        }
        
        // Show loading indicator while searching
        if (_searchController.text.isNotEmpty && state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Show default content (recent + popular searches)
        return _buildDefaultContent();
      },
    );
  }

  Widget _buildDefaultContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: _clearRecentSearches,
                  child: Text(
                    'Clear All',
                    style: context.labelSmall.copyWith(color: aquaBlueColor),
                  ),
                ),
              ],
            ),
            verticalMargin8,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((search) {
                return _buildSearchChip(
                  search,
                  icon: Icons.history,
                  onTap: () => _performSearch(search),
                  onDelete: () {
                    setState(() {
                      _recentSearches.remove(search);
                    });
                  },
                );
              }).toList(),
            ),
            verticalMargin24,
          ],
          
          // Popular Searches
          Text(
            'Popular Searches',
            style: context.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          verticalMargin12,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularSearches.map((search) {
              return _buildSearchChip(
                search,
                icon: Icons.trending_up,
                onTap: () => _performSearch(search),
              );
            }).toList(),
          ),
          verticalMargin24,
          
          // Quick Categories
          Text(
            'Browse by Category',
            style: context.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          verticalMargin12,
          _buildQuickCategories(),
        ],
      ),
    );
  }

  Widget _buildSearchChip(
    String label, {
    required IconData icon,
    required VoidCallback onTap,
    VoidCallback? onDelete,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF7D8FAB)),
            const SizedBox(width: 6),
            Text(
              label,
              style: context.labelMedium.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 4),
              InkWell(
                onTap: onDelete,
                child: const Icon(Icons.close, size: 16, color: Color(0xFF7D8FAB)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCategories() {
    final categories = [
      {'icon': Icons.plumbing, 'name': 'Plumbing'},
      {'icon': Icons.electrical_services, 'name': 'Electrical'},
      {'icon': Icons.ac_unit, 'name': 'AC Service'},
      {'icon': Icons.cleaning_services, 'name': 'Cleaning'},
      {'icon': Icons.carpenter, 'name': 'Carpentry'},
      {'icon': Icons.format_paint, 'name': 'Painting'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return InkWell(
          onTap: () => _performSearch(category['name'] as String),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: aquaBlueColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: aquaBlueColor.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category['icon'] as IconData,
                  size: 28,
                  color: aquaBlueColor,
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'] as String,
                  style: context.labelSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: textBlackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults(ListingState state) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.listings.length + 1,
      itemBuilder: (context, index) {
        if (index == state.listings.length) {
          // Show "View All Results" button at the end
          return Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () => _performSearch(_searchController.text),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: aquaBlueColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'View All Results',
                style: context.labelMedium.copyWith(color: aquaBlueColor),
              ),
            ),
          );
        }

        final listing = state.listings[index];
        final imageUrl = listing.gallery.isNotEmpty 
            ? listing.gallery.first.img 
            : null;
        
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl.startsWith('http') 
                          ? imageUrl 
                          : 'https://www.growfirst.org/$imageUrl',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : const Icon(Icons.business, color: Colors.grey),
          ),
          title: Text(
            listing.title,
            style: context.labelMedium.copyWith(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            listing.city,
            style: context.labelSmall.copyWith(color: lightGreyTextColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            context.pushNamed(
              AppRouterNames.listingDetail,
              pathParameters: {'listingId': listing.id.toString()},
            );
          },
        );
      },
    );
  }
}
