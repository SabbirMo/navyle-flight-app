import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/feed/model/feed_post_model.dart';

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
  @override
  FeedState build() {
    return FeedState(posts: FeedPostModel.initialPosts);
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
    final updatedList = state.posts.map((post) {
      if (post.id == postId) {
        final wasReal = post.isRealVoted;
        final wasSpam = post.isSpamVoted;
        return post.copyWith(
          isRealVoted: !wasReal,
          realCount: wasReal ? (post.realCount - 1) : (post.realCount + 1),
          // If user had marked spam, remove spam vote
          isSpamVoted: wasReal ? wasSpam : false,
          spamCount: (!wasReal && wasSpam)
              ? (post.spamCount - 1)
              : post.spamCount,
        );
      }
      return post;
    }).toList();

    state = state.copyWith(posts: updatedList);
  }

  void toggleSpamVote(String postId) {
    final updatedList = state.posts.map((post) {
      if (post.id == postId) {
        final wasSpam = post.isSpamVoted;
        final wasReal = post.isRealVoted;
        return post.copyWith(
          isSpamVoted: !wasSpam,
          spamCount: wasSpam ? (post.spamCount - 1) : (post.spamCount + 1),
          // If user had marked real, remove real vote
          isRealVoted: wasSpam ? wasReal : false,
          realCount: (!wasSpam && wasReal)
              ? (post.realCount - 1)
              : post.realCount,
        );
      }
      return post;
    }).toList();

    state = state.copyWith(posts: updatedList);
  }

  void addNewPost({
    required String category,
    required String content,
    String authorName = 'You',
  }) {
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

    state = state.copyWith(posts: [newPost, ...state.posts]);
  }

  void editPost({
    required String postId,
    required String category,
    required String content,
  }) {
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
    final updatedList = state.posts.where((post) => post.id != postId).toList();
    state = state.copyWith(posts: updatedList);
  }
}

final feedNotifierProvider = NotifierProvider<FeedNotifier, FeedState>(
  FeedNotifier.new,
);
