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
              leading: Container(),
              title: Text('PriceIt'),
            ),
            body: SafeArea(
              child: Center(
                  child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 120.0,
                    child: Center(child: Text('Ad Space')),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _dropDownSelector(context, model),
                      _searchBar(_searchController),
                    ],
                  ),
                  _searchButton(context, model, _searchController)
                ],
              )),
            )),
        viewModelBuilder: () => HomeViewModel());
  }
}

Widget _dropDownSelector(context, model) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
    child: DropdownButton<String>(
      underline: Container(
        color: Theme.of(context).accentColor,
        height: 1.0,
      ),
      value: model.condition,
      onChanged: (String newValue) {
        model.updateCondition(newValue);
      },
      items: <String>[usedValue, newValue].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ),
  );
}

Widget _searchBar(_searchController) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(hintText: "Search By Keyword"),
      ),
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
    ),
  );
}
