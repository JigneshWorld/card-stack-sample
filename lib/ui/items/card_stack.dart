import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

import 'card_draggable.dart';
import 'item_card.dart';
import 'notifier/item_notifier.dart';
import '../../models/app_item.dart';
import 'notifier/items_notifier.dart';

enum SlideDirection {
  left,
  right,
  up,
}

class CardStack extends StatefulWidget {
  final ItemsNotifier itemsNotifier;
  final bool showOverlay;
  final Function onTap;

  const CardStack({
    Key key,
    this.itemsNotifier,
    this.showOverlay = true,
    this.onTap,
  }) : super(key: key);

  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  Key _frontCard;
  ItemNotifier _itemNotifier;
  double _nextCardScale = 0.9;

  @override
  void initState() {
    super.initState();
    widget.itemsNotifier.addListener(_onMatchEngineChange);

    _itemNotifier = widget.itemsNotifier.currentItem;
    _itemNotifier.addListener(_onMatchChange);

    _frontCard = Key(_itemNotifier.item.name);
  }

  @override
  void didUpdateWidget(CardStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.itemsNotifier != oldWidget.itemsNotifier) {
      oldWidget.itemsNotifier.removeListener(_onMatchEngineChange);
      widget.itemsNotifier.addListener(_onMatchEngineChange);

      if (_itemNotifier != null) {
        _itemNotifier.removeListener(_onMatchChange);
      }
      _itemNotifier = widget.itemsNotifier.currentItem;
      if (_itemNotifier != null) {
        _itemNotifier.addListener(_onMatchChange);
      }
    }
  }

  @override
  void dispose() {
    if (_itemNotifier != null) {
      _itemNotifier.removeListener(_onMatchChange);
    }

    widget.itemsNotifier.removeListener(_onMatchEngineChange);

    super.dispose();
  }

  void _onMatchEngineChange() {
    if (_itemNotifier.item.status == Status.top) {}
    if (_itemNotifier != null) {
      _itemNotifier.removeListener(_onMatchChange);
    }
    _itemNotifier = widget.itemsNotifier.currentItem;
    if (_itemNotifier != null) {
      _itemNotifier.addListener(_onMatchChange);
    }

    _frontCard = Key(_itemNotifier.item.name);

    setState(() {});
  }

  void _onMatchChange() {
    setState(() {
      /* current match may have changed state, re-render */
    });
  }

  Widget _buildBackCard(AppItem place) {
    if (place == null) {
      return Container();
    }

    return Transform(
      transform: Matrix4.identity()..scale(_nextCardScale, _nextCardScale),
      alignment: Alignment.center,
      child: ItemFrontCard(
        item: place,
      ),
    );
  }

  AppItem currentItem() {
    return widget.itemsNotifier.currentItem.item;
  }

  AppItem nextItem() {
    if (widget.itemsNotifier.nextItem != null) {
      return widget.itemsNotifier.nextItem.item;
    }
    return null;
  }

  Widget _buildFrontCard(AppItem place) {
    return GestureDetector(
      key: _frontCard,
      onTap: widget.onTap,
      child: ItemFrontCard(
        item: place,
      ),
    );
  }

  SlideDirection _desiredSlideOutDirection() {
    switch (widget.itemsNotifier.currentItem.decision) {
      case Status.left:
        return SlideDirection.left;
      case Status.right:
        return SlideDirection.right;
      case Status.top:
        return SlideDirection.up;
      default:
        return null;
    }
  }

  void _onSlideUpdate(double distance) {
    setState(() {
      _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    });
  }

  void _onSlideOutComplete(SlideDirection direction) {
    final currentMatch = widget.itemsNotifier.currentItem;
    final place = currentMatch.item;

    final beforeStatus = place.status;
    Status directionStatus;
    final decisionStatus = widget.itemsNotifier.currentItem.decision;

    switch (direction) {
      case SlideDirection.left:
        directionStatus = Status.left;
        currentMatch.updateStatus(directionStatus);
        break;
      case SlideDirection.right:
        directionStatus = Status.right;
        currentMatch.updateStatus(directionStatus);
        break;
      case SlideDirection.up:
        directionStatus = Status.top;
        currentMatch.updateStatus(directionStatus);
        break;

      default:
        break;
    }

    final afterStatus = directionStatus ?? decisionStatus;

    if (beforeStatus != afterStatus) {
      _itemNotifier.markUserItemAction(place, afterStatus);
      widget.itemsNotifier.markUserItemAction(place, afterStatus);
    }

    widget.itemsNotifier.cycle();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(
                flex: 2,
              ),
              Container(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = Size(constraints.maxWidth,
                        min(constraints.maxWidth * 1.2, constraints.maxHeight));

                    final current = currentItem();
                    final next = nextItem();

                    Fimber.d('Item: Current: ${current.name}');
                    Fimber.d('Item: Next: ${next.name}');

                    return SizedBox(
                      height: size.height,
                      width: size.width,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          DraggableCard(
                            card: _buildBackCard(next),
                            isDraggable: false,
                            showOverlay: widget.showOverlay,
                          ),
                          DraggableCard(
                            card: _buildFrontCard(current),
                            slideTo: _desiredSlideOutDirection(),
                            onSlideUpdate: _onSlideUpdate,
                            onSlideOutComplete: _onSlideOutComplete,
                            swipeCallback: widget.itemsNotifier.swipeCallback,
                            showOverlay: widget.showOverlay,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Text(
                '${widget.itemsNotifier.currentPosition + 1} - ${widget.itemsNotifier.totalItems}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const Spacer(
                flex: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
