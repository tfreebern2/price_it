import 'item.dart';

class EbayResponse {
  List<Item> _completedListing = List();
  List<Item> _activeListing = List();
  double _completedListingAveragePrice = 0.00;
  double _completedListingPercentageSold = 0.00;
  double _activeListingAveragePrice = 0.00;

  EbayResponse(this._completedListing, this._activeListing, this._completedListingAveragePrice,
      this._completedListingPercentageSold, this._activeListingAveragePrice);

  double get activeListingAveragePrice => _activeListingAveragePrice;
  double get completedListingPercentageSold => _completedListingPercentageSold;
  double get completedListingAveragePrice => _completedListingAveragePrice;

  List<Item> get activeListing => _activeListing;
  List<Item> get completedListing => _completedListing;

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
        ebayResponse.completedListing.add(innerElement);
      });
    });
  }

  void setActiveListing(Future<List<Item>> activeListing, EbayResponse ebayResponse) {
    activeListing.asStream().forEach((element) {
      element.forEach((innerElement) {
        ebayResponse.activeListing.add(innerElement);
      });
    });
  }

  EbayResponse.build(List<Item> completedListings, List<Item> activeListings, double completedListingAveragePrice,
      double completedListingPercentageSold, double activeListingAveragePrice) {

    completedListings.forEach((element) {
      completedListing.add(element);
    });

    activeListings.forEach((element) {
      activeListing.add(element);
    });

    setCompletedListingAveragePrice(completedListingAveragePrice);
    setCompletedListingPercentageSold(completedListingPercentageSold);
    setActiveListingAveragePrice(activeListingAveragePrice);
  }
}
