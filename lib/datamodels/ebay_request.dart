class EbayRequest {
  String condition;
  String keyword;
  String region;

  EbayRequest(this.condition, this.keyword, this.region);

  EbayRequest.build(String condition, String keyword, String region) {
    this.condition = condition;
    this.keyword = keyword;
    this.region = region;
  }
}