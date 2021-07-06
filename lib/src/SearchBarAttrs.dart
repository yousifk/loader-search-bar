import 'package:flutter/material.dart';

/// Holder class containing attributes used during building [SearchBar] widget
/// that can be adjusted. Each of the attributes is optional and takes its
/// default value if omitted.
class SearchBarAttrs {
  SearchBarAttrs({
    Color primaryDetailColor = Colors.black87,
    this.secondaryDetailColor = Colors.black54,
    this.disabledDetailColor = Colors.black26,
    this.searchBarColor = Colors.white30,
    this.loaderBottomMargin = 0.0,
    this.textBoxOutlineWidth = 1.0,
    this.textBoxOutlineRadius = 16.0,
    this.searchInputMargin = const EdgeInsets.all(0.0),
    this.textBoxOutlineColor,
    this.textBoxBackgroundColor,
    this.statusBarColor = Colors.transparent,
    TextStyle? textStyle,
  })  : this.primaryDetailColor = primaryDetailColor,
        this.textStyle = textStyle ?? _getDefaultTextStyle(primaryDetailColor);

  factory SearchBarAttrs.defaultIconified() => SearchBarAttrs(
      textBoxBackgroundColor: Colors.transparent,
      textBoxOutlineColor: Colors.transparent);

  factory SearchBarAttrs.defaultMerged() => SearchBarAttrs(
      textBoxBackgroundColor: Colors.black12,
      textBoxOutlineColor: Colors.black26);

  static TextStyle _getDefaultTextStyle(Color color) =>
      TextStyle(fontSize: 20.0, color: color);

  final Color primaryDetailColor;
  final Color secondaryDetailColor;
  final Color searchBarColor;
  final Color disabledDetailColor;
  final Color? textBoxBackgroundColor;
  final Color? textBoxOutlineColor;
  final double textBoxOutlineWidth;
  final double textBoxOutlineRadius;
  final double loaderBottomMargin;
  final Color statusBarColor;
  final TextStyle textStyle;
  final EdgeInsets searchInputMargin;
  final double blankInputIconSize = 40.0;
  final double searchBarElevation = 4.0;
  final double cancelSearchMarginLeft = 8.0;
  final double searchTextFieldHeight = 36.0;
  final double searchBarPadding = 4.0;
  final EdgeInsets highlightButtonMargin = EdgeInsets.only(left: 4.0);
  final EdgeInsets clearButtonMargin = EdgeInsets.only(right: 4.0);
  final EdgeInsets searchInputBaseMargin =
      EdgeInsets.symmetric(horizontal: 4.0);
  final EdgeInsets searchTextFieldPadding =
      EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0);
  final Size searchBarSize = Size(360.0, 56.0);

  /// Merges attributes with [other] into new object. Returned instance will
  /// take all attrs of [other] that are not null and source object attributes
  /// otherwise.
  SearchBarAttrs merge(SearchBarAttrs other) {
    return SearchBarAttrs(
      primaryDetailColor: other.primaryDetailColor,
      secondaryDetailColor: other.secondaryDetailColor,
      disabledDetailColor: other.disabledDetailColor,
      searchBarColor: other.searchBarColor,
      textBoxBackgroundColor: other.textBoxBackgroundColor,
      textBoxOutlineColor:
          other.textBoxOutlineColor ?? this.textBoxOutlineColor,
      loaderBottomMargin: other.loaderBottomMargin,
      textBoxOutlineWidth: other.textBoxOutlineWidth,
      textBoxOutlineRadius: other.textBoxOutlineRadius,
      searchInputMargin: other.searchInputMargin,
      statusBarColor: other.statusBarColor,
      textStyle: other.textStyle,
    );
  }
}
