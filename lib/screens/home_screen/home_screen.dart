import 'package:flutter/material.dart';

import '../../ui/ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels > 600) {
      setState(() {
        _showAppBar = true;
      });
    } else {
      setState(() {
        _showAppBar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_showAppBar ? 56.0 : 0.0),
        child: AnimatedOpacity(
          opacity: _showAppBar ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: AppBar(
            backgroundColor: const Color(0xFF0097b2),
            title: Text(
              'PAÝLAŞ',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.canvasColor,
              ),
            ),
            actions: [
              GestureDetector(
                child: Container(
                  width: 70,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image.asset('assets/send-icon.png'),
                ),
                onTap: () {},
              ),
              GestureDetector(
                child: Container(
                  width: 70,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image.asset('assets/upload-icon.png'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 100.0),
              child: CircleIcon(
                imageUrl: 'assets/send-icon.png',
                color: Color(0xFF0097b2),
                size: 200,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
          const SliverToBoxAdapter(
            child: CircleIcon(
              imageUrl: 'assets/upload-icon.png',
              color: Color(0xFFc1ff72),
              size: 200,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: SizedBox(
                width: mediaQuery.size.width * 0.8,
                child: Text(
                  'Ähli faýllaryňy gysga wagtyň içinde paýlaş',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(color: theme.canvasColor, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
