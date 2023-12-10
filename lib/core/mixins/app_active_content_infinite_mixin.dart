import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';

mixin AppActiveContentInfiniteMixin<T extends StatefulWidget> on State<T> {
  late final AppActiveContent activeContent;
  late final scrollController = ScrollController();

  var latestContentId = 0;
  var bottomContentId = 0;

  var isEndOfResults = false;
  var isLoadingBottom = false;
  var isLoadingLatest = false;

  var isLoadingCallInStack = false;

  /// available for override to widgets

  void onLoadEvent() => 'nop';
  void onDisposeEvent() => 'nop';
  bool onReloadBeforeEvent() => true;
  void onReloadAfterEvent() => 'nop';

  @override
  void initState() {
    super.initState();
    activeContent = AppActiveContent(context);
    onLoadEvent();
  }

  @override
  void dispose() {
    onDisposeEvent();
    activeContent.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> contentMixinReloadPage() async {
    unRegisterLoadingCall();

    var isReloadable = onReloadBeforeEvent();

    if (false == isReloadable) return;

    setState(() {
      contentMixinClearState();
    });

    Future.delayed(Duration.zero, () async {
      onReloadAfterEvent();
    });
  }

  void contentMixinClearState() {
    var isInitialized = true;

    try {
      // when active content is not initialized
      // this will throw an exception
      activeContent.context;
    } catch (_) {
      isInitialized = false;
    }

    if (isInitialized) {
      activeContent.clear();
    }

    contentMixinUpdateData(
      setLatestContentId: 0,
      setBottomContentId: 0,
      setLoadingLatest: false,
      setLoadingBottom: false,
      setEndOfResults: false,
      callback: null,
    );
  }

  void contentMixinUpdateData({
    int? setLatestContentId,
    int? setBottomContentId,
    bool? setLoadingBottom,
    bool? setLoadingLatest,
    bool? setEndOfResults,
    Function? callback,
  }) {
    if (null != setLoadingLatest) {
      isLoadingLatest = setLoadingLatest;
    }
    if (null != setLoadingBottom) {
      isLoadingBottom = setLoadingBottom;
    }
    if (null != setEndOfResults) {
      isEndOfResults = setEndOfResults;
    }
    if (null != setLatestContentId) {
      latestContentId = setLatestContentId;
    }
    if (null != setBottomContentId) {
      bottomContentId = setBottomContentId;
    }

    if (null != callback) {
      callback();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | load content:
  |--------------------------------------------------------------------------
  */

  Future<void> contentMixinLoadContent({
    bool latest = false,
    required waitForFrame,
    required String latestEndpoint,
    required String bottomEndpoint,
    required Function requestDataGenerator,
    required Function({
      required bool latest,
      required ResponseModel responseModel,
    })?
        responseHandler,
  }) async {
    if (endOfResults()) return;

    if (!registerLoadingCall()) return;

    procedure() async {
      _startPreloaders(latest: latest);

      var responseModel = await AppProvider.of(context).apiRepo.preparedRequest(
            requestType: latest ? latestEndpoint : bottomEndpoint,
            requestData: Map<String, dynamic>.from(requestDataGenerator()),
          );

      // ignore response if user has called unregister
      if (!isLoadingCallInStack) return;

      if (responseModel.isNotResponse) {
        ThemeBloc.actionInterface.showMessageInsidePopUp(
          context: context,
          waitForFrame: false,
          message: AppLocalizations.of(context)!.somethingWentWrongMessage,
        );
      } else {
        // move user to something went wrong screen ERROR_BAD_REQUEST_MSG
        // usually happens when parent content is not available anymore
        // for now we will simply hung the further content polling
        endOfResults(responseModel.message == END_OF_RESULTS_MSG || responseModel.message == ERROR_BAD_REQUEST_MSG);

        // pass to user defined response handler
        if (null != responseHandler) {
          responseHandler(latest: latest, responseModel: responseModel);
        }
      }

      stopPreloaders(latest: latest);

      unRegisterLoadingCall();
    }

    if (waitForFrame) {
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await procedure();
      });
    } else {
      await procedure();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | preloaders:
  |--------------------------------------------------------------------------
  */

  bool registerLoadingCall() {
    if (isLoadingCallInStack) return false;
    isLoadingCallInStack = true;
    return true;
  }

  bool unRegisterLoadingCall() {
    isLoadingCallInStack = false;
    return true;
  }

  /*
  |--------------------------------------------------------------------------
  | preloaders:
  |--------------------------------------------------------------------------
  */

  bool _startPreloaders({required bool latest}) {
    if (latest) {
      loadingLatest(true);
    } else {
      loadingBottom(true);
    }

    return true;
  }

  bool stopPreloaders({required bool latest}) {
    if (latest) {
      loadingLatest(false);
    } else {
      loadingBottom(false);
    }

    return true;
  }

  bool loadingLatest([bool? type]) {
    if (null != type) {
      setState(() {
        isLoadingLatest = type;
      });
    }
    return isLoadingLatest;
  }

  bool loadingBottom([bool? type]) {
    if (null != type) {
      setState(() {
        isLoadingBottom = type;
      });
    }
    return isLoadingBottom;
  }

  bool endOfResults([bool? type]) {
    if (null != type) {
      isEndOfResults = type;
    }
    return isEndOfResults;
  }
}
