import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/note_horizontal_list.dart';
import '../widgets/my_bottom_app_bar.dart';
import '../widgets/fade_on_scroll.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  String _dayTime = 'morning';

  void checkdayTime() {
    DateTime now = new DateTime.now();

    if (now.hour >= 0 && now.hour < 6) _dayTime = 'night';
    if (now.hour >= 6 && now.hour < 12) _dayTime = 'morning';
    if (now.hour >= 12 && now.hour < 18) _dayTime = 'afternon';
    if (now.hour >= 18 && now.hour < 23) _dayTime = 'evening';
  }

  @override
  void didChangeDependencies() {
    checkdayTime();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomAppBar(),
      body: CustomScrollView(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.dashboard_customize),
                onPressed: () {},
              ),
            ],
            expandedHeight: MediaQuery.of(context).size.height * 0.25,
            pinned: true,
            title: FadeOnScroll(
              scrollController: scrollController,
              fullOpacityOffset: 140,
              zeroOpacityOffset: 102,
              child: Text("Home"),
            ),
            stretchTriggerOffset: 1,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20, bottom: 16),
              title: FadeOnScroll(
                scrollController: scrollController,
                zeroOpacityOffset: 101,
                fullOpacityOffset: 100,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Good $_dayTime\n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    TextSpan(
                        text: DateFormat.yMMMMEEEEd().format(DateTime.now()),
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
                              onPressed: () {},
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
        onPressed: () {},
        tooltip: 'Add note',
        icon: const Icon(Icons.add),
        label: Text('New'),
      ),
    );
  }
}
