import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:loader_search_bar/loader_search_bar.dart';

enum Example { CALLBACK, LOADER }

void main() => _runExample(Example.LOADER);

void _runExample(Example example) {
  runApp(MaterialApp(
    home: example == Example.CALLBACK
        ? CallbackSearchBarPage()
        : LoaderSearchBarPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class CallbackSearchBarPage extends StatefulWidget {
  @override
  CallbackSearchBarPageState createState() => CallbackSearchBarPageState();
}

class CallbackSearchBarPageState extends State<CallbackSearchBarPage> {
  String _queryText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(
        iconified: false,
        defaultBar: AppBar(),
        onQueryChanged: (query) => _onQueryChanged(context, query),
        onQuerySubmitted: (query) => _onQuerySubmitted(context, query),
      ),
      body: _body,
      drawer: _drawer,
    );
  }

  Container get _body {
    return Container(
      color: Colors.black12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Callback example', style: TextStyle(fontSize: 18.0)),
          Container(margin: EdgeInsets.only(top: 8.0)),
          Text(_queryText, style: TextStyle(fontSize: 18.0)),
        ],
      ),
    );
  }

  _onQueryChanged(BuildContext context, String query) {
    setState(() => _queryText = 'Query changed: $query');
  }

  _onQuerySubmitted(BuildContext context, String query) {
    setState(() => _queryText = 'Query submitted!');
  }
}

class LoaderSearchBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(
        iconified: true,
        searchItem: SearchItem.menu(
          builder: (_) => PopupMenuItem(
                child: Text("Search  🔍"),
                value: "search",
              ),
          gravity: SearchItemGravity.end,
        ),
        defaultBar: _appBar,
        searchHint: 'Search persons...',
        loader: QuerySetLoader<Person>(
          querySetCall: Person.filterPersonsByQuery,
          itemBuilder: Person.buildPersonRow,
          loadOnEachChange: true,
          animateChanges: true,
        ),
      ),
      body: _body,
      drawer: _drawer,
    );
  }

  AppBar get _appBar => AppBar(
        leading: _leadingButton,
        title: Text('Loader example'),
      );

  Widget get _body => Container(
        color: Colors.black12,
        child: Center(
          child: Text('Iconified bar page', style: TextStyle(fontSize: 18.0)),
        ),
      );
}

Widget get _leadingButton => InkWell(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        margin: EdgeInsets.all(12.0),
        child: Icon(Icons.menu, color: Colors.white, size: 24.0),
      ),
    );

Drawer get _drawer => Drawer();

class Person {
  const Person(this.name, this.uri, this.address, this.hasPhone, this.hasEmail);

  final String name;
  final String uri;
  final String address;
  final bool hasPhone;
  final bool hasEmail;

  static const _imageSize = 48.0;
  static const _progressBarSize = 24.0;
  static const _tileDividerMargin = 72.0;

  static List<Person> filterPersonsByQuery(String query) {
    return persons
        .where(
            (person) => person.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static Widget buildPersonRow(Person person) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildPersonTile(person),
          _buildTileDivider(),
        ],
      ),
    );
  }

  static Widget _buildPersonTile(Person person) {
    return ListTile(
      leading: _buildPersonImage(person),
      title: Text(person.name),
      subtitle: Text(person.address),
      trailing: _buildTrailingIcons(person),
    );
  }

  static Widget _buildPersonImage(Person person) {
    return Container(
      width: _imageSize,
      height: _imageSize,
      child: Stack(
        children: [
          _buildImageProgressBar(),
          _buildNetworkImage(person.uri),
        ],
      ),
    );
  }

  static Widget _buildImageProgressBar() {
    return Center(
      child: Container(
          width: _progressBarSize,
          height: _progressBarSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          )),
    );
  }

  static Widget _buildNetworkImage(String uri) {
    return Center(
      child: ClipOval(
        child: new FadeInImage.memoryNetwork(
          placeholder: transparentImage,
          image: uri,
        ),
      ),
    );
  }

  static Widget _buildTrailingIcons(Person person) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTrailingIcon(Icons.phone, person.hasPhone),
        _buildTrailingIcon(Icons.mail_outline, person.hasEmail),
        _buildTrailingIcon(Icons.more_vert, true, padding: 0.0),
      ],
    );
  }

  static Widget _buildTrailingIcon(IconData icon, bool enabled,
      {double padding = 4.0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Icon(
        icon,
        color: enabled ? Colors.black54 : Colors.black26,
      ),
    );
  }

  static Widget _buildTileDivider() {
    return Container(
      margin: EdgeInsets.only(left: _tileDividerMargin),
      height: 1.0,
      color: Colors.black12,
    );
  }

  static const List<Person> persons = [
    Person('Derek Robertson', 'https://randomuser.me/api/portraits/men/4.jpg',
        '8397 California St', true, false),
    Person('Ethel Mills', 'https://randomuser.me/api/portraits/women/60.jpg',
        '5050 Dogwood Ave', true, true),
    Person('Aiden Cruz', 'https://randomuser.me/api/portraits/men/87.jpg',
        '8866 W Gray St', false, false),
    Person('Earl Ray', 'https://randomuser.me/api/portraits/men/40.jpg',
        '3220 Central St', false, true),
    Person('Arnold Bailey', 'https://randomuser.me/api/portraits/men/92.jpg',
        '1809 Abby Park St', true, true),
    Person('Evelyn Oliver', 'https://randomuser.me/api/portraits/women/90.jpg',
        '3220 Central St', true, false),
    Person('Wesley Byrd', 'https://randomuser.me/api/portraits/men/61.jpg',
        '3603 W Tropical Pkwy', true, true),
    Person('Andre Stewart', 'https://randomuser.me/api/portraits/men/73.jpg',
        '5931 Railroad St', false, true),
    Person('Denise Rose', 'https://randomuser.me/api/portraits/women/95.jpg',
        '5928 Cherry St', false, false),
    Person('Jane Morrison', 'https://randomuser.me/api/portraits/women/4.jpg',
        '3499 Perfect Day Ave', true, true),
  ];
}

final transparentImage = Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE
]);
