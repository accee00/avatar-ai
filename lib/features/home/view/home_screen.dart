import 'package:avatar_ai/features/auth/viewmodel/auth_view_model.dart';

import 'package:avatar_ai/features/home/viewmodel/home_view_model.dart';
import 'package:avatar_ai/models/character_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  List<Character> get _forYou {
    final homeState = ref.watch(homeViewModelProvider).value;
    return homeState?.forYou ?? [];
  }

  List<Character> get _tryThese {
    final homeState = ref.watch(homeViewModelProvider).value;
    return homeState?.newToYou ?? [];
  }

  List<Character> get _featured {
    final homeState = ref.watch(homeViewModelProvider).value;
    return homeState?.frequentlyUsed ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            backgroundColor: const Color(0xFF0A0A0A),
            title: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF6C63FF),
                        const Color(0xFF00D9FF),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'avatar.ai',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () {
                  ref.read(authViewModelProvider.notifier).signOut();
                },
              ),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Search for Characters',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ),

          // Welcome Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        const Color(0xFF6C63FF),
                        const Color(0xFF00D9FF),
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Continue your conversations',
                    style: TextStyle(fontSize: 15, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // For You Section
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'For you',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildHorizontalGrid(_forYou),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Try these Section
          _tryThese.isNotEmpty
              ? SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Try these',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildHorizontalGrid(_tryThese),
                      const SizedBox(height: 24),
                    ],
                  ),
                )
              : SliverToBoxAdapter(child: SizedBox.shrink()),

          // Featured Section
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Featured',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildHorizontalGrid(_featured),
              ],
            ),
          ),

          SliverPadding(padding: const EdgeInsets.only(bottom: 80)),
        ],
      ),
    );
  }

  Widget _buildHorizontalGrid(List<Character> characters) {
    if (characters.isEmpty) return const SizedBox.shrink();

    final int pageCount = (characters.length / 4).ceil();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: PageView.builder(
        padEnds: false,
        controller: PageController(viewportFraction: 0.9),
        itemCount: pageCount,

        itemBuilder: (context, pageIndex) {
          final int startIndex = pageIndex * 4;
          final int endIndex = (startIndex + 4).clamp(0, characters.length);
          final List<Character> pageCharacters = characters.sublist(
            startIndex,
            endIndex,
          );
          if (pageIndex >= pageCount) {
            final homeState = ref.watch(homeViewModelProvider).value;
            if (homeState?.isLoadingMore ?? false) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
              );
            }
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: pageCharacters.length,
              itemBuilder: (context, index) {
                return _buildCharacterCard(pageCharacters[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCharacterCard(Character character) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        character.avatarColor,
                        character.avatarColor.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      character.name[0],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  character.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    character.tagline,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatChats(character.chats),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatChats(int chats) {
    if (chats >= 1000000) {
      return '${(chats / 1000000).toStringAsFixed(1)}m';
    } else if (chats >= 1000) {
      return '${(chats / 1000).toStringAsFixed(1)}k';
    }
    return chats.toString();
  }
}
