import 'package:flutter/material.dart';
import 'package:moneymanager/components/month/month.dart';

import 'package:moneymanager/components/week/week.dart';

class TabbarView extends StatefulWidget {
  const TabbarView({super.key});

  @override
  State<TabbarView> createState() => _TabbarViewState();
}

class _TabbarViewState extends State<TabbarView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
            indicator: ShapeDecoration(
                color: Colors.amber,
                shape: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none)),
            controller: tabController,
            labelColor: Colors.amber,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: const [
              Text(
                'Tuần',
                style: TextStyle(color: Colors.black),
              ),
              Text('Tháng', style: TextStyle(color: Colors.black))
            ]),
        Expanded(
          child: ListView(
            children: [
              SizedBox(
                  width: double.maxFinite,
                  height: 500,
                  child: TabBarView(
                    controller: tabController,
                    children: const [
                      Week(),
                      Month(),
                    ],
                  )),
            ],
          ),
        )
      ],
    );
  }
}
