
import 'package:flutter/material.dart';

import '../dropdown_widget.dart';
import '../search_input_widget.dart';

class R6statsSearchWidget extends StatefulWidget {

  @override
  _R6statsSearchWidgetState createState() => _R6statsSearchWidgetState();
}

class _R6statsSearchWidgetState extends State<R6statsSearchWidget> {
  String _dropdownSelectedItem = 'uplay';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DropdownWidget(
            listItems: ['uplay', 'psn', 'xbl'],
            listLabels: ['PC', 'PS', 'XBOX'],
            selectedItem: _dropdownSelectedItem,
            onChanged: (val) => setState(() => _dropdownSelectedItem = val),
          ),
          SearchInputWidget(_dropdownSelectedItem),
        ],
      ),
    );
  }
}