import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _items = [];
  final int _batchSize = 20;
  final int _n = 5;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMoreItems();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreItems();
      }
    });
  }

  void _loadMoreItems() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));

    final newItems = List.generate(
      _batchSize,
      (index) => 'Item ${_items.length + index + 1}',
    );
    setState(() {
      _items.addAll(newItems);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Widget> _buildSlivers() {
    List<Widget> slivers = [];

    for (int i = 0; i < _items.length; i++) {
      if (i % _n == 0 && i != 0) {
        slivers.add(
          SliverAppBar(
            pinned: i % 2 == 0 ? false : true,
            floating: false,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('SliverAppBar after item $i'),
            ),
          ),
        );
      }

      slivers.add(SliverToBoxAdapter(child: ListTile(title: Text(_items[i]))));
    }

    if (_isLoading) {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    return slivers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Slivers task")),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: _buildSlivers(),
      ),
    );
  }
}
