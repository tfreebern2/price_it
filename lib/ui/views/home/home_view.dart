import 'package:flutter/material.dart';
import 'package:priceit/ui/views/home/home_viewmodel.dart';
import 'package:priceit/util/constants.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    return ViewModelBuilder<HomeViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text('PriceIt', style: TextStyle(fontFamily: 'DancingScript', fontSize: 26.0),),
              ),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 120.0,
                    child: Center(child: Text('Ad Space')),
                  ),
                  _radioButtons(context, model),
                  _searchBar(context, _searchController),
                  _searchButton(context, model, _searchController)
                ],
              ),
            )),
        viewModelBuilder: () => HomeViewModel());
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

Widget _searchBar(context, _searchController) {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 14.0, right: 14.0),
    child: TextField(
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
  );
}

Widget _searchButton(context, model, _searchController) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: MaterialButton(
      onPressed: () {
        // TODO: Check for empty searchBarValue
        model.updateSearchKeyword(_searchController.text.trim());
        _searchController.clear();
        model.navigateToCompleted();
      },
      child: Text(
        'Search',
        style: TextStyle(color: Colors.white),
      ),
      color: Theme.of(context).accentColor,
      highlightElevation: 2,
      height: 40,
      minWidth: 150,
      shape: StadiumBorder(),
    ),
  );
}
