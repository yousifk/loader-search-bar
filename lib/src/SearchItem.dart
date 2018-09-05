import 'package:flutter/material.dart';
import 'package:loader_search_bar/src/SearchItemGravity.dart';

typedef T SearchItemBuilder<T>(BuildContext context);
typedef PopupMenuItem<T> MenuItemBuilder<T>(BuildContext context);

enum SearchItemType { ACTION, MENU }

class SearchItem<T> {
  SearchItem._internal(this.type, this.gravity, this.builder);

  SearchItemType type;
  SearchItemGravity gravity;
  SearchItemBuilder<T> builder;

  static action({SearchItemGravity gravity, WidgetBuilder builder}) =>
      SearchItem<Widget>._internal(
        SearchItemType.ACTION,
        gravity ?? _defaultGravity,
        builder ?? _defaultActionBuilder,
      );

  static menu<T>({SearchItemGravity gravity, MenuItemBuilder<T> builder}) =>
      SearchItem<PopupMenuItem<T>>._internal(
        SearchItemType.MENU,
        gravity ?? _defaultGravity,
        builder ?? _defaultMenuBuilder,
      );

  static final SearchItemGravity _defaultGravity = SearchItemGravity.start;
  static final WidgetBuilder _defaultActionBuilder =
      (_) => IconButton(icon: Icon(Icons.search), onPressed: () {});
  static final MenuItemBuilder _defaultMenuBuilder =
      (_) => PopupMenuItem<Object>(child: Text('Search'), value: Object());
}
