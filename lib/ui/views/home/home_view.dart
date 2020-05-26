import 'package:flutter/material.dart';
import 'package:resalechecker/ui/views/home/home_viewmodel.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("PriceIt"),
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: model.selectorValue,
                      onChanged: (String newValue) {
                        model.updateSelectorValue(newValue);
                      },
                      items: <String>['Used', 'New']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: null,
                      decoration: InputDecoration(hintText: "Search items"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () => debugPrint('Searching...'),
                      child: Text('Search'),
                      color: Theme.of(context).accentColor,
                    ),
                  )
                ],
              ),
              Card(
                child: ListTile(
                    leading: Icon(Icons.ac_unit), title: Text("Item 1")),
              ),
              Card(
                child: ListTile(
                    leading: Icon(Icons.access_alarm), title: Text("Item 2")),
              ),
              Card(
                child: ListTile(
                    leading: Icon(Icons.access_alarm), title: Text("Item 2")),
              ),
              Card(
                child: ListTile(
                    leading: Icon(Icons.access_alarm), title: Text("Item 2")),
              ),
              Card(
                child: ListTile(
                    leading: Icon(Icons.access_alarm), title: Text("Item 2")),
              ),
              Card(
                child: ListTile(
                    leading: Icon(Icons.access_alarm), title: Text("Item 2")),
              ),
              Card(
                child: ListTile(
                    leading: Icon(Icons.access_alarm), title: Text("Item 2")),
              ),
              Card(
                child: ListTile(
                    leading: Icon(Icons.access_alarm), title: Text("Item 2")),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
