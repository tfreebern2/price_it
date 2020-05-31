class Item {
  String id;
  String title;
  String globalId;
  String galleryUrl;
  String viewItemUrl;
  String location;
  String country;

  Item(this.id,
      this.title,
      this.globalId,
      this.galleryUrl,
      this.viewItemUrl,
      this.location,
      this.country);

  Item.fromMap(Map<String, dynamic> data) {
    id = data.containsKey("itemId") ? data["itemId"][0] : "";
    title = data.containsKey("title") ? data["title"][0] : "";
    globalId = data.containsKey("globalId") ? data["globalId"][0] : "";
    galleryUrl = data.containsKey("galleryURL") ? data["galleryURL"][0] : "";
    viewItemUrl = data.containsKey("viewItemURL") ? data["viewItemURL"][0] : "";
    location = data.containsKey("location") ? data["location"][0] : "";
    country = data.containsKey("country") ? data["country"][0] : "";
  }
}