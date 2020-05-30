import 'package:flutter/material.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/ui/views/home/home_viewmodel.dart';
import 'package:stacked/stacked.dart';

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
            ? Container(
                color: Colors.red,
                alignment: Alignment.center,
                child: Text('An error has occurred',
                    style: TextStyle(color: Colors.white)))
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
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: DropdownButton<String>(
                                    value: model.selectorValue,
                                    onChanged: (String newValue) {
                                      model.updateSelectorValue(newValue);
                                    },
                                    items: <String>['Used', 'New']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                        hintText: "Search items"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      model.searchText = _searchController.text;
                                      await model.runFuture();
                                      _searchController.clear();
                                    },
                                    child: Text('Search'),
                                    color: Theme.of(context).accentColor,
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: model.data.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    Item item = model.data[index];
                                    return Card(
                                        child: ListTile(
                                      title: Text(item.title),
                                    ));
                                  }),
                            ),
                          ],
                        ),
                ),
              ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
