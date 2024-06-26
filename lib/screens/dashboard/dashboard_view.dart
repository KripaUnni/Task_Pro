import 'package:auto_route/auto_route.dart';
import '../../extensions/widget_extension.dart';
import '../../widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../routes/app_router.dart';
import 'dashboard_view_model.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends DashboardViewModel {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        GoalFullRoute(),
        ClosedFullRoute(),
        TimerRoute(),
        StatsRoute(),
      ],
      builder: (context, child, animation){
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          appBar: AppBar(
            title: appBarTitle(),
            backgroundColor: Colors.white,
            leading: context.watchRouter.canPopSelfOrChildren ? const AutoLeadingButton() : null,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: addHabitButton(),
          body: FadeTransition(
            opacity: animation,
            child: child,
          ),
          bottomNavigationBar: BottomNavBar(
            selectedIndex: tabsRouter.activeIndex,
            selectedTap: (index) => tabsRouter.setActiveIndex(index)
          ),
        );
      },
    );
  }

  Widget appBarTitle() => Text(AppStrings.quotations[currentTitleIndex]).wrapFitted();

  FloatingActionButton addHabitButton() {
    return FloatingActionButton(
      onPressed: fabBtnFunction,
      child: const Icon(Icons.add),
    );
  }

}