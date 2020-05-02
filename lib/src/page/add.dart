import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/src/widgets/assets_icons.dart';
import 'package:control_gastos/src/widgets/category_select.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  AddPage({Key key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  String category;

  int valor = 0;

  final color = Color(0xFF6C63FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Category',
          style: TextStyle(
            color: Colors.grey
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey,),
            onPressed: () {
              Navigator.of(context).pop();
            }
          )
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        _categorySelected(),
        _currentValue(),
        _numPad(),
        _submit()
      ],
    );
  }

  Widget _categorySelected() {
    return Container(
      height: 80.0,
      child: CategorySelect(
        categories: {
          'Shopping' : Assets.almacenar,
          'Alcohol'  : Assets.copa_de_vino,
          'Fast Food': Assets.grafico_circular,
          'Bills'    : Assets.cartera__1_
        },
        onValueChanged: (newCategory) => category = newCategory,
      ),
    );
  }

  Widget _currentValue() {

    var realValor = valor / 10;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Text(
        '\$${realValor.toStringAsFixed((1))}'.toString().replaceAll('.', ''),
        style: TextStyle(
          fontSize: 50.0,
          color: color,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }

Widget _num(String text, double heigth) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      setState(() {
        if (text == ','){
          valor = valor * 100;
        }else{
          valor = valor * 10 + int.parse(text);
        }
        
      });
    },
    child: Container(
      height: heigth,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 40,
            color: Colors.grey
          ),
        ),
      ),
    ),
  );
}

  _numPad() {
    return Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context,  BoxConstraints constraints){
          var heigth = constraints.biggest.height / 4;
          return Table(
            border: TableBorder.all(
              color: color.withOpacity(0.4),
              width: 1.0
            ),
            children: [
              TableRow(
                children:[ 
                  _num('1', heigth),
                  _num('2', heigth),
                  _num('3', heigth),
                ]
              ),
              TableRow(
                children:[ 
                  _num('4', heigth),
                  _num('5', heigth),
                  _num('6', heigth),
                ]
              ),
              TableRow(
                children:[ 
                  _num('7', heigth),
                  _num('8', heigth),
                  _num('9', heigth),
                ]
              ),
              TableRow(
                children:[ 
                  _num(',', heigth),
                  _num('0', heigth),
                  Container(
                    height: heigth,
                    child: Center(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            valor = valor ~/ 10;
                          });
                        },
                        child: Icon(
                          Icons.backspace,
                          color: Colors.grey,
                          size: 40,
                        ),
                      )
                    )
                  ),
                ]
              ),
            ],
          );
        }
      ),
    );
  }

  _submit() {
    return Builder(
        builder: (BuildContext context) {
        return Hero(
          tag: 'add_buttom',
          transitionOnUserGestures: true,
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color
            ),
            child: MaterialButton(
              child: Text('Add Expenses', style:TextStyle( color: Colors.white, fontSize: 20.0 )),
              onPressed: () {
                if (valor > 0 && category != "") {
                  
                  Firestore.instance
                        .collection('expenses')
                        .document()
                      .setData({
                          'category' : category,
                          'value' : valor,
                          'month' : DateTime.now().month,
                          'day' : DateTime.now().day
                        });
                  Navigator.of(context).pop();
                } 
                else {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Select a  value and a category'))
                  );
                }
              }
            ),
          ),
        );
      }
    );
  }

  
}