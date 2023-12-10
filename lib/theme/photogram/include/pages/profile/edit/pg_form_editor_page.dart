import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgFormEditorPage extends FormEditorPage {
  final String screenTitle;
  final String screenDescription;
  final FormEditorType formEditorType;

  const PgFormEditorPage({
    Key? key,
    required this.screenTitle,
    required this.formEditorType,
    required this.screenDescription,
  }) : super(key: key);

  @override
  State<PgFormEditorPage> createState() => _PgFormEditorPageState();
}

class _PgFormEditorPageState extends State<PgFormEditorPage> with AppActiveContentMixin {
  late final _formEditorBloc = FormEditorBloc(formEditorType: widget.formEditorType);
  final _focusNodes = <String, FocusNode>{};
  final _fieldEditingControllers = <String, TextEditingController>{};

  @override
  void onLoadEvent() {
    for (var element in widget.formEditorType.fields) {
      _focusNodes[element.getTableField] = FocusNode();
      _fieldEditingControllers[element.getTableField] = TextEditingController(text: element.defaultValue);
    }
  }

  @override
  void onDisposeEvent() {
    _formEditorBloc.dispose();

    for (var node in _focusNodes.values) {
      node.dispose();
    }

    for (var node in _fieldEditingControllers.values) {
      node.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FormEditorState>(
        stream: _formEditorBloc.stream,
        builder: (context, snapshot) {
          // form in progress
          var _ignoring = false;
          var _requestError = '';

          // validation error map
          var _validationErrorMessageMap = <String, String>{};

          if (snapshot.hasData) {
            switch (snapshot.data.runtimeType) {
              case FormEditorStateInProgress:
                _ignoring = true;
                break;
              case FormEditorStateValidationError:
                _ignoring = false;

                _validationErrorMessageMap = (snapshot.data as FormEditorStateValidationError).errorMap;

                if (_validationErrorMessageMap.isNotEmpty) {
                  _focusNodes[_validationErrorMessageMap.entries.first.key]!.requestFocus();
                } else {
                  _ignoring = false;
                  _requestError = AppLocalizations.of(context)!.somethingWentWrongMessage;
                }
                break;

              case FormEditorStateDataUpdated:
                activeContent
                    .addOrUpdateModel<UserModel>((snapshot.data as FormEditorStateDataUpdated).updatedUserModel);

                WidgetsBinding.instance?.addPostFrameCallback((_) => AppNavigation.pop());

                return AppUtils.nothing();

              default:
                _ignoring = false;
                _requestError = AppLocalizations.of(context)!.somethingWentWrongMessage;
                break;
            }
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: ThemeBloc.colorScheme.background,
              title: Text(widget.screenTitle),
              leading: GestureDetector(
                key: KeyGen.from(AppWidgetKey.backFormEditorPageIcon),
                onTap: () => AppNavigation.pop(),
                child: const Icon(Icons.arrow_back),
              ),
              actions: [
                GestureDetector(
                  key: KeyGen.from(AppWidgetKey.saveFormEditorPageIcon),
                  onTap: () => _saveFieldData(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: _ignoring
                        ? PgUtils.darkCupertinoActivityIndicator()
                        : Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PgUtils.sizedBoxH(10),
                    if (widget.screenDescription.isNotEmpty)
                      ThemeBloc.textInterface.normalGreyH6Text(text: widget.screenDescription),
                    Text(
                      _requestError,
                      style: ThemeBloc.getThemeData.textTheme.headline5?.copyWith(
                        color: ThemeBloc.getThemeData.errorColor,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: widget.formEditorType.fields.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            PgUtils.sizedBoxH(20),
                            IgnorePointer(
                              ignoring: _ignoring,
                              child: TextField(
                                autofocus: true,
                                key: widget.formEditorType.fields[index].key,
                                focusNode: _focusNodes[widget.formEditorType.fields[index].getTableField],
                                maxLines: widget.formEditorType.fields[index].getMaxLines,
                                controller: _fieldEditingControllers[widget.formEditorType.fields[index].getTableField],
                                obscureText: widget.formEditorType.fields[index].isObscured,
                                decoration: InputDecoration(
                                  label: Text(widget.formEditorType.fields[index].getAnimatedPlaceholderText),
                                  hintText: widget.formEditorType.fields[index].getPlaceholderText,
                                  errorStyle: ThemeBloc.getThemeData.textTheme.headline6?.copyWith(
                                    color: ThemeBloc.getThemeData.errorColor,
                                  ),
                                  errorText:
                                      _validationErrorMessageMap[widget.formEditorType.fields[index].getTableField],
                                  prefixIcon: (widget.formEditorType.fields[index].getPrefixIconData == null)
                                      ? null
                                      : Icon(widget.formEditorType.fields[index].getPrefixIconData),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _saveFieldData() {
    var fieldDataMap = <String, String>{};

    for (var element in widget.formEditorType.fields) {
      fieldDataMap[element.getTableField] = _fieldEditingControllers[element.getTableField]!.text;
    }

    _formEditorBloc.pushEvent(FormEditorEventSaveFieldsData(context, fieldDataMap: fieldDataMap));
  }
}
