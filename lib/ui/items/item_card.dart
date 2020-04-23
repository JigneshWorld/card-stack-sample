import 'package:flutter/material.dart';
import '../../models/app_item.dart';
import '../../main.dart';

class ItemFrontCard extends StatelessWidget {
  final AppItem item;

  ItemFrontCard({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemCard(
        child: Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Image.network(
              item.cardImageLink,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(
              top: 18,
              left: 24,
              right: 24,
              bottom: 32,
            ),
            child: ItemInfo(item),
          ),
        ],
      ),
    ));
  }
}

class ItemCard extends StatelessWidget {
  final Widget child;

  ItemCard({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Card(
        elevation: 2.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.0),
          child: LayoutBuilder(builder: (context, constraint) {
            return Container(
              width: constraint.biggest.width,
              height: constraint.biggest.height,
              child: child,
            );
          }),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      ),
    );
  }
}

class ItemInfo extends StatelessWidget {
  final AppItem item;

  ItemInfo(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          item.name,
          style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.w800, color: darkBlue),
          maxLines: 2,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          item.description,
          style: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.w800, color: darkBlue),
          maxLines: 1,
        ),
      ].where((t) => t != null).toList(),
    );
  }
}

class ItemBackCard extends StatelessWidget {
  final AppItem item;

  ItemBackCard({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: ItemInfo(item),
              ),
              Container(
                width: double.infinity,
                color: Colors.grey,
                height: 1.0,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                item.description,
                textAlign: TextAlign.left,
                style: new TextStyle(
                    color: Colors.black, fontSize: 14.0, height: 1.3),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
