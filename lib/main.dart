import 'package:cardstacksample/models/app_item.dart';
import 'package:cardstacksample/ui/items/items_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

const Color darkBlue = Color(0xFF0C0B35);
const Color offWhite = Color(0xFFF7F7F7);
const Color themeBlue = Color(0xFF0059FF);

void main() {
  Fimber.plantTree(FimberTree());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Items Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Items'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AppItem> items;

  @override
  void initState() {
    super.initState();
    items = List.generate(10, (i) {
      final index = i + 1;
      final item = AppItem()
        ..name = 'Item #$index'
        ..description = 'Description #$index'
        ..status = Status.none
        ..cardImageLink = 'https://via.placeholder.com/1200x1000';

      return item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(items[i].name),
            onTap: () {
              final page = ItemsPage.create(
                  context: context, items: items, position: i, title: widget.title);
              Navigator.push(context, MaterialPageRoute(builder: (_) => page));
            },
          );
        },
        itemCount: items.length,
      ),
    );
  }
}
