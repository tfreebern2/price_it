import 'package:flutter/cupertino.dart';
import 'package:priceit/util/constants.dart';

class Item {
  String id;
  String title;
  String globalId;
  String galleryUrl;
  String viewItemUrl;
  String location;
  String country;
  String currencySymbol;
  double currentPrice;
  String currentPriceString;
  String sellingState;
  String totalEntries;

  Item(this.id, this.title, this.globalId, this.galleryUrl, this.viewItemUrl, this.location,
      this.country, this.currencySymbol, this.currentPrice, this.sellingState);

  Item.fromJson(Map<String, dynamic> data) {
    id = data.containsKey(itemId) ? data[itemId][0] : notAvailable;
    title = data.containsKey(titleKey) ? data[titleKey][0] : notAvailable;
    globalId = data.containsKey(globalIdKey) ? data[globalIdKey][0] : notAvailable;
    galleryUrl = data.containsKey(galleryUrlKey) ? data[galleryUrlKey][0] : '';
    viewItemUrl = data.containsKey(viewItemUrlKey) ? data[viewItemUrlKey][0] : null;
    if (viewItemUrl == null) print("view item url null");
    location = data.containsKey(locationKey) ? data[locationKey][0] : notAvailable;
    country = data.containsKey(countryKey) ? data[countryKey][0] : notAvailable;
    _setCurrentPrice(data);
  }

  void _setCurrentPrice(Map<String, dynamic> data) {
    data.forEach((key, value) {
      if (key == sellingStatusKey) {
        var sellingStatusMap = value[0] as Map<String, dynamic>;
        String symbol = sellingStatusMap.containsKey(convertedCurrentPrice)
            ? data[sellingStatusKey][0][convertedCurrentPrice][0][currentIdValueKey]
            : "USD";
        currencySymbol = _getCurrencySymbol(symbol);
        currentPriceString = sellingStatusMap.containsKey(convertedCurrentPrice)
            ? data[sellingStatusKey][0][convertedCurrentPrice][0][underscoreValueKey]
            : notAvailable;
        currentPrice = double.parse(currentPriceString);
      }
    });
    _addDoubleDigitsAfterDecimal();
  }

  String _getCurrencySymbol(String symbol) {
    return currencyMap[symbol];
  }

  void _addDoubleDigitsAfterDecimal() {
    String zero = "0";
    String decimal = ".";
    List<String> splitPrice = currentPriceString.split(decimal);
    var afterDecimal = splitPrice[1];
    if (afterDecimal == zero) {
      currentPriceString = splitPrice[0] + decimal + splitPrice[1] + zero;
    } else if (afterDecimal.length == 1 && afterDecimal != zero) {
      currentPriceString = splitPrice[0] + decimal + splitPrice[1] + zero;
    }
  }
}
