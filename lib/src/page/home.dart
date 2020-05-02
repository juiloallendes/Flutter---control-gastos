import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/src/widgets/assets_icons.dart';
import 'package:control_gastos/src/widgets/moth_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../login_state.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  PageController _controler;
  int currentPage =  9;
  Stream<QuerySnapshot> _query;

  @override
  void initState() { 
    super.initState();

    _query = Firestore.instance
      .collection('expenses')
      .where("month", isEqualTo: currentPage + 1)
      .snapshots();


    _controler = PageController(
      initialPage: 9,
      viewportFraction: 0.4
    );
  }

  Widget _bottomNavigation(IconData icon, Function callback) {

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: (){},
    );

  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _bottomNavigation(Assets.lucro, (){}),
            _bottomNavigation(Assets.grafico_circular, (){}),
            SizedBox(width: 32.0),
            _bottomNavigation(Assets.cartera, (){}),
            _bottomNavigation(Assets.equipo, (){
              Provider.of<LoginState>(context).logout();
            }),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_buttom',
        onPressed: (){
          Navigator.of(context).pushNamed('/add');
        },
        child: Icon(Icons.add),
      ),
      body: _body(),
    );
  }

  Widget _body() {

    return SafeArea(
      child: Column(
        children: <Widget>[
          _selector(),
          StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data ) {
              if (data.hasData) {

              return Moth(
                documents: data.data.documents
              );
            
              } else {

                return Center(
                  child: CircularProgressIndicator(),
                );
                
              }

            }
          ),
        ],
      )
    );

  }

  Widget _PageItem(String name, int position) {

    var _alignment;

    //Estilos Textos (Mes)
    final selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFF6C63FF)
    );
    final unselected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: Color(0xFF6C63FF).withOpacity(0.15)
    );

    if (position == currentPage) {

      _alignment  = Alignment.center;
      
    } else if (position > currentPage) {
      _alignment  = Alignment.centerRight;
    }
    else {
      _alignment  = Alignment.centerLeft;
    }

    return Align(
      alignment: _alignment,
      child: Text(
        name,
        style: position == currentPage ? selected : unselected,
      )
    );
  }

  Widget _selector() {

    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage) {
          setState(() {
            currentPage = newPage;
            _query = Firestore.instance
              .collection('expenses')
              .where("month", isEqualTo: currentPage + 1)
              .snapshots();            
          });
        },
        controller: _controler,
        children: <Widget>[
          _PageItem('Enero', 0),
          _PageItem('Febrero', 1),
          _PageItem('Marzo', 2),
          _PageItem('Abril', 3),
          _PageItem('Mayo', 4),
          _PageItem('Junio', 5),
          _PageItem('Julio', 6),
          _PageItem('Agosto', 7),
          _PageItem('Septiembre', 8),
          _PageItem('Octubre', 9),
          _PageItem('Noviembre', 10),
          _PageItem('Diciembre', 11)
        ],

      ),
    );

  }

}