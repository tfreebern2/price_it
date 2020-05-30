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
    id = data["itemId"][0] ?? "";
    title = data["title"][0] ?? "";
    globalId = data["globalId"][0] ?? "";
    galleryUrl = data["galleryURL"][0] ?? "";
    viewItemUrl = data["viewItemURL"][0] ?? "";
    location = data["location"][0] ?? "";
    country = data["country"][0] ?? "";
  }
}