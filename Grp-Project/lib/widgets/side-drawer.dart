import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: Text(
              'Your Assistant',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Divider(),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(
              Icons.home_filled,
              size: 26,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.book_online,
              size: 26,
            ),
            title: Text(
              'Tutorials',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/tutorial-screen');
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
