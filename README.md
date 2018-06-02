# Loader SearchBar

Flutter widget integrating search field feature into app bar, allowing to receive query change callbacks and automatically load new data set into ListView. It replaces standard AppBar widget and **needs to be placed underneath Scaffold** element in the widget tree to work properly.

![Loader SearchBar demo](https://thumbs.gfycat.com/HealthyAmbitiousImpala-max-14mb.gif)

## Getting started
To start using SearchBar insert it in place of an AppBar element in the Scaffold widget. Regardless of the use case, **defaultAppBar** named argument has to be specified which basically is an AppBar object that will be displayed whenever SearchBar is not activated by user:
```Dart
@override
Widget build(BuildContext context) {
   return Scaffold(
     appBar: SearchBar(
       defaultAppBar: AppBar(
         leading: IconButton(
           icon: Icon(Icons.menu),
           onPressed: _openDrawer,
         ),
         title: Text('Default app bar title'),
       ),
       ...
     ),
     body: _body,
     drawer: _drawer,
   );
}
```

## Optional attributes
 - searchHint - hint text being displayed until user inputs any data
 - iconified - boolean value indicating way of representing non-activated SearchBar:
   - *true* if widget should be showed as an action item in *defaultAppBar*
   - *false* if widget should be merged with *defaufltAppBar* (only search input field and leading icon of the default widget are displayed in such case)
 - autofocus - boolean value determining if search text field should get focus whenever it becomes visible
 - attrs - SearchBarAttrs class instance allowing to specify part of exact values used during widget building (e.g. search bar colors, text size, border radius)
 - onActivatedChanged - callback function receiving widget's current state as a boolean value, triggered whenever user begins or cancels search action

## Query callbacks
To get notified about user input actions specify **onQueryChanged** and/or **onQuerySubmitted** callback functions that receive current query string as an argument:
```Dart
appBar: SearchBar(
   ...
   onQueryChanged: (query) => _handleQueryChanged(context, query),
   onQuerySubmitted: (query) => _handleQuerySubmitted(context, query),
),
```

## QuerySetLoader
By passing QuerySetLoader object as an argument you can additionally benefit from search results being automatically built as ListView widget whenever search query changes:
```Dart
appBar: SearchBar(
  ...
  loader: QuerySetLoader<Item>(
     querySetCall: _getItemListForQuery,	// required
     itemBuilder: _buildItemWidget,     	// required
     loadOnEachChange: true,            	// optional
     animateChanges: true,            		// optional
  ),
),

List<Item> _getItemListForQuery(String query) { ... }

Widget _buildItemWidget(Item item) { ... }
```

 - *querySetCall* - function transforming search query into list of items being then rendered in ListView
 - *itemBuilder* - function creating Widget object for received item, called during ListView building for each element of the results set
 - *loadOnEachChange* - boolean value indicating whether *querySetCall* should be triggered on each query change; if *false* query set is loaded once user submits query
 - *animateChanges* - determining whether ListView's insert and remove operations should be animated

## Contributions
Any kind of contribution to the project is welcomed.
Feel free to request new features, report encountered bugs or pull request changes you've made.
To do so, make use of Pull requests and Issues tabs.
