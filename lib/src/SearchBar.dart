import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'QuerySetLoader.dart';
import 'SearchBarAttrs.dart';
import 'SearchBarBuilder.dart';
import 'SearchItem.dart';
import 'StateHolder.dart';

/// Search field widget being displayed within Scaffold element.
/// Depending on its state and passed attributes it can be rendered
/// as an appBar action, expanded to its full size when activated or merged
/// with appBar, making the search field visible although not activated.
///
/// SearchBar needs to be placed underneath Scaffold element in the
/// widget tree, in place of the original AppBar.
///
/// Specifying [onQueryChanged], [onQuerySubmitted] allows to receive callbacks
/// whenever user input occurs.
/// If [loader] argument is passed, data set will be automatically loaded when
/// query changes (or is submitted). When it happens, widget will change its
/// preferred size requested by Scaffold ancestor, making the ListView take
/// whole available space below app bar. Once user cancels search action
/// (navigates back) widget is rebuilt with default app bar size making
/// Scaffold body visible again.
class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  SearchBar({
    @required this.defaultBar,
    this.onQueryChanged,
    this.onQuerySubmitted,
    this.loader,
    this.overlayStyle,
    this.searchHint = 'Tap to search...',
    this.iconified = true,
    bool autofocus,
    SearchItem searchItem,
    ValueChanged<bool> onActivatedChanged,
    SearchBarAttrs attrs,
  })  : this.autofocus = autofocus ?? iconified,
        this.searchItem = searchItem ?? SearchItem.action(),
        this.attrs = _initAttrs(iconified, attrs),
        this.activatedChangedCallback =
            onActivatedChanged ?? _blankActivatedCallback;

  static SearchBarAttrs _initAttrs(bool iconified, SearchBarAttrs attrs) {
    final defaultAttrs =
        iconified ? _defaultIconifiedAttrs : _defaultMergedAttrs;
    return attrs != null ? defaultAttrs.merge(attrs) : defaultAttrs;
  }

  static final _defaultIconifiedAttrs = SearchBarAttrs(
    textBoxBackgroundColor: Colors.transparent,
    textBoxOutlineColor: Colors.transparent,
  );

  static final _defaultMergedAttrs = SearchBarAttrs(
    textBoxBackgroundColor: Colors.black12,
    textBoxOutlineColor: Colors.black26,
  );

  bool get _shouldTakeWholeSpace =>
      (_stateHolder.value?.activated ?? false) && loader != null;

  Size get _tryGetScreenSize {
    final context = _stateHolder.value?.context;
    return (context != null) ? MediaQuery.of(context).size : null;
  }

  Size get _tryGetAvailableSpace {
    final screenSize = _tryGetScreenSize;
    return (screenSize != null)
        ? Size(screenSize.width, screenSize.height - attrs.loaderBottomMargin)
        : null;
  }

  final _stateHolder = StateHolder<SearchBarState>();

  /// Function being called whenever query changes with its current value
  /// as an argument.
  final ValueChanged<String> onQueryChanged;

  /// Function being called whenever query is submitted with its current value
  /// as an argument.
  final ValueChanged<String> onQuerySubmitted;

  /// Widget automatically loading data corresponding to current query
  /// and displaying it in ListView.
  final QuerySetLoader loader;

  /// SearchBarAttrs instance allowing to specify part of exact values used
  /// during widget building.
  final SearchBarAttrs attrs;

  /// AppBar widget that will be displayed whenever SearchBar is not in
  /// activated state.
  final AppBar defaultBar;

  /// Hint string being displayed until user inputs any text.
  final String searchHint;

  /// Indicating way of representing non-activated SearchBar:
  ///   true if widget should be showed as an action item in defaultAppBar,
  ///   false if widget should be merged with defaultAppBar.
  final bool iconified;

  /// Determining if search field should get focus once it becomes visible.
  final bool autofocus;

  /// Callback function receiving widget's current state whenever user begins
  /// or cancels/ends search action.
  final ValueChanged<bool> activatedChangedCallback;

  /// Defining how to position and build search item widget in AppBar.
  final SearchItem searchItem;

  /// Status bar overlay brightness applied when widget is activated.
  final SystemUiOverlayStyle overlayStyle;

  static final ValueChanged<bool> _blankActivatedCallback = (_) {};

  @override
  Size get preferredSize {
    return _shouldTakeWholeSpace
        ? _tryGetAvailableSpace ?? attrs.searchBarSize
        : attrs.searchBarSize;
  }

  @override
  State createState() => _stateHolder.applyState(SearchBarState());
}

