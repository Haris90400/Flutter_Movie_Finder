import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_finder/models/search_category.dart';

// ignore: must_be_immutable
class MainPage extends ConsumerWidget {
  double? _deviceHeight;
  double? _deviceWidth;
  TextEditingController? _searchFieldController;
  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _searchFieldController = TextEditingController();
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: _deviceWidth,
        height: _deviceHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _backgroundWidget(),
            _foregroundWidgets(),
          ],
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    return Container(
      height: _deviceHeight,
      width: _deviceWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: const DecorationImage(
          image: NetworkImage(
            'https://m.media-amazon.com/images/M/MV5BYjM5OTA4MmUtMjY1OC00NWIzLTk0ZTctNGZhOGQzZWU4Y2YzXkEyXkFqcGdeQXVyMTQ3Mzk2MDg4._V1_QL75_UX241_.jpg',
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
      width: _deviceHeight! * 0.88,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTopBar(),
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
        onSubmitted: (value) {},
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
      value: SearchCategory.popular,
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
      onChanged: (_value) {},
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
    );
  }
}