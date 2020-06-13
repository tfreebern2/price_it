import 'item.dart';

class EbayResponse {
  List<Item> _completedList;
  List<Item> _activeList;
  double _completedListingAveragePrice;
  double _completedListingPercentageSold;
  double _activeListingAveragePrice;

  EbayResponse(this._completedList, this._activeList, this._completedListingAveragePrice,
      this._completedListingPercentageSold, this._activeListingAveragePrice);

  double get activeListingAveragePrice => _activeListingAveragePrice;
  double get completedListingPercentageSold => _completedListingPercentageSold;
  double get completedListingAveragePrice => _completedListingAveragePrice;

  List<Item> get activeList => _activeList;
  List<Item> get completedList => _completedList;

  void setCompletedListingAveragePrice(double newValue) {
    _completedListingAveragePrice = newValue;
  }

  void setCompletedListingPercentageSold(double newValue) {
    _completedListingPercentageSold = newValue;
  }

  void setActiveListingAveragePrice(double newValue) {
    _activeListingAveragePrice = newValue;
  }

  void setCompletedListing(Future<List<Item>> completedListings, EbayResponse ebayResponse) {
    completedListings.asStream().forEach((element) {
      element.forEach((innerElement) {
        ebayResponse.completedList.add(innerElement);
      });
    });
  }

  void setActiveListing(Future<List<Item>> activeListing, EbayResponse ebayResponse) {
    activeListing.asStream().forEach((element) {
      element.forEach((innerElement) {
        ebayResponse.activeList.add(innerElement);
      });
    });
  }

  EbayResponse.build(List<Item> completedListings, List<Item> activeListings, double completedListingAveragePrice,
      double completedListingPercentageSold, double activeListingAveragePrice) {

    completedListings.forEach((element) {
      completedList.add(element);
    });

    activeListings.forEach((element) {
      activeList.add(element);
    });

    setCompletedListingAveragePrice(completedListingAveragePrice);
    setCompletedListingPercentageSold(completedListingPercentageSold);
    setActiveListingAveragePrice(activeListingAveragePrice);
  }
}
