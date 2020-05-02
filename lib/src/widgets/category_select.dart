import 'package:flutter/material.dart';

class CategorySelect extends StatefulWidget {

  final  Map<String, IconData> categories;

  final Function(String) onValueChanged;

  const CategorySelect({Key key, this.categories, this.onValueChanged}) : super(key: key);

  @override
  _CategorySelectState createState() => _CategorySelectState();
}

class CategoryWidget extends StatelessWidget {

  final String name;
  final IconData icon;
  final bool selected;

  const CategoryWidget({Key key, this.name, this.icon, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                  color: selected ? Color(0xFF6C63FF) : Colors.grey,
                  width: selected ? 3.0 : 1.0
                )
              ),
              child: Icon(icon)
            ),
            Text(name)
          ],
        ),
      ),
    );
  }
}

class _CategorySelectState extends State<CategorySelect> {

  String currenItem = '';

  @override
  Widget build(BuildContext context) {

    var widgets = <Widget>[];

    widget.categories.forEach((name, icon){
      widgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              currenItem = name;
            });
            widget.onValueChanged(name);
          },
            child: CategoryWidget(
              name : name,
              icon : icon,
              selected: name == currenItem,
            ),
        )
      );
    });

    return ListView(
      scrollDirection: Axis.horizontal,
      children: widgets,
    );
  }
}