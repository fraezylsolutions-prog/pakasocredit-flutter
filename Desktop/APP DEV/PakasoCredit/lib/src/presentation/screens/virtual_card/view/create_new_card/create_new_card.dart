import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/styles/app_styles.dart';
import 'package:pakaso_credit/src/common/controller/country_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/controller/create_new_card_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/view/create_new_card/sub_sections/card_holder_radio_section.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/view/create_new_card/sub_sections/choose_card_holder_section.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/view/create_new_card/sub_sections/choose_card_provider_section.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/view/create_new_card/sub_sections/create_new_card_holder_section.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateNewCard extends StatefulWidget {
  const CreateNewCard({super.key});

  @override
  State<CreateNewCard> createState() => _CreateNewCardState();
}

class _CreateNewCardState extends State<CreateNewCard> {
  final ThemeController themeController = Get.find<ThemeController>();
  final CreateNewCardController createNewCardController = Get.put(
    CreateNewCardController(),
  );
  final CountryController countryController = Get.put(CountryController());

  @override
  void initState() {
    super.initState();
    createNewCardController.clearFields();
    loadData();
  }

  Future<void> loadData() async {
    createNewCardController.isLoading.value = true;
    await createNewCardController.fetchCardProviders();
    await createNewCardController.fetchCardHolders();
    await countryController.fetchCountries();
    createNewCardController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 16),
                CommonAppBar(
                  title: "virtualCard.create_card.title".trns(),
                  isPopEnabled: false,
                  showRightSideIcon: false,
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Obx(() {
                    if (createNewCardController.isLoading.value) {
                      return const CommonLoading();
                    }

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(18),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkSecondary
                                : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppStyles.boxShadow(),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ChooseCardProviderSection(),
                            SizedBox(height: 20),
                            CardHolderTabSection(
                              createNewCardController: createNewCardController,
                            ),
                            Obx(
                              () => Visibility(
                                visible:
                                    createNewCardController.selectedTab.value,
                                child: SizedBox(height: 20),
                              ),
                            ),
                            Obx(
                              () => Visibility(
                                visible:
                                    !createNewCardController.selectedTab.value,
                                child: SizedBox(height: 20),
                              ),
                            ),
                            ChooseCardHolderSection(
                              createNewCardController: createNewCardController,
                            ),
                            CreateNewCardHolderSection(
                              createNewCardController: createNewCardController,
                              countryController: countryController,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: CommonElevatedButton(
                    buttonName: "virtualCard.create_card.button.create".trns(),
                    onPressed: () {
                      if (createNewCardController.validateFields()) {
                        createNewCardController.createNewCard();
                      }
                    },
                  ),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: createNewCardController.isCreateNewCardLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
