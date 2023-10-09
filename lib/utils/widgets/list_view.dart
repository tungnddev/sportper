import 'package:flutter/material.dart';

class ListViewLoadMoreAndRefresh extends StatefulWidget {
  final Widget Function(dynamic item, int index) item;
  final Function() onRefresh;
  final Function() onLoadMore;
  final List? list;

  ListViewLoadMoreAndRefresh({required this.item, required this.onLoadMore, required this.onRefresh, required this.list});

  @override
  _ListViewLoadMoreAndRefreshState createState() =>
      _ListViewLoadMoreAndRefreshState();
}

class _ListViewLoadMoreAndRefreshState
    extends State<ListViewLoadMoreAndRefresh> {
  bool isLoadMore = false;
  static const offsetVisibleThreshold = 50;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if ((_scrollController.offset + offsetVisibleThreshold >=
          _scrollController.position.maxScrollExtent) &&
          !isLoadMore) {
        isLoadMore = true;
        widget.onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.list!.last != null) {
      isLoadMore = false;
    }
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () async{
        widget.onRefresh();
      },
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) => widget.item(widget.list![index], index),
        itemCount: widget.list!.length,
      ),
    );
  }
}

class ListViewLoadMore extends StatefulWidget {
  final Widget Function(dynamic item, int index) item;
  final Function() onLoadMore;
  final List list;
  final bool isReverse;
  final scrollController;

  ListViewLoadMore({required this.item, required this.onLoadMore, required this.list, this.isReverse = false, this.scrollController});

  @override
  _ListViewLoadMoreState createState() =>
      _ListViewLoadMoreState();
}

class _ListViewLoadMoreState
    extends State<ListViewLoadMore> {
  bool isLoadMore = false;
  static const offsetVisibleThreshold = 50;
  var _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(() {
      if ((_scrollController.offset + offsetVisibleThreshold >=
          _scrollController.position.maxScrollExtent) &&
          !isLoadMore) {
        isLoadMore = true;
        widget.onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.list.isEmpty) return Container();
    if (widget.list.last != null) {
      isLoadMore = false;
    }
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) => widget.item(widget.list[index], index),
      itemCount: widget.list.length,
      reverse: widget.isReverse,
    );
  }
}
