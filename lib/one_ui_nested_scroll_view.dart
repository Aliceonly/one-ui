import 'package:flutter/material.dart';
import 'package:frist/fade_animation.dart';

class OneUiNestedScrollView extends StatefulWidget {
  final double? expandedHeight;
  final double? toolbarHeight;
  final Widget? expandedWidget;
  final Widget? collapsedWidget;
  final BoxDecoration? boxDecoration;
  final Widget? lendingIcon;
  final List<Widget>? actions;
  final SliverList sliverList;
  final Color? sliverBackgroundColor;

  const OneUiNestedScrollView(
      {super.key,
      this.expandedHeight,
      this.toolbarHeight,
      this.expandedWidget,
      this.boxDecoration,
      this.collapsedWidget,
      this.lendingIcon,
      this.actions,
      required this.sliverList,
      this.sliverBackgroundColor});

  @override
  State<OneUiNestedScrollView> createState() => _OneUiNestedScrollViewState();
}

class _OneUiNestedScrollViewState extends State<OneUiNestedScrollView> {
  late double _expandedHeight;
  late double _toolBarHeight;

  double calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio = (constraints.maxHeight - _toolBarHeight) /
        (_expandedHeight - _toolBarHeight);
    if (expandRatio > 1.0) expandRatio = 1;
    if (expandRatio < 0.0) expandRatio = 0;
    return expandRatio;
  }

  List<Widget> handlerSliverBuilder(
      BuildContext context, bool innerBoxIsScrolled) {
    return [
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar(
          expandedHeight: _expandedHeight,
          pinned: true,
          toolbarHeight: _toolBarHeight,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              final expandRatio = calculateExpandRatio(constraints);
              final animation = AlwaysStoppedAnimation(expandRatio);

              return Stack(
                children: [
                  Container(
                    decoration: widget.boxDecoration,
                  ),
                  if (widget.expandedWidget != null)
                    Center(
                      child: FadeAnimation(
                        animation: animation,
                        isExpandedWidget: true,
                        child: widget.expandedWidget!,
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: _toolBarHeight,
                      child: Row(children: [
                        if (widget.lendingIcon != null) widget.lendingIcon!,
                        if (widget.collapsedWidget != null)
                          Padding(
                            padding: EdgeInsets.only(
                                left: widget.lendingIcon != null ? 0 : 20),
                            child: FadeAnimation(
                              animation: animation,
                              isExpandedWidget: false,
                              child: widget.collapsedWidget!,
                            ),
                          ),
                        if (widget.actions != null)
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: widget.actions!.reversed.toList(),
                            ),
                          )
                      ]),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      )
    ];
  }

  Widget body() {
    return Container(
      color: widget.sliverBackgroundColor ??
          Theme.of(context).scaffoldBackgroundColor,
      child: Builder(builder: (BuildContext context) {
        return CustomScrollView(
          slivers: [
            SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
            widget.sliverList
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    _expandedHeight =
        widget.expandedHeight ?? MediaQuery.of(context).size.height * 3 / 8;
    _toolBarHeight = widget.toolbarHeight ?? kToolbarHeight;

    return NestedScrollView(
      headerSliverBuilder: handlerSliverBuilder,
      body: body(),
    );
  }
}
