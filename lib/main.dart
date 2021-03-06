import 'package:flutter/material.dart';
import 'package:suit_up/repository/repository.dart';
import 'package:suit_up/widgets/calendar.dart';
import 'package:suit_up/widgets/categories_list.dart';

import 'models/category.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Suit up",
      theme: ThemeData(
          backgroundColor: Colors.white,
          accentColor: Colors.black,
          bottomAppBarTheme: BottomAppBarTheme(color: Colors.white)),
      home: Container(
        child: _BottomTabbarPage(),
      ),
    );
  }
}

class _BottomTabbarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BottomTabbarPageState();
}

class _BottomTabbarPageState extends State<_BottomTabbarPage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  static final List<Category> _categories = Repository.instance.categories;

  var _kTabPages = <Widget>[
    Center(child: CategoriesList(_categories)),
    Center(child: Icon(Icons.forum, size: 64.0, color: Colors.blue)),
    Center(child: Icon(Icons.forum, size: 64.0, color: Colors.blue)),
    Center(child: CalendarPage()),
  ];
  static const _kTabs = <Tab>[
    Tab(icon: Icon(Icons.thumb_up, size: 24), text: 'Сlothing'),
    Tab(icon: Icon(Icons.burst_mode, size: 24), text: 'LookBook'),
    Tab(icon: Icon(Icons.refresh, size: 24), text: 'Random'),
    Tab(icon: Icon(Icons.calendar_today, size: 24), text: 'Calendar'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _kTabPages.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Colors.white,
          title: Text("text"),
          bottom: TabBar(
            labelStyle: TextStyle(color: Colors.black, fontStyle: FontStyle.italic, fontSize: 10),
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black12,
            tabs: _kTabs,
            controller: _tabController,
          ),
        ),
        preferredSize: Size.fromHeight(74),
      ),
      body: TabBarView(
        children: _kTabPages,
        controller: _tabController,
      ),
      backgroundColor: Colors.white,
    );
  }
}
