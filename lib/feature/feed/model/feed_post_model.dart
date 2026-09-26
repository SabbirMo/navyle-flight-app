import 'package:flutter/material.dart';

/// Data model representing a community feed update item
class FeedPostModel {
  final String id;
  final String authorName;
  final String? avatarUrl;
  final String timeAgo;
  final String category; // 'SECURITY', 'ESCALATOR', 'GATE', 'LIFTS', etc.
  final String content;
  final int realCount;
  final int spamCount;
  final bool isRealVoted;
  final bool isSpamVoted;
  final bool isMyPost;
  final DateTime createdAt;

  const FeedPostModel({
    required this.id,
    required this.authorName,
    this.avatarUrl,
    required this.timeAgo,
    required this.category,
    required this.content,
    required this.realCount,
    required this.spamCount,
    this.isRealVoted = false,
    this.isSpamVoted = false,
    this.isMyPost = false,
    required this.createdAt,
  });

  FeedPostModel copyWith({
    String? id,
    String? authorName,
    String? avatarUrl,
    String? timeAgo,
    String? category,
    String? content,
    int? realCount,
    int? spamCount,
    bool? isRealVoted,
    bool? isSpamVoted,
    bool? isMyPost,
    DateTime? createdAt,
  }) {
    return FeedPostModel(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      timeAgo: timeAgo ?? this.timeAgo,
      category: category ?? this.category,
      content: content ?? this.content,
      realCount: realCount ?? this.realCount,
      spamCount: spamCount ?? this.spamCount,
      isRealVoted: isRealVoted ?? this.isRealVoted,
      isSpamVoted: isSpamVoted ?? this.isSpamVoted,
      isMyPost: isMyPost ?? this.isMyPost,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Get tag background color based on category
  Color get tagBackgroundColor {
    switch (category.toUpperCase()) {
      case 'SECURITY':
        return const Color(0xFFFFF1E6); // Light orange tint
      case 'ESCALATOR':
      case 'LIFT':
      case 'LIFTS':
        return const Color(0xFFE0F2FE); // Light sky blue
      case 'GATE':
      case 'GATES':
        return const Color(0xFFF3E8FF); // Light lavender
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  /// Get tag text color based on category
  Color get tagTextColor {
    switch (category.toUpperCase()) {
      case 'SECURITY':
        return const Color(0xFFEA580C); // Warm orange
      case 'ESCALATOR':
      case 'LIFT':
      case 'LIFTS':
        return const Color(0xFF0284C7); // Crisp blue
      case 'GATE':
      case 'GATES':
        return const Color(0xFF9333EA); // Purple
      default:
        return const Color(0xFF475569);
    }
  }

  /// Initial sample feed items matching user's design
  static List<FeedPostModel> get initialPosts => [
    FeedPostModel(
      id: 'post_1',
      authorName: 'Sarah Jenkins',
      avatarUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150',
      timeAgo: 'Just now',
      category: 'SECURITY',
      content:
          'Security at T5 South is currently moving very slowly. Expect at least 25-30 mins wait. North seems better!',
      realCount: 12,
      spamCount: 0,
      isMyPost: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
    FeedPostModel(
      id: 'post_2',
      authorName: 'Mark Thompson',
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=150',
      timeAgo: '12 mins ago',
      category: 'ESCALATOR',
      content:
          'The lounge near B12 is currently closed for cleaning. Staff said it should reopen in 45 mins.',
      realCount: 8,
      spamCount: 1,
      isMyPost: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    FeedPostModel(
      id: 'post_3',
      authorName: 'Emily Chen',
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=150',
      timeAgo: '45 mins ago',
      category: 'GATE',
      content:
          'Boarding for BA245 is delayed by 15 mins. Crew hasn\'t arrived yet.',
      realCount: 15,
      spamCount: 0,
      isMyPost: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    FeedPostModel(
      id: 'post_my_1',
      authorName: 'Alex Rivers (You)',
      avatarUrl:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=150',
      timeAgo: '2 hours ago',
      category: 'GATE',
      content:
          'The lounge near B12 is currently closed for cleaning. Staff said it should reopen in 45 mins.',
      realCount: 24,
      spamCount: 0,
      isMyPost: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    FeedPostModel(
      id: 'post_my_2',
      authorName: 'Alex Rivers (You)',
      avatarUrl:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=150',
      timeAgo: '5 hours ago',
      category: 'LIFT',
      content:
          'Lift #4 near the parking entrance is stuck. Maintenance is on the way.',
      realCount: 15,
      spamCount: 2,
      isMyPost: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];
}
