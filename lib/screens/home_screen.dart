import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/app_drawer.dart';
import '../widgets/note_horizontal_list.dart';
import '../widgets/my_bottom_app_bar.dart';
import '../widgets/fade_on_scroll.dart';
import '../screens/note_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _dayTime = 'morning';

  String checkdayTime() {
    DateTime now = new DateTime.now();

    if (now.hour >= 0 && now.hour < 6) return 'night';
    if (now.hour >= 6 && now.hour < 12) return 'morning';
    if (now.hour >= 12 && now.hour < 18) return 'afternon';
    if (now.hour >= 18 && now.hour < 23) return 'evening';
    return 'morning';
  }

  @override
  void didChangeDependencies() {
    checkdayTime();
    super.didChangeDependencies();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      bottomNavigationBar: AppBottomAppBar(_openDrawer),
      body: CustomScrollView(
        controller: scrollController,
        // physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Icon(Icons.dashboard_customize),
                color: Colors.white,
                onPressed: () {},
              ),
            ],
            expandedHeight: MediaQuery.of(context).size.height * 0.25,
            pinned: true,
            title: FadeOnScroll(
              scrollController: scrollController,
              fullOpacityOffset: 140,
              zeroOpacityOffset: 102,
              child: Text(
                "Home",
                style: TextStyle(color: Colors.black),
              ),
            ),
            stretchTriggerOffset: 1,
            flexibleSpace: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 20, bottom: 16),
                title: FadeOnScroll(
                  scrollController: scrollController,
                  zeroOpacityOffset: 101,
                  fullOpacityOffset: 100,
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Good ${checkdayTime()}\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                      TextSpan(
                          text: DateFormat.yMMMMEEEEd()
                              .format(DateTime.now())
                              .toUpperCase(),
                          style: TextStyle(fontSize: 10)),
                    ]),
                  ),
                ),
                background: Image.network(
                  'https://cdn.pixabay.com/photo/2017/10/13/15/29/coffee-2847957_960_720.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                height: 850,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            'NOTES >',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(NoteDetailsScreen.routeName);
                              },
                              icon: const Icon(Icons.note_add_outlined),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.more_horiz),
                            ),
                          ],
                        ),
                      ],
                    ),
                    NoteHorizontalList(),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(NoteDetailsScreen.routeName);
        },
        elevation: 0,
        tooltip: 'Add note',
        icon: const Icon(Icons.add),
        label: Text('New'),
      ),
    );
  }
}
