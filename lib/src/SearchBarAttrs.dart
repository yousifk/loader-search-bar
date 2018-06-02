import 'package:flutter/material.dart';

class SearchBarAttrs {
  const SearchBarAttrs({
    this.primaryColor = Colors.black87,
    this.secondaryColor = Colors.black54,
    this.disabledTextColor = Colors.black26,
    this.searchBarColor = Colors.white30,
    this.loaderBottomMargin = 0.0,
    this.textBoxOutlineWidth = 1.0,
    this.textBoxOutlineRadius = 16.0,
    this.textBoxOutlineColor,
    this.textBoxBackgroundColor,
  });

  final Color primaryColor;
  final Color secondaryColor;
  final Color searchBarColor;
  final Color disabledTextColor;
  final Color textBoxBackgroundColor;
  final Color textBoxOutlineColor;
  final double textBoxOutlineWidth;
  final double textBoxOutlineRadius;
  final double searchBoxHorizontalMargin = 4.0;
  final double loaderBottomMargin;
  final double fontSize = 20.0;
  final double blankInputIconSize = 40.0;
  final double searchBarElevation = 4.0;
  final double statusBarHeight = 24.0;
  final double searchTextFieldHeight = 36.0;
  final EdgeInsets highlightButtonMargin = const EdgeInsets.only(left: 4.0);
  final EdgeInsets clearButtonMargin = const EdgeInsets.only(right: 4.0);
  final EdgeInsets searchBarTopMargin = const EdgeInsets.only(top: 24.0);
  final EdgeInsets searchBarPadding = const EdgeInsets.all(4.0);
  final EdgeInsets searchTextFieldPadding =
      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0);
  final Size searchBarSize = const Size(360.0, 56.0);

  SearchBarAttrs merge(SearchBarAttrs other) {
    return SearchBarAttrs(
      primaryColor: other.primaryColor ?? this.primaryColor,
      secondaryColor: other.secondaryColor ?? this.secondaryColor,
      searchBarColor: other.searchBarColor ?? this.searchBarColor,
      textBoxBackgroundColor: other.textBoxBackgroundColor ?? this.textBoxBackgroundColor,
      textBoxOutlineColor: other.textBoxOutlineColor ?? this.textBoxOutlineColor,
      loaderBottomMargin: other.loaderBottomMargin ?? this.loaderBottomMargin,
      textBoxOutlineWidth: other.textBoxOutlineWidth ?? this.textBoxOutlineWidth,
      textBoxOutlineRadius: other.textBoxOutlineRadius ?? this.textBoxOutlineRadius,
    );
  }
}
