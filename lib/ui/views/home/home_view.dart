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
                                    value: model.conditionValue,
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
                                      model.searchKeyword =
                                          _searchController.text.trim();
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
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Card(
                                        elevation: 3.00,
                                        shadowColor:
                                            Theme.of(context).accentColor,
                                        child: ListTile(
                                          contentPadding: EdgeInsets.all(12.0),
                                          leading:
                                              Image.network(item.galleryUrl),
                                          title: Text(item.title),
                                          trailing: Text(
                                            item.currentPrice,
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    );
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
