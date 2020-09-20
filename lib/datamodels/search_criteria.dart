class SearchCriteria {
  String _condition;
  String _keyword;
  String _region;

  SearchCriteria(this._condition, this._keyword, this._region);

  String get condition => _condition;

  String get keyword => _keyword;

  String get region => _region;
}