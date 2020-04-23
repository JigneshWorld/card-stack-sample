import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/app_item.dart';
import '../../main.dart';

enum FullScreenItemAction { none, left, top, right }

class FullScreenItem extends StatelessWidget {
  final String title;
  final AppItem item;

  const FullScreenItem({
    this.title,
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0, centerTitle: true, title: Text(title)),
      body: FullItemContent(
        item: item,
      ),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  void action(BuildContext context, FullScreenItemAction action) {
    Navigator.pop(context, action);
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      key: const Key('bottom-nav-bar'),
      color: Colors.transparent,
      elevation: 0.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text('Left'),
                onPressed: () => action(context, FullScreenItemAction.left),
              ),
              RaisedButton(
                child: Text('Top'),
                onPressed: () => action(context, FullScreenItemAction.top),
              ),
              RaisedButton(
                child: Text('Right'),
                onPressed: () => action(context, FullScreenItemAction.right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FullItemContent extends StatelessWidget {
  final AppItem item;

  const FullItemContent({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            item.cardImageLink,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${item.name}',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                      color: darkBlue),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(item.description),
        ),
      ],
    );
  }
}
