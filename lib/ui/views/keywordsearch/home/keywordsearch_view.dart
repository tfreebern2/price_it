import 'dart:io';

import 'package:flutter/cupertino.dart';
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
            appBar: _appBar(context, model),
            body: SafeArea(
              child: ListView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Text('Select Region: '),
                      _regionSelector(context, model),
                      SizedBox(height: 20.0),
                      Text('Select Condition: '),
                      _radioButtons(context, model),
                      SizedBox(height: 10),
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

Widget _appBar(context, model) {
  return Platform.isIOS
      ? CupertinoNavigationBar(
          actionsForegroundColor: Colors.white,
          backgroundColor: standardGreen,
          middle: Text(
            'Price It!',
            style: TextStyle(
                fontFamily: 'Oswald',
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.w600),
          ),
        )
      : AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: standardGreen,
          title: Text(
            'Price It!',
            style: TextStyle(
                fontFamily: 'Oswald',
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.w600),
          ),
        );
}

Widget _regionSelector(context, model) {
  return DropdownButton<String>(
    value: model.region,
    icon: Icon(Icons.arrow_downward, color: standardPurple),
    iconSize: 18.0,
    elevation: 16,
    style: TextStyle(fontFamily: 'Oswald', color: standardPurple, fontSize: 16),
    underline: Container(
      height: 1,
      color: Colors.black45,
    ),
    onChanged: (String newValue) {
      model.updateRegion(newValue);
      debugPrint(model.region);
    },
    items: regionList.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}

Widget _radioButtons(context, model) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Radio(
          activeColor: standardPurple,
          value: usedValue,
          groupValue: model.condition.toString(),
          onChanged: (String newValue) {
            model.updateCondition(newValue);
          },
        ),
        Text(usedValue),
        Radio(
          activeColor: standardPurple,
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
                borderSide: BorderSide(color: standardPurple)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.black)),
            hintText: "Search By Keyword",
            filled: true,
            fillColor: standardPurple),
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
          model.navigateToActiveListing();
        }
      },
      child: Text(
        'Search',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      color: standardGreen,
      highlightElevation: 2,
      height: 40,
      minWidth: 150,
      shape: StadiumBorder(),
    ),
  );
}
