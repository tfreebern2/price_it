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

  Item(this.id, this.title, this.globalId, this.galleryUrl, this.viewItemUrl,
      this.location, this.country, this.currentPrice);

  Item.fromMap(Map<String, dynamic> data) {
    id = data.containsKey(itemId) ? data[itemId][0] : notAvailable;
    title = data.containsKey(titleKey) ? data[titleKey][0] : notAvailable;
    globalId = data.containsKey(globalIdKey) ? data[globalIdKey][0] : notAvailable;
    galleryUrl = data.containsKey(galleryUrlKey) ? data[galleryUrlKey][0] : notAvailable;
    viewItemUrl = data.containsKey(viewItemUrlKey) ? data[viewItemUrlKey][0] : notAvailable;
    location = data.containsKey(locationKey) ? data[locationKey][0] : notAvailable;
    country = data.containsKey(countryKey) ? data[countryKey][0] : notAvailable;
    setCurrentPrice(data);
  }

  void setCurrentPrice(Map<String, dynamic> data) {
    data.forEach((key, value) {
      if (key == sellingStatusKey) {
        var sellingStatusMap = value[0] as Map<String, dynamic>;
        currentPrice = sellingStatusMap.containsKey(currentPriceKey)
            ? data[sellingStatusKey][0][currentPriceKey][0][underscoreValueKey]
            : notAvailable;
      }
    });
  }
}
