import 'package:flutter/material.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/ui/views/home/home_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'package:priceit/util/constants.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("PriceIt"),
        ),
        body: model.hasError
            ? _errorContainer()
            : SafeArea(
                child: Center(
                  child: model.isBusy
                      ? CircularProgressIndicator()
                      : Column(
                          children: <Widget>[
                            SizedBox(
                              height: 80.0,
                              child: Center(child: Text('Ad Space')),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                _dropDownSelector(context, model),
                                _searchBar(_searchController),
                                _searchButton(context, model, _searchController)
                              ],
                            ),
                            _itemListViewBuilder(model),
                          ],
                        ),
                ),
              ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

Widget _errorContainer() {
  return Container(
      color: Colors.red,
      alignment: Alignment.center,
      child: Text('An error has occurred',
          style: TextStyle(color: Colors.white)));
}

Widget _dropDownSelector(context, model) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
    child: DropdownButton<String>(
      underline: Container(
        color: Theme.of(context).accentColor,
        height: 1.0,
      ),
      value: model.conditionValue,
      onChanged: (String newValue) {
        model.updateSelectorValue(newValue);
      },
      items:
          <String>[usedValue, newValue].map<DropdownMenuItem<String>>((String value) {
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
      onPressed: () async {
        model.searchKeyword = _searchController.text.trim();
        await model.runFuture();
        _searchController.clear();
      },
      child: Text('Search'),
      color: Theme.of(context).accentColor,
    ),
  );
}

Widget _itemListViewBuilder(model) {
  return Expanded(
    child: ListView.builder(
        itemCount: model.data.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Item item = model.data[index];
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              elevation: 6.00,
              shadowColor: Theme.of(context).accentColor,
              child: ListTile(
                contentPadding: EdgeInsets.all(12.0),
                leading: Image.network(item.galleryUrl),
                title: Text(item.title),
                trailing: Text(
                  item.currentPrice,
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                onTap: () => model.launchUrl(item.viewItemUrl),
              ),
            ),
          );
        }),
  );
}