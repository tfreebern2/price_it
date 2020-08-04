import 'package:flutter/material.dart';
import 'package:priceit/ui/views/keywordsearch/home/keywordsearch_viewmodel.dart';
import 'package:priceit/ui/widgets/widgets.dart';
import 'package:priceit/util/constants.dart';
import 'package:stacked/stacked.dart';

class KeywordSearchView extends StatelessWidget {
  const KeywordSearchView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return ViewModelBuilder<KeywordSearchViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
            appBar: customAppbar(),
            body: SafeArea(
              child: ListView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 80.0),
                      _radioButtons(context, model),
                      _searchBar(context, _searchController, _formKey),
                      _searchButton(context, model, _searchController, _formKey),
                    ],
                  ),
                ],
              ),
            )),
        viewModelBuilder: () => KeywordSearchViewModel());
  }
}

Widget _radioButtons(context, model) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: usedValue,
          groupValue: model.condition.toString(),
          onChanged: (String newValue) {
            model.updateCondition(newValue);
          },
        ),
        Text(usedValue),
        Radio(
          value: newValue,
          groupValue: model.condition.toString(),
          onChanged: (String newValue) {
            model.updateCondition(newValue);
          },
        ),
        Text(newValue)
      ],
    ),
  );
}

Widget _searchBar(context, _searchController, formKey) {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 14.0, right: 14.0),
    child: Form(
      key: formKey,
      child: TextFormField(
        validator: (String value) {
          return value.isEmpty ? 'Please enter a keyword' : null;
        },
        controller: _searchController,
        decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Theme.of(context).accentColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Theme.of(context).accentColor)),
            hintText: "Search By Keyword",
            filled: true,
            fillColor: Theme.of(context).backgroundColor),
      ),
    ),
  );
}

Widget _searchButton(context, model, _searchController, _formKey) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: MaterialButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          model.updateSearchKeyword(_searchController.text.trim());
          _searchController.clear();
          model.navigateToCompleted();
        }
      },
      child: Text(
        'Search',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      color: Theme.of(context).accentColor,
      highlightElevation: 2,
      height: 40,
      minWidth: 150,
      shape: StadiumBorder(),
    ),
  );
}