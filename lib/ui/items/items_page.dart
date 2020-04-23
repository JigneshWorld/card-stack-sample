import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'card_stack.dart';
import 'full_screen_item.dart';
import '../../models/app_item.dart';
import 'notifier/items_notifier.dart';

class ItemsPage extends StatefulWidget {
  final String title;
  final ItemsNotifier itemsNotifier;

  const ItemsPage({
    Key key,
    this.title,
    this.itemsNotifier,
  }) : super(key: key);

  @override
  _ItemsPageState createState() => _ItemsPageState();

  static Widget create({
    BuildContext context,
    String title = 'Items',
    List<AppItem> items,
    int position = 0,
  }) {
    return ChangeNotifierProvider<ItemsNotifier>.value(
      value: ItemsNotifier(items: items, position: position),
      child: Consumer<ItemsNotifier>(
        builder: (context, notifier, _) {
          return ItemsPage(
            title: title,
            itemsNotifier: notifier,
          );
        },
      ),
    );
  }
}

class _ItemsPageState extends State<ItemsPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ItemsNotifier itemsNotifier;

  @override
  void initState() {
    super.initState();
    Fimber.i('ItemsPage: initState');
    itemsNotifier = widget.itemsNotifier;
    itemsNotifier.addListener(_listenChange);
  }

  void _listenChange() {
    setState(() {});
  }

  @override
  void dispose() {
    itemsNotifier.removeListener(_listenChange);
    super.dispose();
  }

  void _markItem(Status status) {
    final currentMatch = widget.itemsNotifier.currentItem;
    final item = currentMatch.item;

    final beforeStatus = item.status;
    Status directionStatus;
    final decisionStatus = widget.itemsNotifier.currentItem.decision;

    switch (status) {
      case Status.left:
        directionStatus = Status.left;
        currentMatch.updateStatus(directionStatus);
        break;
      case Status.right:
        directionStatus = Status.right;
        currentMatch.updateStatus(directionStatus);
        break;
      case Status.top:
        directionStatus = Status.top;
        currentMatch.updateStatus(directionStatus);
        break;

      default:
        break;
    }

    final afterStatus = directionStatus ?? decisionStatus;

    if (beforeStatus != afterStatus) {
      currentMatch.markUserItemAction(item, afterStatus);
      itemsNotifier.markUserItemAction(item, afterStatus);
    }

    itemsNotifier.cycle();
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      key: const Key('bottom-nav-bar'),
      color: Colors.transparent,
      elevation: 0.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text('Left'),
                onPressed: () =>
                    itemsNotifier.currentItem.updateStatus(Status.left),
              ),
              RaisedButton(
                child: Text('Top'),
                onPressed: () =>
                    itemsNotifier.currentItem.updateStatus(Status.top),
              ),
              RaisedButton(
                child: Text('Right'),
                onPressed: () =>
                    itemsNotifier.currentItem.updateStatus(Status.right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      title: Text(widget.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    Widget bottomNavigationBar;

    if (!itemsNotifier.isReady) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (itemsNotifier.isReady && itemsNotifier.isListCompleted) {
      body = Center(
        child: Column(
          children: <Widget>[
            Spacer(),
            Text(
              'Completed List',
              style: Theme.of(context).textTheme.headline5,
            ),
            Spacer(),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Back to List',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(decoration: TextDecoration.underline),
              ),
            ),
            Spacer(),
          ],
        ),
      );
    } else {
      bottomNavigationBar = _buildBottomAppBar();
      body = CardStack(
        key: const Key('card-stack'),
        itemsNotifier: itemsNotifier,
        showOverlay: _showOverlay,
        onTap: _onTap,
      );
    }

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: _buildAppBar(),
        body: body,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }

  Future<void> _onTap() async {
    final item = itemsNotifier?.currentItem?.item;
    if (item != null) {
      hideOverlay();
      await handleFullItemView(item);
      showOverlay();
    }
  }

  Future handleFullItemView(item) async {
    final userAction = await Navigator.push<FullScreenItemAction>(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenItem(
          title: widget.title,
          item: item,
        ),
      ),
    );
    if (userAction != null && userAction != FullScreenItemAction.none) {
      switch (userAction) {
        case FullScreenItemAction.left:
          _markItem(Status.left);
          break;
        case FullScreenItemAction.top:
          _markItem(Status.top);
          break;
        case FullScreenItemAction.right:
          _markItem(Status.right);
          break;
        default:
          break;
      }
    }
  }

  bool _showOverlay = true;

  void hideOverlay() {
    setState(() {
      _showOverlay = false;
    });
  }

  void showOverlay() {
    setState(() {
      _showOverlay = true;
    });
  }
}
