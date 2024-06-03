import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_finder/controller/main_page_data_controller.dart';
import 'package:movie_finder/models/main_page_data.dart';
import 'package:movie_finder/models/movie.dart';
import 'package:movie_finder/models/search_category.dart';
import 'package:movie_finder/widgets/movie_tile.dart';

final MainPageDataProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>(
  (ref) {
    return MainPageDataController();
  },
);

StateProvider<String> selectedMoviePosterUrlProvider =
    StateProvider<String>((ref) {
  final _movies = ref.watch(MainPageDataProvider).movies;
  return _movies.isNotEmpty ? _movies[0].posterUrl() : '';
});

class MainPage extends ConsumerStatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  double? _deviceHeight;
  double? _deviceWidth;
  TextEditingController? _searchFieldController;
  MainPageDataController? _mainPageDataController;
  MainPageData? _mainPageData;

  @override
  void initState() {
    super.initState();
    _searchFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _searchFieldController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _mainPageDataController = ref.watch(
      MainPageDataProvider.notifier,
    );
    _mainPageData = ref.watch(
      MainPageDataProvider,
    );

    _searchFieldController!.text = _mainPageData!.searchText;

    final _selectedMoviePosterUrl = ref.watch(selectedMoviePosterUrlProvider);

    return _buildUI(_selectedMoviePosterUrl);
  }

  Widget _buildUI(String? selectedMoviePosterUrl) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SizedBox(
        width: _deviceWidth,
        height: _deviceHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _backgroundWidget(selectedMoviePosterUrl),
            _foregroundWidgets(),
          ],
        ),
      ),
    );
  }

  Widget _backgroundWidget(String? selectedMoviePosterUrl) {
    return Container(
      height: _deviceHeight,
      width: _deviceWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(
            selectedMoviePosterUrl!,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15.0,
          sigmaY: 15.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget _foregroundWidgets() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, _deviceHeight! * 0.02),
      width: _deviceWidth! * 0.88,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTopBar(),
          Container(
            height: _deviceHeight! * 0.83,
            padding: EdgeInsets.symmetric(
              vertical: _deviceHeight! * 0.01,
            ),
            child: _movieListViewWidget(),
          )
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: _deviceHeight! * 0.08,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _searchFieldWidget(),
          _dropDownCategory(),
        ],
      ),
    );
  }

  Widget _searchFieldWidget() {
    return SizedBox(
      width: _deviceWidth! * 0.50,
      height: _deviceHeight! * 0.05,
      child: TextField(
        controller: _searchFieldController,
        onSubmitted: (value) {
          print("Before: $value");
          _mainPageDataController!.updateTextSearch(value);
          print("After: ${_mainPageData!.searchText}");
        },
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white24,
          ),
          hintStyle: TextStyle(
            color: Colors.white54,
          ),
          filled: false,
          fillColor: Colors.white24,
          hintText: "Search....",
        ),
      ),
    );
  }

  Widget _dropDownCategory() {
    return DropdownButton(
      value: _mainPageData!.category,
      dropdownColor: Colors.black38,
      icon: const Icon(
        Icons.menu,
        color: Colors.white24,
      ),
      items: [
        DropdownMenuItem(
          child: Text(
            SearchCategory.popular,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          value: SearchCategory.popular,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.upcoming,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          value: SearchCategory.upcoming,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.none,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          value: SearchCategory.none,
        ),
      ],
      onChanged: (_value) => _value.toString().isNotEmpty
          ? _mainPageDataController!.updateCategory(
              _value.toString(),
            )
          : null,
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
    );
  }

  Widget _movieListViewWidget() {
    final List<Movie> _movies = _mainPageData!.movies;

    if (_movies.isNotEmpty) {
      return NotificationListener(
        onNotification: ((notification) {
          if (notification is ScrollEndNotification) {
            final before = notification.metrics.extentBefore;
            final max = notification.metrics.maxScrollExtent;
            if (before == max) {
              _mainPageDataController!.getMovies();
              return true;
            }
            return false;
          }
          return false;
        }),
        child: ListView.builder(
          itemCount: _movies.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: _deviceHeight! * 0.01,
                horizontal: 0,
              ),
              child: GestureDetector(
                onTap: () {
                  ref.read(selectedMoviePosterUrlProvider.notifier).state =
                      _movies[index].posterUrl();
                  print(_movies[index].posterUrl());
                },
                child: MovieTile(
                  height: _deviceHeight! * 0.20,
                  width: _deviceWidth! * 0.85,
                  movie: _movies[index],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }
}
