import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/feed/model/feed_post_model.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';

enum FeedTab { feed, myPost }

class FeedState {
  final List<FeedPostModel> posts;
  final String selectedCategory;
  final FeedTab selectedTab;
  final List<String> categories;

  const FeedState({
    required this.posts,
    this.selectedCategory = 'All Updates',
    this.selectedTab = FeedTab.feed,
    this.categories = const [
      'All Updates',
      'Security',
      'Gates',
      'Lifts',
      'Escalator',
    ],
  });

  FeedState copyWith({
    List<FeedPostModel>? posts,
    String? selectedCategory,
    FeedTab? selectedTab,
    List<String>? categories,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedTab: selectedTab ?? this.selectedTab,
      categories: categories ?? this.categories,
    );
  }

  /// Returns the posts filtered by selected tab and category
  List<FeedPostModel> get filteredPosts {
    return posts.where((post) {
      // Tab filter: Feed shows community posts, My post shows user's own posts
      if (selectedTab == FeedTab.feed && post.isMyPost) {
        return false;
      }
      if (selectedTab == FeedTab.myPost && !post.isMyPost) {
        return false;
      }

      // Category filter
      if (selectedCategory != 'All Updates') {
        final catClean = selectedCategory.trim().toUpperCase();
        final postCatClean = post.category.trim().toUpperCase();
        // Match exact or singular/plural (e.g. Gates vs Gate, Lifts vs Lift)
        final isMatch =
            postCatClean == catClean ||
            postCatClean.startsWith(
              catClean.length > 4
                  ? catClean.substring(0, catClean.length - 1)
                  : catClean,
            ) ||
            catClean.startsWith(
              postCatClean.length > 4
                  ? postCatClean.substring(0, postCatClean.length - 1)
                  : postCatClean,
            );
        if (!isMatch) return false;
      }

      return true;
    }).toList();
  }
}

class FeedNotifier extends Notifier<FeedState> {
  final List<FeedPostModel> _userCreatedPosts = [];
  final Map<String, bool> _realVoteOverrides = {};
  final Map<String, bool> _spamVoteOverrides = {};
  final Map<String, int> _realCountDeltas = {};
  final Map<String, int> _spamCountDeltas = {};

  @override
  FeedState build() {
    final journeyState = ref.watch(flightJourneyNotifierProvider);
    final communityPosts = _generateRelevantPosts(journeyState);

    // Apply vote overrides/deltas to community posts
    final mappedCommunityPosts = communityPosts.map((post) {
      final isReal = _realVoteOverrides[post.id] ?? post.isRealVoted;
      final isSpam = _spamVoteOverrides[post.id] ?? post.isSpamVoted;
      final realDelta = _realCountDeltas[post.id] ?? 0;
      final spamDelta = _spamCountDeltas[post.id] ?? 0;

      return post.copyWith(
        isRealVoted: isReal,
        isSpamVoted: isSpam,
        realCount: (post.realCount + realDelta).clamp(0, 9999),
        spamCount: (post.spamCount + spamDelta).clamp(0, 9999),
      );
    }).toList();

    // User's own created posts are placed at the beginning when an active flight exists
    final allPosts = journeyState.hasActiveFlight
        ? [..._userCreatedPosts, ...mappedCommunityPosts]
        : const <FeedPostModel>[];

    return FeedState(
      posts: allPosts,
      selectedCategory: stateOrNull?.selectedCategory ?? 'All Updates',
      selectedTab: stateOrNull?.selectedTab ?? FeedTab.feed,
    );
  }

