import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:paylash/providers/is_loaction_enabled_provider.dart';
import 'package:paylash/providers/is_wifi_direct_enabled_provider.dart';
import 'package:paylash/ui/widgets/circle_icon.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBar = false;

  @override
  void initState() {
    super.initState();
    ref.read(isLocationEnabledProvider.notifier).checkLocation();
    ref.read(isWifiDirectEnabledProvider.notifier).checkWifiDirect();
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
    final isLocationEnabled = ref.watch(isLocationEnabledProvider);
    final isWifiDirectEnabled = ref.watch(isWifiDirectEnabledProvider);

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
                child: _buildIcon('assets/send-icon.png'),
                onTap: () {
                  // Your send button logic
                },
              ),
              GestureDetector(
                child: _buildIcon('assets/upload-icon.png'),
                onTap: () {
                  // Your upload button logic
                },
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: GestureDetector(
                child: const CircleIcon(
                  imageUrl: 'assets/send-icon.png',
                  color: Color(0xFF0097b2),
                  size: 200,
                ),
                onTap: () {
                  if (!isWifiDirectEnabled || !isLocationEnabled) {
                    context.go('/enable');
                    return;
                  }
                  context.go('/devices');
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
          SliverToBoxAdapter(
            child: GestureDetector(
              child: const CircleIcon(
                imageUrl: 'assets/upload-icon.png',
                color: Color(0xFFc1ff72),
                size: 200,
              ),
              onTap: () {
                if (!isWifiDirectEnabled || !isLocationEnabled) {
                  context.go('/enable');
                  return;
                }
                context.go('/waiting-for-connection');
              },
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

  // Helper function to build rounded icons
  Widget _buildIcon(String imageUrl) {
    return Container(
      width: 70,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Image.asset(imageUrl),
    );
  }
}
