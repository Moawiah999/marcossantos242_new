import 'package:flutter/material.dart';
import 'package:photogram/core/bloc/theme/theme_bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/settings/pg_settings_item.dart';

class PgSettingsPage extends SettingsPage {
  final int userId;

  const PgSettingsPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<PgSettingsPage> createState() => _PgSettingsPageState();
}

class _PgSettingsPageState extends State<PgSettingsPage> with AppUtilsMixin {
  final _searchTextController = TextEditingController();
  final _settingItemsAvailable = <PgSettingsItem>[];
  final _settingItemsVisible = <PgSettingsItem>[];

  @override
  void initState() {
    super.initState();

    _searchTextController.addListener(_searchTextChange);

    utilMixinPostSetState(() {
      _settingItemsAvailable.addAll([
        PgSettingsItemNotifications(context: context),
        PgSettingsItemPrivacy(context: context),
        PgSettingsItemSecurity(context: context),
        PgSettingsItemTheme(context: context),
        PgSettingsItemDivider(context: context),
        PgSettingsItemHeader(context: context, headerTitle: AppLocalizations.of(context)!.account),
        PgSettingsItemsPersonalInformationSettings(context: context, userId: widget.userId),
        PgSettingsItemEditProfile(context: context, userId: widget.userId),
        PgSettingsItemLogOut(context: context),
      ]);

      _settingItemsVisible.addAll(_settingItemsAvailable);
    });
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(AppLocalizations.of(context)!.settings),
        leading: GestureDetector(
          onTap: () => AppNavigation.pop(),
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PgUtils.sizedBoxH(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ThemeBloc.widgetInterface.primaryTextField(
                context: context,
                controller: _searchTextController,
                hintText: AppLocalizations.of(context)!.search,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            PgUtils.sizedBoxH(15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: _settingItemsVisible.length,
              itemBuilder: (context, index) => _settingItemsVisible[index].build(),
            ),
            PgUtils.sizedBoxH(15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  ThemeBloc.getThemeMode != AppThemeMode.dark
                      ? AppImages.logoCompanyOnDark
                      : AppImages.logoCompanyOnLight,
                  width: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _searchTextChange() {
    utilMixinSetState(() {
      _settingItemsVisible.clear();

      if (_searchTextController.text.isEmpty) {
        return _settingItemsVisible.addAll(_settingItemsAvailable);
      }

      for (var item in _settingItemsAvailable) {
        if (item.getTitle.toLowerCase().contains(_searchTextController.text.toLowerCase())) {
          _settingItemsVisible.add(item);
        }
      }
    });
  }
}
