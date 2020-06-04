import 'package:priceit/util/constants.dart';

class Item {
  String id;
  String title;
  String globalId;
  String galleryUrl;
  String viewItemUrl;
  String location;
  String country;
  String currentPrice;
  String sellingState;
  String totalEntries;

  Item(this.id, this.title, this.globalId, this.galleryUrl, this.viewItemUrl, this.location,
      this.country, this.currentPrice, this.sellingState);

  Item.fromMap(Map<String, dynamic> data) {
    id = data.containsKey(itemId) ? data[itemId][0] : notAvailable;
    title = data.containsKey(titleKey) ? data[titleKey][0] : notAvailable;
    globalId = data.containsKey(globalIdKey) ? data[globalIdKey][0] : notAvailable;
    galleryUrl = data.containsKey(galleryUrlKey) ? data[galleryUrlKey][0] : notAvailable;
    viewItemUrl = data.containsKey(viewItemUrlKey) ? data[viewItemUrlKey][0] : notAvailable;
    location = data.containsKey(locationKey) ? data[locationKey][0] : notAvailable;
    country = data.containsKey(countryKey) ? data[countryKey][0] : notAvailable;
    _setCurrentPrice(data);
    _setSellingState(data);
  }

  void _setCurrentPrice(Map<String, dynamic> data) {
    data.forEach((key, value) {
      if (key == sellingStatusKey) {
        var sellingStatusMap = value[0] as Map<String, dynamic>;
        currentPrice = sellingStatusMap.containsKey(currentPriceKey)
            ? "\$" + data[sellingStatusKey][0][currentPriceKey][0][underscoreValueKey]
            : notAvailable;
      }
    });
    _addDoubleDigitsAfterDecimal();
  }

  void _addDoubleDigitsAfterDecimal() {
    String zero = "0";
    String decimal = ".";
    List<String> splitPrice = currentPrice.split(decimal);
    var afterDecimal = splitPrice[1];
    if (afterDecimal == zero) {
      currentPrice = splitPrice[0] + decimal + splitPrice[1] + zero;
    } else if (afterDecimal.length == 1 && afterDecimal != zero) {
      currentPrice = splitPrice[0] + decimal + splitPrice[1] + zero;
    }
  }

  void _setSellingState(Map<String, dynamic> data) {
    data.forEach((key, value) {
      if (key == sellingStatusKey) {
        var sellingStatusMap = value[0] as Map<String, dynamic>;
        sellingState = sellingStatusMap.containsKey(sellingStateKey)
            ? data[sellingStatusKey][0][sellingStateKey][0]
            : notAvailable;
      }
    });
  }
}
