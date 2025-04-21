import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workify/models/tag.dart';
import 'package:workify/widget/tag_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Tag> _results = [];
  List<String> _recentSearches = [];
  Timer? _debounce;
  // String? _selectedCategory;
  // double _minPrice = 0;
  // double _maxPrice = 500;
  // double _minRating = 0;
  // SpeechToText _speech = SpeechToText();
  // String? imagePath;
  bool _showSearchUI = false;

  @override
  void initState() {
    super.initState();
    // fetchImagePath();
    _loadRecentSearches();
    _results = listOfTags;
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    final filtered = listOfTags.where((tag) {
      final matchesQuery = tag.categoryName.toLowerCase().contains(
            query.toLowerCase(),
          );
      return matchesQuery;
    }).toList();

    setState(() {
      _results = filtered;
    });

    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      _saveSearch(query);
    }
  }

  Future<void> _saveSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.insert(0, query);
    _recentSearches = _recentSearches.take(5).toList();
    prefs.setStringList('recentSearches', _recentSearches);
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('recentSearches') ?? [];
    setState(() {
      _recentSearches = saved;
    });
  }

  // void _startVoiceSearch() async {
  //   bool available = await _speech.initialize();
  //   if (available) {
  //     _speech.listen(onResult: (result) {
  //       _searchController.text = result.recognizedWords;
  //       _performSearch(result.recognizedWords);
  //     });
  //   }
  // }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _results = listOfTags;
      _showSearchUI = false;
    });
  }

  void _resetFilters() {
    // setState(() {
    //   _selectedCategory = null;
    //   _minPrice = 0;
    //   _maxPrice = 500;
    //   _minRating = 0;
    // });
    _performSearch(_searchController.text);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    // _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showSearchUI = true;
                });
              },
              child: AbsorbPointer(
                absorbing: !_showSearchUI,
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: "Search . . .",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _showSearchUI
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: _clearSearch,
                              ),
                              // IconButton(
                              //   icon: Icon(Icons.mic),
                              //   onPressed: _startVoiceSearch,
                              // ),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
          if (_showSearchUI) ...[
            if (_recentSearches.isNotEmpty)
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _recentSearches
                      .map(
                        (s) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          child: ActionChip(
                            label: Text(s),
                            onPressed: () {
                              _searchController.text = s;
                              _performSearch(s);
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // DropdownButton<String>(
                  //   hint: Text('Category'),
                  //   value: _selectedCategory,
                  //   onChanged: (value) {
                  //     setState(() => _selectedCategory = value);
                  //     _performSearch(_searchController.text);
                  //   },
                  //   items: [
                  //     'Design',
                  //     'Programming',
                  //     'Marketing',
                  //     'Writing',
                  //     'Video',
                  //   ]
                  //       .map(
                  //         (c) => DropdownMenuItem(value: c, child: Text(c)),
                  //       )
                  //       .toList(),
                  // ),
                  Spacer(),
                  // Text('Price'),
                  // RangeSlider(
                  //   values: RangeValues(_minPrice, _maxPrice),
                  //   min: 0,
                  //   max: 500,
                  //   divisions: 10,
                  //   labels: RangeLabels(
                  //       '\$${_minPrice.toInt()}', '\$${_maxPrice.toInt()}'),
                  //   onChanged: (range) {
                  //     setState(() {
                  //       _minPrice = range.start;
                  //       _maxPrice = range.end;
                  //     });
                  //     _performSearch(_searchController.text);
                  //   },
                  // )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  // Text('Min Rating:'),
                  // SizedBox(width: 8),
                  // RatingBar.builder(
                  //   initialRating: _minRating,
                  //   minRating: 0,
                  //   direction: Axis.horizontal,
                  //   itemCount: 5,
                  //   itemSize: 24,
                  //   allowHalfRating: true,
                  //   itemBuilder: (context, _) =>
                  //       Icon(Icons.star, color: Colors.amber),
                  //   onRatingUpdate: (rating) {
                  //     setState(() => _minRating = rating);
                  //     _performSearch(_searchController.text);
                  //   },
                  // ),
                  Spacer(),
                  TextButton.icon(
                    onPressed: _resetFilters,
                    icon: Icon(Icons.refresh),
                    label: Text('Reset'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _results.isEmpty
                  ? Center(child: Text('No results found'))
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) =>
                          TagTile(tag: _results[index]),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
