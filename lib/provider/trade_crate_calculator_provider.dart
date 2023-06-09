import 'package:bdo_things/constants.dart';
import 'package:bdo_things/repository/design_repository.dart';
import 'package:bdo_things/repository/get_world_market_search_list_repository.dart';
import 'package:bdo_things/data/life_skill_data.dart';
import 'package:bdo_things/data/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TradeCrateSortStatus {
  none,
  profitAsc,
  profitDesc,
}

class TradeCrateCalculatorProvider extends ChangeNotifier {
  final DesignRepository _designRepository= DesignRepository();
  final GetWorldMarketSearchListRepository _getWorldMarketSearchListRepository = GetWorldMarketSearchListRepository();

  List<Design>  _designs = [];
  List<Design> get designs => _designs;

  List<Map<String, dynamic>> _tradeCrateData = [];
  List<Map<String, dynamic>> get tradeCrateData => _tradeCrateData;

  TradeCrateSortStatus _sortStatus = TradeCrateSortStatus.none;
  TradeCrateSortStatus get sortStatus => _sortStatus;

  String _originRoute = CONSTANTS.originRoutes.elementAt(2);
  String _destinationRoute = CONSTANTS.destinationRoutes.elementAt(1);

  String get originRoute => _originRoute;
  String get destinationRoute => _destinationRoute;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error {
    final error=_error;
    _error= null;
    return error;
  }

  TradeCrateCalculatorProvider() {
    update();
  }

  Future<void> update() async {
    setLoading(true);
    try {
      _designs = await _designRepository.getDesigns();
    } catch (e) {
      setError(e);
    }
    setLoading(false);
    notifyListeners();
    loadTableData();
  }

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  void setError(Object error) {
    print(error);
    _error = error;
  }

  void setOriginRoute(String value) {
    _originRoute = value;
    calculateSellingPriceAndProfit();
    notifyListeners();
  }

  void setDestinationRoute(String value) {
    _destinationRoute = value;
    calculateSellingPriceAndProfit();
    notifyListeners();
  }

  Future<void> loadTableData() async {
    setLoading(true);
    _tradeCrateData = await Future.wait(designs.map((design) async {
      final materials = design.materials;
      final materialItemIdString = materials.map((material) => material.materialItemId.toString()).join(',');

      final marketPrice = await _getWorldMarketSearchListRepository.getWorldMarketSearchLists(materialItemIdString);
      final marketPriceList = marketPrice.parseResultMsg().split('|');

      int materialsTotalPrice = 0;
      for (int i = 0; i < materials.length; i++) {
        final material = materials[i];
        materialsTotalPrice += (int.parse(marketPriceList[i].split('-')[2]) * material.amount).toInt();
      }

      return {
        'id': design.id,
        'name': design.name,
        'materialsTotalPrice': materialsTotalPrice,
        'sale_price': _calculateSellingPrice(design.originalPrice),
        'profit': _calculateSellingPrice(design.originalPrice) - materialsTotalPrice,
      };
    }));

    sortTableData();
    setLoading(false);

    notifyListeners();
  }

  void calculateSellingPriceAndProfit() {
    for (final data in _tradeCrateData) {
      final originalPrice = designs.firstWhere((element) => element.id == data['id']).originalPrice;
      data['sale_price'] = _calculateSellingPrice(originalPrice);
      data['profit'] = data['sale_price'] - data['materialsTotalPrice'];
    }
    sortTableData();
  }

  void sortTableData() {
    if (_sortStatus == TradeCrateSortStatus.profitDesc) {
      _tradeCrateData.sort((a, b) => b['profit'].compareTo(a['profit']));
    } else if (_sortStatus == TradeCrateSortStatus.profitAsc) {
      _tradeCrateData.sort((a, b) => a['profit'].compareTo(b['profit']));
    } else {
      _tradeCrateData.sort((a, b) => a['id'].compareTo(b['id']));
    }
  }

  void changeSortStatus() {
    if (_sortStatus == TradeCrateSortStatus.none) {
      _tradeCrateData.sort((a, b) => b['profit'].compareTo(a['profit']));
      _sortStatus = TradeCrateSortStatus.profitDesc;
    } else if (_sortStatus == TradeCrateSortStatus.profitDesc) {
      _tradeCrateData.sort((a, b) => a['profit'].compareTo(b['profit']));
      _sortStatus = TradeCrateSortStatus.profitAsc;
    } else if (_sortStatus == TradeCrateSortStatus.profitAsc) {
      _tradeCrateData.sort((a, b) => a['id'].compareTo(b['id']));
      _sortStatus = TradeCrateSortStatus.none;
    }
    notifyListeners();
  }

  int _calculateSellingPrice(int originalPrice) {
    const double defaultBonus = 0.05;
    const double tradeLevelBounusMultiplier = 0.005;
    double tradeLevelBounus = defaultBonus + lifeSkillDataList.firstWhere((data) => data['name'] == 'Trading')['lifeSkillLevel'] * tradeLevelBounusMultiplier;
    num distanceBonus = CONSTANTS.distanceBonus[_originRoute]?[_destinationRoute] ?? 0;
    int sellingPrice = ((originalPrice) * ((1+distanceBonus)*(1+tradeLevelBounus))).toInt();
    return sellingPrice;
  }
}