import 'package:flutter/material.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';

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
        return AppColors.feedOrangeBg; // Light orange tint
      case 'ESCALATOR':
      case 'LIFT':
      case 'LIFTS':
        return AppColors.feedBlueBg; // Light sky blue
      case 'GATE':
      case 'GATES':
        return AppColors.feedPurpleBg; // Light lavender
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  /// Get tag text color based on category
  Color get tagTextColor {
    switch (category.toUpperCase()) {
      case 'SECURITY':
        return AppColors.feedOrange; // Warm orange
      case 'ESCALATOR':
      case 'LIFT':
      case 'LIFTS':
        return AppColors.blue2563EB; // Crisp blue
      case 'GATE':
      case 'GATES':
        return AppColors.feedPurple; // Purple
      default:
        return const Color(0xFF475569);
    }
  }
}
