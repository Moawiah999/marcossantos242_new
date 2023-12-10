import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';
import 'package:photogram/theme/photogram/include/pages/search/pg_search_page.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/post/pg_feed_post_widget.dart';

class PgFeedsPage extends FeedsPage {
  const PgFeedsPage({Key? key}) : super(key: key);

  @override
  _PgFeedsPageState createState() => _PgFeedsPageState();
}

class _PgFeedsPageState extends State<PgFeedsPage> with AppActiveContentInfiniteMixin, AppUtilsMixin {
  final _postIds = <int>[];
  final ScrollController _controller = ScrollController();

  final _infinitePostIds = <int>[];
  var _switchedToInfiniteMode = false;
  var _infiniteModeSwitchIndex = -1;

  @override
  void onLoadEvent() {
    _loadPosts(latest: true);
  }

  @override
  onReloadBeforeEvent() {
    _postIds.clear();
    _infinitePostIds.clear();
    _switchedToInfiniteMode = false;
    _infiniteModeSwitchIndex = -1;
    return true;
  }

  @override
  onReloadAfterEvent() {
    _loadPosts(latest: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            _controller.animateTo(
              0.0,
              duration: const Duration(seconds: 2),
              curve: Curves.ease,
            );
            onReloadAfterEvent();
          },
          child: Row(
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/png/Spalhe.png',
                    height: 30,
                    color: ThemeBloc.colorScheme.onBackground,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Image.asset(
                      'assets/png/color_spalhe.png',
                      height: 5,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  activeContent.themeBloc.pushEvent(
                    ThemeEventToggleThemeMode(context, ThemeBloc.getThemeMode),
                  );
                },
                child: SvgPicture.asset(
                  'assets/svg/raio.svg',
                  color: ThemeBloc.colorScheme.onBackground,
                  height: 23,
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                const SizedBox(width: 14),
                InkWell(
                  onTap: () {
                    PgUtils.openCreatePostPage(utilMixinSetState);
                  },
                  child: SvgPicture.asset(
                    AppIcons.appBarCreatePost,
                    color: ThemeBloc.colorScheme.onBackground,
                    height: 26,
                  ),
                ),
                const SizedBox(width: 14),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PgSearchPage(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/svg/starby.svg',
                    width: 46,
                    color: ThemeBloc.colorScheme.onBackground,
                    height: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: contentMixinReloadPage,
        child: Stack(
          children: [
            if (isLoadingLatest)
              Positioned(
                top: 0,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.all(5),
                      color: ThemeBloc.colorScheme.background,
                      child: PgUtils.darkCupertinoActivityIndicator(),
                    ),
                  ],
                ),
              ),
            ListView.builder(
              controller: _controller,
              itemCount: (isLoadingBottom || _switchedToInfiniteMode) ? _postIds.length + 1 : _postIds.length,
              itemBuilder: _buildPost,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPost(BuildContext context, int index) {
    // agressive prefetching posts
    if (_postIds.length - 3 < index) {
      donation();
      _loadPosts(waitForFrame: true);
    }

    if (_switchedToInfiniteMode && index == _infiniteModeSwitchIndex) {
      return Column(
        children: [],
      );
    }

    if (_postIds.length > index) {
      return Column(
        children: [
          if (index == 0) ...[donation()],
          PgFeedPostWidget(
            postId: _postIds[index],
            showFollowButton: _switchedToInfiniteMode && index > _infiniteModeSwitchIndex,
          ),
        ],
      );
    }

    if (isEndOfResults) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        PgUtils.darkCupertinoActivityIndicator(),
      ],
    );
  }

  donation() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  launch('https://about.spalhe.com/doacao/pix.html');
                },
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: ThemeBloc.colorScheme.background,
                    image: const DecorationImage(
                      image: AssetImage('assets/png/doacao.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(
                      color: Color(0xff7833E8),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ThemeBloc.textInterface.normalBlackH5Text(
                text: 'Doação!',
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFeedsSwitchedInfoBlock() {
    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            Column(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Column(
                      children: [
                        PgUtils.sizedBoxH(15),
                        _infiniteModeSwitchIndex == 0
                            ? const Icon(Icons.favorite_outline)
                            : SvgPicture.asset(
                                'assets/svg/visto.svg',
                                height: 30,
                              ),
                        PgUtils.sizedBoxH(10),
                        Text(
                          _infiniteModeSwitchIndex == 0
                              ? AppLocalizations.of(context)!.youMadeIt
                              : AppLocalizations.of(context)!.youAreAllCaughtUp,
                          style: ThemeBloc.textInterface.boldBlackH2TextStyle(),
                          textAlign: TextAlign.center,
                        ),
                        PgUtils.sizedBoxH(10),
                        Text(
                          _infiniteModeSwitchIndex == 0
                              ? AppLocalizations.of(context)!.welcomeToYourFeedsDescription
                              : AppLocalizations.of(context)!.showingSuggestedPostsDescription,
                          style: ThemeBloc.textInterface.normalGreyH5TextStyle(),
                          textAlign: TextAlign.center,
                        ),
                        PgUtils.sizedBoxH(20),
                        ThemeBloc.widgetInterface.divider(),
                        if (_infiniteModeSwitchIndex == 0) PgUtils.sizedBoxH(60),
                        if (_infiniteModeSwitchIndex == 0)
                          Text(
                            AppLocalizations.of(context)!.keepScrollForNewestPosts,
                            style: ThemeBloc.textInterface.normalGreyH5TextStyle(),
                            textAlign: TextAlign.center,
                          ),
                        if (_infiniteModeSwitchIndex == 0) PgUtils.sizedBoxH(20),
                        if (_infiniteModeSwitchIndex == 0) const Icon(Icons.arrow_downward_outlined),
                        PgUtils.sizedBoxH(25),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _loadPosts({bool latest = false, bool waitForFrame = false}) async {
    if (_switchedToInfiniteMode) {
      return contentMixinLoadContent(
        latest: false,
        waitForFrame: waitForFrame,
        responseHandler: handleResponse,
        latestEndpoint: '',
        bottomEndpoint: REQ_TYPE_POST_INFINITE_LOAD,
        requestDataGenerator: () => {
          RequestTable.offset: {
            PostTable.tableName: {PostTable.id: _infinitePostIds.isEmpty ? 0 : _infinitePostIds.reduce(min)},
          }
        },
      );
    }

    print('hehe');
    contentMixinLoadContent(
      latest: latest,
      waitForFrame: waitForFrame,
      responseHandler: handleResponse,
      latestEndpoint: REQ_TYPE_POST_GLOBAL_FEED_LOAD_LATEST,
      bottomEndpoint: REQ_TYPE_POST_GLOBAL_FEED_LOAD_BOTTOM,
      requestDataGenerator: () => {
        RequestTable.offset: {
          PostTable.tableName: {PostTable.id: latest ? latestContentId : bottomContentId},
        },
      },
    );
  }

  handleResponse({
    bool latest = false,
    required ResponseModel responseModel,
  }) {
    setState(() {
      activeContent.handleResponse(responseModel);

      activeContent.pagedModels<PostModel>().forEach((postId, postModel) {
        if (!_postIds.contains(postId)) {
          _postIds.add(postId);
        }

        if (_switchedToInfiniteMode) {
          if (!_infinitePostIds.contains(postId)) {
            _infinitePostIds.add(postId);
          }
        }
      });

      if (!_switchedToInfiniteMode) {
        contentMixinUpdateData(
          setLatestContentId: _postIds.isEmpty ? 0 : _postIds.reduce(max),
          setBottomContentId: _postIds.isEmpty ? 0 : _postIds.reduce(min),
        );

        if (endOfResults()) {
          _switchedToInfiniteMode = true;
          _infiniteModeSwitchIndex = _postIds.length;

          Future.delayed(Duration.zero, () {
            endOfResults(false);
            _postIds.add(0);
            _loadPosts();
          });
        }
      }
    });
  }
}
