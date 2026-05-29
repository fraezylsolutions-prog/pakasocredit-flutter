import 'package:pakaso_credit/src/app/routes/routes_handler.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/presentation/screens/home/view/home_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/reward/view/reward_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/setting_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/view/virtual_card_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/view/wallet_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxList<List<Widget>> _pageStacks = <List<Widget>>[].obs;
  final Map<String, dynamic> _routeArguments = {};
  final RxBool isLoading = true.obs;

  final RxString virtualCard = "1".obs;
  final RxString multipleCurrency = "1".obs;
  final RxString userReward = "1".obs;

  @override
  void onInit() {
    super.onInit();
    _pageStacks.assignAll([
      [const HomeScreen()],
      [const VirtualCardScreen()],
      [const WalletScreen()],
      [const RewardScreen()],
      [const SettingScreen()],
    ]);
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      virtualCard.value = await SettingsService.getSettingValue('virtual_card') ?? "1";
      multipleCurrency.value = await SettingsService.getSettingValue('multiple_currency') ?? "1";
      userReward.value = await SettingsService.getSettingValue('user_reward') ?? "1";
      update();
    } catch (e) {
      if (kDebugMode) print("Navigation Error: $e");
    } finally {
      Future.delayed(const Duration(milliseconds: 100), () {
        isLoading.value = false;
      });
    }
  }

  void onTapItem(int index) {
    if (selectedIndex.value == index && _pageStacks[index].length > 1) {
      _pageStacks[index] = [_pageStacks[index].first];
    }
    selectedIndex.value = index;
    update();
  }

  void pushPage(Widget page) {
    _pageStacks[selectedIndex.value].add(page);
    update();
  }

  void pushNamed(String routeName, {dynamic arguments}) {
    final route = _findRoute(routeName);
    if (route != null) {
      if (arguments != null) _routeArguments[routeName] = arguments;
      _pageStacks[selectedIndex.value].add(route.page());
      update();
    }
  }

  // Restored missing methods for Loan and Registration flow
  void pushOffNamed(String routeName, {dynamic arguments}) {
    final route = _findRoute(routeName);
    if (route != null) {
      if (arguments != null) _routeArguments[routeName] = arguments;
      if (_pageStacks[selectedIndex.value].isNotEmpty) {
        _pageStacks[selectedIndex.value].removeLast();
      }
      _pageStacks[selectedIndex.value].add(route.page());
      update();
    }
  }

  void pushOffAllNamed(String routeName, {dynamic arguments}) {
    final route = _findRoute(routeName);
    if (route != null) {
      if (arguments != null) _routeArguments[routeName] = arguments;
      _pageStacks[selectedIndex.value] = [route.page()];
      update();
    }
  }

  bool popPage() {
    if (_pageStacks[selectedIndex.value].length > 1) {
      _pageStacks[selectedIndex.value].removeLast();
      update();
      return true;
    }
    return false;
  }

  GetPage? _findRoute(String routeName) {
    try {
      return routesHandler.firstWhere((route) => route.name == routeName);
    } catch (_) {
      return null;
    }
  }

  Widget get currentPage {
    if (_pageStacks.isEmpty || selectedIndex.value >= _pageStacks.length) {
      return const HomeScreen();
    }
    return _pageStacks[selectedIndex.value].last;
  }
}
