import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/incentive.dart';

const dummyIncentive = Incentive(
  id: "incentive1",
  totalIncentivized: 100,
  pendingIncentive: 200,
  weeklyRank: 1,
);

final dummyUser = User(
    id: "user1",
    telegramId: "telegramUser1",
    facebookId: "facebookUser1",
    userName: "dummyUser",
    firstName: "Dummy",
    lastName: "User",
    dateOfBirth: "1990-01-01",
    email: "dummyuser@example.com",
    gender: "Other",
    roleId: "role1",
    phoneNumber: "+1234567890",
    image: "path/to/dummy/image.jpg",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    token: "dummyToken",
    incentive: dummyIncentive,
    fcmToken: "dummyFCMToken",
    verified: 1,
    levelInfo: UserLevel(level: 1, levelName: 'Beginner'),
    userStat: UserStat(
      favoritesCount: 0,
      reviewsCount: 0,
    ),
    isFollowed: true,
    refreshToken: '');

List<UserReviewModel> dummyUserReviews = [
  UserReviewModel(
    id: "1",
    userId: "100",
    rating: 4.5,
    comment: "Great experience, will definitely come back!",
    upVote: 15,
    downVote: 2,
    visibility: true,
    createdAt: DateTime.parse("2023-04-01"),
    updatedAt: DateTime.parse("2023-04-02"),
    reviewSubject: const ReviewSubject(
      id: "2001",
      name: "Tasty Burger",
      isItem: true,
      imageUrl: "https://example.com/images/burger.jpg",
      itemImages: [],
      itemVideos: [],
    ),
    images: const [
      // ReviewMedia(id: "3001", url: "https://example.com/images/burger.jpg")
    ],
    videos: const [
      // ReviewMedia(id: "4001", url: "https://example.com/videos/burger.mp4")
    ],
    voted: 1,
  ),
  // UserReviewModel(
  //   id: "2",
  //   userId: "101",
  //   rating: 3.0,
  //   comment: "It was okay, but service could be better.",
  //   upVote: 5,
  //   downVote: 3,
  //   visibility: false,
  //   createdAt: DateTime.parse("2023-03-29"),
  //   updatedAt: DateTime.parse("2023-03-30"),
  //   reviewSubject: const ReviewSubject(
  //     id: "2002",
  //     name: "Average Cafe",
  //     isItem: false,
  //     imageUrl: "https://example.com/images/cafe.jpg",
  //     itemImages: [],
  //     itemVideos: [],
  //   ),
  //   images: const [
  //     ReviewMedia(id: "3002", url: "https://example.com/images/cafe.jpg")
  //   ],
  //   videos: const [
  //     ReviewMedia(id: "4002", url: "https://example.com/videos/cafe.mp4")
  //   ],
  //   voted: -1,
  // ),
  // UserReviewModel(
  //   id: "3",
  //   userId: "102",
  //   rating: 5.0,
  //   comment: "Best pizza in town! Highly recommend!",
  //   upVote: 20,
  //   downVote: 1,
  //   visibility: true,
  //   createdAt: DateTime.parse("2023-04-05"),
  //   updatedAt: DateTime.parse("2023-04-06"),
  //   reviewSubject: const ReviewSubject(
  //     id: "2003",
  //     name: "Pizza Place",
  //     isItem: true,
  //     imageUrl: "https://example.com/images/pizza.jpg",
  //     itemImages: [],
  //     itemVideos: [],
  //   ),
  //   images: const [
  //     ReviewMedia(id: "3003", url: "https://example.com/images/pizza.jpg")
  //   ],
  //   videos: const [],
  //   voted: 0,
  // ),
];
