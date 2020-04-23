import 'package:flutter/foundation.dart';
import '../../../models/app_item.dart';

class ItemNotifier extends ChangeNotifier {
  final AppItem item;
  Status decision = Status.none;

  ItemNotifier({
    this.item,
  });

  void updateStatus(Status status) {
    decision = status;
    notifyListeners();
  }

  void markUserItemAction(AppItem item, Status status) {
    item.status = status;
    notifyListeners();
  }
}
