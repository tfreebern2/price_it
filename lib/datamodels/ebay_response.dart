import 'item.dart';

class EbayResponse {
  List<Item> _activeListing = List<Item>();
  double _activeListingAveragePrice = 0.00;
  String currencySymbol;

  EbayResponse(this._activeListing, this._activeListingAveragePrice, this.currencySymbol);

  double get activeListingAveragePrice => _activeListingAveragePrice;

  List<Item> get activeListing => _activeListing;

  void setActiveListingAveragePrice(double newValue) {
    _activeListingAveragePrice = newValue;
  }

  void setActiveListing(Future<List<Item>> activeListing, EbayResponse ebayResponse) {
    activeListing.asStream().forEach((element) {
      element.forEach((innerElement) {
        ebayResponse.activeListing.add(innerElement);
      });
    });
  }

  EbayResponse.build(List<Item> activeListings, double activeListingAveragePrice, String symbol) {
    activeListings.forEach((element) {
      activeListing.add(element);
    });
    setActiveListingAveragePrice(activeListingAveragePrice);
    currencySymbol = symbol;
  }
}