  List<FeedPostModel> _generateRelevantPosts(FlightJourneyState journey) {
    if (!journey.hasActiveFlight) {
      return const [];
    }

    final flightNumber =
        (journey.flightNumber != null && journey.flightNumber!.isNotEmpty)
        ? journey.flightNumber!
        : 'LH215';
    final destinationCode =
        (journey.destinationCode != null && journey.destinationCode!.isNotEmpty)
        ? journey.destinationCode!
        : 'FRA';
    final terminal = (journey.terminal != null && journey.terminal!.isNotEmpty)
        ? journey.terminal!
        : 'Terminal 1';
    final gate = (journey.gate != null && journey.gate!.isNotEmpty)
        ? journey.gate!
        : 'B24';

    final gateLetter =
        RegExp(r'[A-Za-z]').firstMatch(gate)?.group(0)?.toUpperCase() ?? 'B';

    return [
      FeedPostModel(
        id: 'post_sec_1',
        authorName: 'Sarah Jenkins',
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150',
        timeAgo: 'Just now',
        category: 'SECURITY',
        content:
            'Security checkpoint at $terminal is moving steadily. Wait times at checkpoint $gateLetter are around 10-15 mins.',
        realCount: 18,
        spamCount: 0,
        isMyPost: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      FeedPostModel(
        id: 'post_gate_1',
        authorName: 'Emily Chen',
        avatarUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=150',
        timeAgo: '2m ago',
        category: 'GATES',
        content:
            'Gate $gate is confirmed for flight $flightNumber to $destinationCode. Boarding line is already forming.',
        realCount: 42,
        spamCount: 1,
        isMyPost: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      FeedPostModel(
        id: 'post_lift_1',
        authorName: 'Marcus Vance',
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=150',
        timeAgo: '15m ago',
        category: 'LIFTS',
        content:
            'Elevator near $terminal central concourse by Gate $gate is working smoothly with minimal queue.',
        realCount: 9,
        spamCount: 0,
        isMyPost: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      FeedPostModel(
        id: 'post_esc_1',
        authorName: 'David Ross',
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=150',
        timeAgo: '22m ago',
        category: 'ESCALATOR',
        content:
            'Escalator connecting Concourse A to Gate $gate in $terminal is open and clear.',
        realCount: 14,
        spamCount: 0,
        isMyPost: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 22)),
      ),
    ];
  }

  void selectCategory(String category) {
    if (state.selectedCategory != category) {
      state = state.copyWith(selectedCategory: category);
    }
  }

  void selectTab(FeedTab tab) {
    if (state.selectedTab != tab) {
      state = state.copyWith(selectedTab: tab);
    }
  }

  void toggleRealVote(String postId) {
    for (int i = 0; i < _userCreatedPosts.length; i++) {
      if (_userCreatedPosts[i].id == postId) {
        final wasReal = _userCreatedPosts[i].isRealVoted;
        final wasSpam = _userCreatedPosts[i].isSpamVoted;
        _userCreatedPosts[i] = _userCreatedPosts[i].copyWith(
          isRealVoted: !wasReal,
          realCount: wasReal
              ? (_userCreatedPosts[i].realCount - 1)
              : (_userCreatedPosts[i].realCount + 1),
          isSpamVoted: wasReal ? wasSpam : false,
          spamCount: (!wasReal && wasSpam)
              ? (_userCreatedPosts[i].spamCount - 1)
              : _userCreatedPosts[i].spamCount,
        );
      }
    }

    final updatedList = state.posts.map((post) {
      if (post.id == postId) {
        final wasReal = post.isRealVoted;
        final wasSpam = post.isSpamVoted;
        final newReal = !wasReal;
        final newSpam = wasReal ? wasSpam : false;
        final newRealCount = wasReal
            ? (post.realCount - 1)
            : (post.realCount + 1);
        final newSpamCount = (!wasReal && wasSpam)
            ? (post.spamCount - 1)
            : post.spamCount;

        _realVoteOverrides[postId] = newReal;
        _spamVoteOverrides[postId] = newSpam;
        if (newReal && !wasReal) {
          _realCountDeltas[postId] = (_realCountDeltas[postId] ?? 0) + 1;
        } else if (!newReal && wasReal) {
          _realCountDeltas[postId] = (_realCountDeltas[postId] ?? 0) - 1;
        }
        if (!newSpam && wasSpam) {
          _spamCountDeltas[postId] = (_spamCountDeltas[postId] ?? 0) - 1;
        }

        return post.copyWith(
          isRealVoted: newReal,
          realCount: newRealCount,
          isSpamVoted: newSpam,
          spamCount: newSpamCount,
        );
      }
      return post;
    }).toList();

    state = state.copyWith(posts: updatedList);
  }

  void toggleSpamVote(String postId) {
    for (int i = 0; i < _userCreatedPosts.length; i++) {
      if (_userCreatedPosts[i].id == postId) {
        final wasSpam = _userCreatedPosts[i].isSpamVoted;
        final wasReal = _userCreatedPosts[i].isRealVoted;
        _userCreatedPosts[i] = _userCreatedPosts[i].copyWith(
          isSpamVoted: !wasSpam,
          spamCount: wasSpam
              ? (_userCreatedPosts[i].spamCount - 1)
              : (_userCreatedPosts[i].spamCount + 1),
          isRealVoted: wasSpam ? wasReal : false,
          realCount: (!wasSpam && wasReal)
              ? (_userCreatedPosts[i].realCount - 1)
              : _userCreatedPosts[i].realCount,
        );
      }
    }

    final updatedList = state.posts.map((post) {
      if (post.id == postId) {
        final wasSpam = post.isSpamVoted;
        final wasReal = post.isRealVoted;
        final newSpam = !wasSpam;
        final newReal = wasSpam ? wasReal : false;
        final newSpamCount = wasSpam
            ? (post.spamCount - 1)
            : (post.spamCount + 1);
        final newRealCount = (!wasSpam && wasReal)
            ? (post.realCount - 1)
            : post.realCount;

        _spamVoteOverrides[postId] = newSpam;
        _realVoteOverrides[postId] = newReal;
        if (newSpam && !wasSpam) {
          _spamCountDeltas[postId] = (_spamCountDeltas[postId] ?? 0) + 1;
        } else if (!newSpam && wasSpam) {
          _spamCountDeltas[postId] = (_spamCountDeltas[postId] ?? 0) - 1;
        }
        if (!newReal && wasReal) {
          _realCountDeltas[postId] = (_realCountDeltas[postId] ?? 0) - 1;
        }

        return post.copyWith(
          isSpamVoted: newSpam,
          spamCount: newSpamCount,
          isRealVoted: newReal,
          realCount: newRealCount,
        );
      }
      return post;
    }).toList();

    state = state.copyWith(posts: updatedList);
  }

  void addNewPost({
    required String category,
    required String content,
    String authorName = 'Alex Rivers (You)',
  }) {
    final hasActiveFlight =
        ref.read(flightJourneyNotifierProvider).hasActiveFlight;
    if (!hasActiveFlight) return;

    final newPost = FeedPostModel(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      authorName: authorName,
      timeAgo: 'Just now',
      category: category.toUpperCase(),
      content: content,
      realCount: 1,
      spamCount: 0,
      isRealVoted: true,
      isMyPost: true,
      createdAt: DateTime.now(),
    );

    _userCreatedPosts.insert(0, newPost);
    state = state.copyWith(posts: [newPost, ...state.posts]);
  }

  void editPost({
    required String postId,
    required String category,
    required String content,
  }) {
    final hasActiveFlight =
        ref.read(flightJourneyNotifierProvider).hasActiveFlight;
    if (!hasActiveFlight) return;

    for (int i = 0; i < _userCreatedPosts.length; i++) {
      if (_userCreatedPosts[i].id == postId) {
        _userCreatedPosts[i] = _userCreatedPosts[i].copyWith(
          category: category.toUpperCase(),
          content: content,
        );
      }
    }
    final updatedList = state.posts.map((post) {
      if (post.id == postId) {
        return post.copyWith(
          category: category.toUpperCase(),
          content: content,
        );
      }
      return post;
    }).toList();

    state = state.copyWith(posts: updatedList);
  }

  void deletePost(String postId) {
    _userCreatedPosts.removeWhere((post) => post.id == postId);
    final updatedList = state.posts.where((post) => post.id != postId).toList();
    state = state.copyWith(posts: updatedList);
  }

  /// Clears all user created posts and vote overrides upon sign-out.
  void clearUserPosts() {
    _userCreatedPosts.clear();
    _realVoteOverrides.clear();
    _spamVoteOverrides.clear();
    _realCountDeltas.clear();
    _spamCountDeltas.clear();
    state = const FeedState(
      posts: [],
      selectedCategory: 'All Updates',
      selectedTab: FeedTab.feed,
    );
  }
}

final feedNotifierProvider = NotifierProvider<FeedNotifier, FeedState>(
  FeedNotifier.new,
);
