import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'InheritedSearchWidget.dart';
import 'SearchBar.dart';
import 'SearchBarAttrs.dart';
import 'SearchBarButton.dart';
import 'SearchItem.dart';

class SearchBarBuilder extends StatelessWidget {
  SearchBarBuilder(this._state, this._context)
      : _widget = _state.widget,
        _attrs = _state.widget.attrs;

  final SearchBar _widget;

  final SearchBarAttrs _attrs;

  final SearchBarState _state;

  final BuildContext _context;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _state.onWillPop,
      child: _buildSearchBarWidget(),
    );
  }

  Widget _buildSearchBarWidget() {
    final appBar = _buildAppBar();
    if (_widget.loader != null) {
      return _wrapWithLoader(appBar);
    } else {
      return appBar;
    }
  }

  Widget _wrapWithLoader(Widget appBar) {
    return Stack(
      children: [
        Positioned(
          top: _searchBarTotalHeight,
          height: _loaderHeight,
          left: 0.0,
          right: 0.0,
          child: _buildLoaderWidget(),
        ),
        Positioned(
          top: 0.0,
          height: _searchBarTotalHeight,
          left: 0.0,
          right: 0.0,
          child: appBar,
        ),
      ],
    );
  }

  Widget _buildLoaderWidget() {
    return InheritedSearchQuery(
      query: _state.loaderQuery,
      child: _widget.loader,
    );
  }

  Widget _buildAppBar() {
    if (isInDefaultState) {
      return _buildIconifiedBar();
    } else if (isInMergedState) {
      return _buildMergedBar();
    } else {
      return _buildSearchBar();
    }
  }

  bool get isInDefaultState => _widget.iconified && !_state.expanded;

  bool get isInMergedState => !_widget.iconified && !_state.activated;

  Widget _buildIconifiedBar() {
    final actions = <Widget>[]..addAll(_widget.defaultBar.actions ?? []);
    final itemType = _widget.searchItem.type;
    switch (itemType) {
      case SearchItemType.ACTION:
        addSearchActionItem(actions);
        break;
      case SearchItemType.MENU:
        addSearchMenuItem(actions);
        break;
      default:
        throw Exception(
            "Attempted to build SearchItem of unknown type: $itemType.");
    }
    return _cloneDefaultBarWith(actions);
  }

  void addSearchActionItem(List<Widget> actions) {
    final item = InkWell(
      onTap: _state.onSearchAction,
      child: AbsorbPointer(
        child: _widget.searchItem.builder(_context),
      ),
    );
    final index = _widget.searchItem.gravity.getInsertPosition(actions);
    actions.insert(index, item);
  }

  void addSearchMenuItem(List<Widget> actions) {
    final menuIndex = actions.lastIndexWhere((it) => it is PopupMenuButton);
    final menu = menuIndex != -1 ? actions[menuIndex] : _defaultMenu;
    final wrapperIndex = menuIndex != -1 ? menuIndex : actions.length;
    final menuWrapper = wrapMenuWithSearchItem(menu);
    actions
      ..remove(menu)
      ..insert(wrapperIndex, menuWrapper);
  }

  PopupMenuButton get _defaultMenu => PopupMenuButton(itemBuilder: (_) => []);

  PopupMenuButton wrapMenuWithSearchItem(PopupMenuButton menu) {
    final searchItem = _widget.searchItem.builder(_context) as PopupMenuItem;
    return PopupMenuButton(
      itemBuilder: (context) {
        final items = menu.itemBuilder(context);
        final searchIndex = _widget.searchItem.gravity.getInsertPosition(items);
        return items..insert(searchIndex, searchItem);
      },
      onSelected: (value) {
        if (value == searchItem.value) {
          _state.onSearchAction();
        } else {
          menu.onSelected(value);
        }
      },
    );
  }

  AppBar _cloneDefaultBarWith(List<Widget> actions) {
    final defaultBar = _widget.defaultBar;
    return AppBar(
      toolbarOpacity: defaultBar.toolbarOpacity,
      textTheme: defaultBar.textTheme,
      primary: defaultBar.primary,
      iconTheme: defaultBar.iconTheme,
      flexibleSpace: defaultBar.flexibleSpace,
      centerTitle: defaultBar.centerTitle,
      brightness: defaultBar.brightness,
      bottomOpacity: defaultBar.bottomOpacity,
      backgroundColor: defaultBar.backgroundColor,
      leading: defaultBar.leading,
      automaticallyImplyLeading: defaultBar.automaticallyImplyLeading,
      titleSpacing: defaultBar.titleSpacing,
      elevation: defaultBar.elevation,
      bottom: defaultBar.bottom,
      key: defaultBar.key,
      title: defaultBar.title,
      actions: actions,
    );
  }

  Widget _buildMergedBar() {
    return _buildBaseBar(
      leading:
          _widget.defaultBar.leading ?? _buildScaffoldDefaultLeading(_context),
      search: _buildSearchStackContainer(),
      actions: _widget.defaultBar.actions ?? [],
    );
  }

  Widget _buildScaffoldDefaultLeading(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final hasDrawer = scaffold?.hasDrawer ?? false;
    final parentRoute = ModalRoute.of(context);
    final canPop = parentRoute?.canPop ?? false;
    final useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    if (hasDrawer) {
      return IconButton(
        icon: Icon(Icons.menu),
        onPressed: scaffold.openDrawer,
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      );
    } else if (canPop) {
      return useCloseButton ? CloseButton() : BackButton();
    } else {
      return null;
    }
  }

  Widget _buildSearchBar() {
    return _buildBaseBar(
      leading: _buildCancelSearchButton(),
      search: _buildSearchStackContainer(),
    );
  }

  Widget _buildBaseBar({Widget leading, Widget search, List<Widget> actions}) {
    final barContent = _buildBaseBarContent(leading, search, actions);
    final barWidget = _buildBaseBarWidget(barContent);
    return _wrapWithOverlayIfPresent(barWidget);
  }

  List<Widget> _buildBaseBarContent(
      Widget leading, Widget search, List<Widget> actions) {
    return []
      ..add(Container(width: _attrs.searchBarPadding))
      ..add(leading)
      ..add(search)
      ..add(Container(width: _attrs.searchBarPadding))
      ..addAll(actions ?? [])
      ..removeWhere((it) => it == null);
  }

  Material _buildBaseBarWidget(List barContent) {
    return Material(
      borderRadius: BorderRadius.zero,
      elevation: _attrs.searchBarElevation,
      child: Container(
        height: _searchBarTotalHeight,
        color: _attrs.statusBarColor,
        child: SafeArea(
          bottom: false,
          child: Container(
            color: _attrs.searchBarColor,
            child: Row(children: barContent),
          ),
        ),
      ),
    );
  }

  Widget _wrapWithOverlayIfPresent(Widget widget) {
    if (_widget.overlayStyle != null) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: _widget.overlayStyle,
        child: widget,
      );
    } else {
      return widget;
    }
  }

  Widget _buildCancelSearchButton() {
    return SearchBarButton(
      icon: Icons.arrow_back,
      color: _attrs.primaryDetailColor,
      onPressed: _state.onCancelSearch,
      marginHorizontal: _attrs.cancelSearchMarginLeft,
    );
  }

  Widget _buildSearchStackContainer() {
    return Expanded(
      child: Container(
        height: _attrs.searchTextFieldHeight,
        margin: _attrs.searchInputMargin,
        padding: _attrs.searchInputBaseMargin,
        decoration: _buildSearchTextBoxDecoration(),
        child: _buildSearchStack(),
      ),
    );
  }

  Widget _buildSearchStack() {
    return Stack(
      children: [
        _buildSearchTextField(),
        _buildHighlightButton(),
        _state.focused ? _buildClearButton() : null,
      ].where((it) => it != null).toList(),
    );
  }

  Widget _buildSearchTextField() {
    return Positioned.fill(
      child: Center(
        child: TextField(
          style: TextStyle(
            color: _attrs.primaryDetailColor,
            fontSize: _attrs.fontSize,
          ),
          autofocus: _widget.autofocus,
          focusNode: _state.searchFocusNode,
          controller: _state.queryInputController,
          onChanged: _state.onTextChange,
          onSubmitted: _state.onTextSubmit,
          decoration: _buildSearchTextFieldDecoration(),
        ),
      ),
    );
  }

  BoxDecoration _buildSearchTextBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: _attrs.textBoxOutlineColor,
        width: _attrs.textBoxOutlineWidth,
      ),
      borderRadius:
          BorderRadius.all(Radius.circular(_attrs.textBoxOutlineRadius)),
      color: _attrs.textBoxBackgroundColor,
    );
  }

  InputDecoration _buildSearchTextFieldDecoration() {
    return InputDecoration(
      contentPadding: _attrs.searchTextFieldPadding,
      border: InputBorder.none,
      hintText: _widget.searchHint,
      hintStyle: TextStyle(
          color: !_state.focused
              ? _attrs.secondaryDetailColor
              : _attrs.disabledDetailColor),
    );
  }

  Widget _buildHighlightButton() {
    return Positioned(
      left: 0.0,
      top: 0.0,
      bottom: 0.0,
      child: Container(
        margin: _attrs.highlightButtonMargin,
        child: SearchBarButton(
          icon: Icons.search,
          color: _state.queryNotEmpty || !_state.focused
              ? _attrs.primaryDetailColor
              : _attrs.secondaryDetailColor,
          onPressed: _state.onPrefixSearchTap,
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return Positioned(
      right: 0.0,
      top: 0.0,
      bottom: 0.0,
      child: Container(
        margin: _attrs.clearButtonMargin,
        child: SearchBarButton(
          icon: Icons.clear,
          color: _state.queryNotEmpty
              ? _attrs.primaryDetailColor
              : _attrs.secondaryDetailColor,
          onPressed: _state.onClearQuery,
        ),
      ),
    );
  }

  double get _searchBarTotalHeight =>
      _attrs.searchBarSize.height + _state.screenPadding.top;

  double get _loaderHeight =>
      _widget.preferredSize.height - _searchBarTotalHeight;
}