class SearchBarState extends State<SearchBar> {
  final FocusNode searchFocusNode = FocusNode();

  final TextEditingController queryInputController = TextEditingController();

  QuerySetLoader get _safeLoader => widget.loader ?? QuerySetLoader.blank;

  bool activated = false;

  bool focused = false;

  bool queryNotEmpty = false;

  bool isClearingQuery = false;

  bool expanded;

  String loaderQuery;

  Orientation currentOrientation;

  EdgeInsets get screenPadding => MediaQuery.of(context).padding;

  @override
  void initState() {
    super.initState();
    expanded = !widget.iconified;
    queryInputController.addListener(_onQueryControllerChange);
    searchFocusNode.addListener(_onSearchFocusChange);
  }

  void _onQueryControllerChange() {
    queryNotEmpty = queryInputController.text.isNotEmpty;
    if (isClearingQuery) {
      isClearingQuery = false;
      onTextChange('');
    }
  }

  void onTextChange(String text) {
    setState(() {
      if (_safeLoader.loadOnEachChange) loaderQuery = text;
    });
    if (widget.onQueryChanged != null) widget.onQueryChanged(text);
  }

  void onTextSubmit(String text) {
    setState(() {
      if (!_safeLoader.loadOnEachChange) loaderQuery = text;
    });
    if (widget.onQuerySubmitted != null) widget.onQuerySubmitted(text);
  }

  void _onSearchFocusChange() {
    setState(() {
      focused = searchFocusNode.hasFocus;
      if (focused && !activated) {
        activated = true;
        widget.activatedChangedCallback(true);
      }
    });
  }

  void onCancelSearch() {
    setState(() {
      if (activated) {
        activated = false;
        widget.activatedChangedCallback(false);
      }
      if (widget.iconified) expanded = false;
      loaderQuery = null;
    });
    queryInputController.clear();
    searchFocusNode.unfocus();
    widget.loader?.clearData();
  }

  void _redrawScaffold() {
    Future.delayed(
      Duration(milliseconds: 0),
      () => Scaffold.of(context).setState(() {}),
    );
  }

  void onPrefixSearchTap() {
    FocusScope.of(context).requestFocus(searchFocusNode);
    _highlightQueryText();
  }

  void _highlightQueryText() {
    queryInputController.selection = TextSelection(
      baseOffset: queryInputController.value.text.length,
      extentOffset: 0,
    );
  }

  void onClearQuery() {
    if (queryNotEmpty) {
      _clearQueryField();
    } else {
      searchFocusNode.unfocus();
    }
  }

  void _clearQueryField() {
    isClearingQuery = true;
    queryInputController.clear();
  }

  void onSearchAction() {
    setState(() {
      expanded = true;
    });
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    queryInputController.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() {
    bool shouldPop;
    if (activated) {
      onCancelSearch();
      shouldPop = false;
    } else {
      shouldPop = true;
    }
    return Future.value(shouldPop);
  }

  void _handleOrientationIfChanged(BuildContext context) async {
    final orientation = MediaQuery.of(context).orientation;
    if (currentOrientation != orientation) {
      currentOrientation = orientation;
      _redrawScaffold();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loader != null) {
      _handleOrientationIfChanged(context);
    }
    return SearchBarBuilder(this, context);
  }
}
