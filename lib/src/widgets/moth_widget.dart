import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'assets_icons.dart';
import 'graph_widget.dart';


class Moth extends StatefulWidget {

  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;

  Moth( {Key key, this.documents}) : 
  total = documents.map((doc) => doc['value'])
    .fold(0.0, (a,b) => a + b),
  perDay = List.generate(30, (int index){
    return documents.where((doc) => doc['day'] == (index + 1))
          .map((doc) => doc['value'])
          .fold(0.0, (a,b) => a + b);
  }),
  categories = documents.fold({}, (Map<String, double> map, document) {
    if (!map.containsKey(document['category'])){
      map[document['category']] = 0.0;
    }
    map[document['category']] += document['value'];
    return map;
  }),
  super(key: key);

  @override
  _MothState createState() => _MothState();
}

class _MothState extends State<Moth> {
  @override
  Widget build(BuildContext context) {
    print(widget.categories);
    return Expanded(
      child: Column(
        children: <Widget>[
          _expensas(),
          _graph(),
          Container(
            color: Color(0xFF6C63FF).withOpacity(0.15),
            height: 24.0,
          ),
          _list()
        ],
      ),
    );
  }

    Widget _expensas() {
    return Column(
      children: <Widget>[
        Text(
          '\$${widget.total.toStringAsFixed(1)}'.toString().replaceAll('.0', ''),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
          ),
        ),
        Text(
          'Total Expensas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Color(0xFF6C63FF).withOpacity(0.6)
          ),
        ),
      ],
    );
  }

  Widget _graph() {

    return Container(
      height: 250,
      child: GraphWidget(
        data: widget.perDay
      )
    );

  }

  Widget _list() {

    return Expanded(
      child: ListView.separated(
        itemCount: widget.categories.keys.length,
        itemBuilder: (BuildContext context, int index) { 
          var key = widget.categories.keys.elementAt(index);
          var data = widget.categories[key];
          return _item(Assets.copa_de_vino, key, 100 * data ~/ widget.total, data);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Color(0xFF6C63FF).withOpacity(0.15),
            height: 8.0,
          );
        },
      ),
    );

  }

    Widget _item(IconData icon, String nombre, int percent, double value) {
    return ListTile(
      leading: Icon(icon, size: 40, color: Color(0xFF6C63FF) ,),
      title: Text(
        nombre, 
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Color(0xFF6C63FF)
        ),
      ),
      subtitle: Text(
        '$percent % de las espensas',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: Color(0xFF6C63FF).withOpacity(0.8)
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Color(0xFF6C63FF).withOpacity(0.5),
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$value'.toString().replaceAll('.0', ''),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Color(0xFF6C63FF)
            ),

          ),
        ),

      ),
    );
  }

}