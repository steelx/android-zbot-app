import 'package:flutter/material.dart';
import 'package:zbot_app/utils/map_index.dart' show ExtendedIterable;

class DropdownWidget extends StatelessWidget {
  final List<String> listItems;
  final List<String> listLabels;
  final String selectedItem;
  final Function(String) onChanged;

  const DropdownWidget({
    @required this.listItems,
    @required this.listLabels,
    @required this.selectedItem,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedItem,
          items: listItems
              .mapIndex((e, i) => DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.black12,
                          radius: 12.0,
                          child: Image.asset(
                            'assets/images/${e.toLowerCase()}_icon.png',
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          this.listLabels[i],
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    value: e,
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
