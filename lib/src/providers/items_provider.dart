import 'package:flutter/material.dart';
import 'package:shop_list/src/data/ItemModel.dart';
import 'package:shop_list/src/data/db.dart';

class ItemProvider with ChangeNotifier {
  List<ItemModel> _items = [];
  bool _loading = true;
  String _error = '';
  int _total = 0;

  get items => _items;
  get loading => _loading;
  get error => _error;
  get total => _total;

  Future<void> fetchItems(int id) async {
    _loading = true;
    _error = '';

    try {
      _items = await DB.traerItems(id);
      notifyListeners();
    } catch (error) {
      _error = 'No se pudo cargar los items';
    }
  }

  void nuevoItem(ItemModel item) async {
    await DB.insertItem(item);
    await fetchItems(item.id_lista as int);

    if (item.price != 0) {
      _total = _total +  ((item.price as int) * (item.amount as int));
      notifyListeners();
    }
  }

  void deleteItem(int index) async {
    int id = _items[index].id as int;
    await DB.deleteItem(id);

    _total -= (_items[index].price as int) * (_items[index].amount as int);
    _items.removeAt(index);
    notifyListeners();
  }
}