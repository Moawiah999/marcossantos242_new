import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';

class PgCreatePostAddLocation extends StatefulWidget {
  final String postLocation;

  const PgCreatePostAddLocation({
    Key? key,
    required this.postLocation,
  }) : super(key: key);

  @override
  _PgCreatePostAddLocationState createState() => _PgCreatePostAddLocationState();
}

class _PgCreatePostAddLocationState extends State<PgCreatePostAddLocation> with AppUtilsMixin {
  late final TextEditingController _searchTextFieldEditingController;

  @override
  void initState() {
    super.initState();
    _searchTextFieldEditingController = TextEditingController(text: widget.postLocation);
  }

  @override
  void dispose() {
    _searchTextFieldEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.addLocation),
      actions: [
        GestureDetector(
          onTap: _saveChanges,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Icon(Icons.check, color: ThemeBloc.colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ThemeBloc.widgetInterface.standardTextField(
        context: context,
        controller: _searchTextFieldEditingController,
        hintText: AppLocalizations.of(context)!.addLocation,
      ),
    );
  }

  void _saveChanges() {
    Navigator.of(context).pop(_searchTextFieldEditingController.value.text);
  }
}
