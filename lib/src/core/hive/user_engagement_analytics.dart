import 'package:hive/hive.dart';

part 'user_engagement_analytics.g.dart';

@HiveType(typeId: 1)
class UserEngagementAnalytics {
  @HiveField(0)
  int homepage;

  @HiveField(1)
  int discoverRestaurant;

  @HiveField(2)
  int discoverItem;

  @HiveField(3)
  int quickReview;

  @HiveField(4)
  int searchPage;

  @HiveField(5)
  int leaderBoard;

  @HiveField(6)
  int itemReview;

  @HiveField(7)
  int restaurantReviews;

  @HiveField(8)
  int itemShare;

  @HiveField(9)
  int restaurantShare;

  @HiveField(10)
  int itemSearchPage;

  @HiveField(11)
  int restaurantSearchPage;

  UserEngagementAnalytics({
    this.homepage = 0,
    this.discoverRestaurant = 0,
    this.discoverItem = 0,
    this.quickReview = 0,
    this.searchPage = 0,
    this.leaderBoard = 0,
    this.itemReview = 0,
    this.restaurantReviews = 0,
    this.itemShare = 0,
    this.restaurantShare = 0,
    this.itemSearchPage = 0,
    this.restaurantSearchPage = 0,
  });

  UserEngagementAnalytics copyWith({
    int? homepage,
    int? discoverRestaurant,
    int? discoverItem,
    int? quickReview,
    int? searchPage,
    int? leaderBoard,
    int? itemReview,
    int? restaurantReviews,
    int? itemShare,
    int? restaurantShare,
    int? itemSearchPage,
    int? restaurantSearchPage,
  }) {
    return UserEngagementAnalytics(
      homepage: homepage != 0 ? this.homepage + 1 : this.homepage,
      discoverRestaurant: discoverRestaurant != 0
          ? this.discoverRestaurant + 1
          : this.discoverRestaurant,
      discoverItem:
          discoverItem != 0 ? this.discoverItem + 1 : this.discoverItem,
      quickReview: quickReview != 0 ? this.quickReview + 1 : this.quickReview,
      searchPage: searchPage != 0 ? this.searchPage + 1 : this.searchPage,
      leaderBoard: leaderBoard != 0 ? this.leaderBoard + 1 : this.leaderBoard,
      itemReview: itemReview != 0 ? this.itemReview + 1 : this.itemReview,
      restaurantReviews: restaurantReviews != 0
          ? this.restaurantReviews + 1
          : this.restaurantReviews,
      itemShare: itemShare != 0 ? this.itemShare + 1 : this.itemShare,
      restaurantShare: restaurantShare != 0
          ? this.restaurantShare + 1
          : this.restaurantShare,
      itemSearchPage:
          itemSearchPage != 0 ? this.itemSearchPage + 1 : this.itemSearchPage,
      restaurantSearchPage: restaurantSearchPage != 0
          ? this.restaurantSearchPage + 1
          : this.restaurantSearchPage,
    );
  }

  @override
  String toString() {
    return 'UserEngagementAnalytics{'
        'homepage: $homepage, '
        'discoverRestaurant: $discoverRestaurant, '
        'discoverItem: $discoverItem, '
        'quickReview: $quickReview, '
        'searchPage: $searchPage, '
        'leaderBoard: $leaderBoard, '
        'itemReview: $itemReview, '
        'restaurantReviews: $restaurantReviews, '
        'itemShare: $itemShare, '
        'restaurantShare: $restaurantShare'
        'itemSearchPage: $itemSearchPage'
        'restaurantSearchPage: $restaurantSearchPage'
        '}';
  }
}
