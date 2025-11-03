import 'package:avatar_ai/features/auth/viewmodel/auth_view_model.dart';
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
    // Example: you can call a provider here
    // ref.read(authViewModelProvider.notifier).getCurrentUser();
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
            child: Padding(
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
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildCharacterCard(_forYou[index]),
                childCount: _forYou.length,
              ),
            ),
          ),

          // Try these Section
          SliverToBoxAdapter(
            child: Padding(
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
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildCharacterCard(_tryThese[index]),
                childCount: _tryThese.length,
              ),
            ),
          ),

          // Featured Section
          SliverToBoxAdapter(
            child: Padding(
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
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildCharacterCard(_featured[index]),
                childCount: _featured.length,
              ),
            ),
          ),

          SliverPadding(padding: const EdgeInsets.only(bottom: 80)),
        ],
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
                      character.avatar,
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

final List<Character> _forYou = [
  Character(
    name: 'Elon Musk',
    tagline: 'Entrepreneur & innovator behind Tesla, SpaceX',
    avatar: 'EM',
    avatarColor: const Color(0xFF6C63FF),
    chats: 125000000,
    id: '',
    createdAt: DateTime.now(),
  ),
  Character(
    name: 'Raiden Shogun',
    tagline: 'Eternity is the only truth I know',
    avatar: 'RS',
    avatarColor: const Color(0xFF9333EA),
    chats: 98000000,
    id: '',
    createdAt: DateTime.now(),
  ),
  Character(
    name: 'Albert Einstein',
    tagline: 'Theoretical physicist, developer of relativity',
    avatar: 'AE',
    avatarColor: const Color(0xFFEF4444),
    chats: 87000000,
    id: '',
    createdAt: DateTime.now(),
  ),
  Character(
    name: 'Socrates',
    tagline: 'Greek philosopher from Athens',
    avatar: 'SO',
    avatarColor: const Color(0xFF10B981),
    chats: 76000000,
    id: '',
    createdAt: DateTime.now(),
  ),
];

final List<Character> _tryThese = [
  Character(
    name: 'Anime Girl',
    tagline: 'Cute anime companion for fun conversations',
    avatar: 'AG',
    avatarColor: const Color(0xFFEC4899),
    chats: 145000000,
    id: '',
    createdAt: DateTime.now(),
  ),
  Character(
    name: 'Creative Helper',
    tagline: 'I help you write stories, poems, and more!',
    avatar: 'CH',
    avatarColor: const Color(0xFF8B5CF6),
    chats: 54000000,
    id: '',
    createdAt: DateTime.now(),
  ),
  Character(
    name: 'Psychologist',
    tagline: 'Professional counselor here to listen',
    avatar: 'PS',
    avatarColor: const Color(0xFF06B6D4),
    chats: 67000000,
    id: '',
    createdAt: DateTime.now(),
  ),
  Character(
    name: 'Game Master',
    tagline: 'Your guide through epic adventures',
    avatar: 'GM',
    avatarColor: const Color(0xFFF59E0B),
    chats: 43000000,
    id: '',
    createdAt: DateTime.now(),
  ),
];

final List<Character> _featured = [
  Character(
    name: 'Shakespeare',
    tagline: 'The Bard of Avon, master of words',
    avatar: 'WS',
    avatarColor: const Color(0xFFDB2777),
    chats: 32000000,
    id: '',
    createdAt: DateTime.now(),
  ),
  Character(
    name: 'Mario',
    tagline: 'It\'s-a me! Let\'s-a go!',
    avatar: 'MA',
    avatarColor: const Color(0xFFDC2626),
    chats: 89000000,
    id: '',
    createdAt: DateTime.now(),
  ),
  Character(
    name: 'Tech Support',
    tagline: 'Have you tried turning it off and on?',
    avatar: 'TS',
    avatarColor: const Color(0xFF2563EB),
    chats: 28000000,
    id: '',
    createdAt: DateTime.now(),
  ),
  Character(
    name: 'Fitness Coach',
    tagline: 'Push yourself to the limit!',
    avatar: 'FC',
    avatarColor: const Color(0xFF16A34A),
    chats: 41000000,
    id: '',
    createdAt: DateTime.now(),
  ),
];
