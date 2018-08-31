import 'dart:io' show Platform;
import 'package:flutter/material.dart';

/// Holder class containing attributes used during building [SearchBar] widget
/// that can be adjusted. Each of the attributes is optional and takes its
/// default value if omitted.
class SearchBarAttrs {
  SearchBarAttrs({
    this.primaryDetailColor = Colors.black87,
    this.secondaryDetailColor = Colors.black54,
    this.disabledDetailColor = Colors.black26,
    this.searchBarColor = Colors.white30,
    this.loaderBottomMargin = 0.0,
    this.textBoxOutlineWidth = 1.0,
    this.textBoxOutlineRadius = 16.0,
    this.textBoxOutlineColor,
    this.textBoxBackgroundColor,
  });

  static SearchBarPlatformAttrs _platformAttrs = SearchBarPlatformAttrs.create();

  final Color primaryDetailColor;
  final Color secondaryDetailColor;
  final Color searchBarColor;
  final Color disabledDetailColor;
  final Color textBoxBackgroundColor;
  final Color textBoxOutlineColor;
  final double textBoxOutlineWidth;
  final double textBoxOutlineRadius;
  final double searchBoxHorizontalMargin = 4.0;
  final double loaderBottomMargin;
  final double fontSize = 20.0;
  final double blankInputIconSize = 40.0;
  final double searchBarElevation = 4.0;
  final double cancelSearchMarginLeft = 8.0;
  final double statusBarHeight = _platformAttrs.statusBarHeight;
  final double searchTextFieldHeight = 36.0;
  final EdgeInsets highlightButtonMargin = EdgeInsets.only(left: 4.0);
  final EdgeInsets clearButtonMargin = EdgeInsets.only(right: 4.0);
  final EdgeInsets searchBarDefaultTopMargin =
      EdgeInsets.only(top: _platformAttrs.statusBarHeight);
  final EdgeInsets searchBarNoTopMargin = EdgeInsets.only(top: 2.0);
  final EdgeInsets searchBarPadding = EdgeInsets.all(4.0);
  final EdgeInsets searchTextFieldPadding =
      EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0);
  final Size searchBarSize = Size(360.0, _platformAttrs.appBarHeight);

  /// Merges attributes with [other] into new object. Returned instance will
  /// take all attrs of [other] that are not null and source object attributes
  /// otherwise.
  SearchBarAttrs merge(SearchBarAttrs other) {
    return SearchBarAttrs(
      primaryDetailColor: other.primaryDetailColor ?? this.primaryDetailColor,
      secondaryDetailColor:
          other.secondaryDetailColor ?? this.secondaryDetailColor,
      searchBarColor: other.searchBarColor ?? this.searchBarColor,
      textBoxBackgroundColor:
          other.textBoxBackgroundColor ?? this.textBoxBackgroundColor,
      textBoxOutlineColor:
          other.textBoxOutlineColor ?? this.textBoxOutlineColor,
      loaderBottomMargin: other.loaderBottomMargin ?? this.loaderBottomMargin,
      textBoxOutlineWidth:
          other.textBoxOutlineWidth ?? this.textBoxOutlineWidth,
      textBoxOutlineRadius:
          other.textBoxOutlineRadius ?? this.textBoxOutlineRadius,
    );
  }
}

abstract class SearchBarPlatformAttrs {

  static SearchBarPlatformAttrs create() {
    if (Platform.isAndroid) return SearchBarAndroidAttrs();
    if (Platform.isIOS) return SearchBarIosAttrs();
    throw Exception('Not supported platform.');
  }

  const SearchBarPlatformAttrs({
    @required this.statusBarHeight,
    @required this.appBarHeight,
  });

  final double statusBarHeight;
  final double appBarHeight;
}

class SearchBarAndroidAttrs extends SearchBarPlatformAttrs {
  SearchBarAndroidAttrs() : super(statusBarHeight: 24.0, appBarHeight: 56.0);
}

class SearchBarIosAttrs extends SearchBarPlatformAttrs {
  SearchBarIosAttrs() : super(statusBarHeight: 20.0, appBarHeight: 56.0);
}
