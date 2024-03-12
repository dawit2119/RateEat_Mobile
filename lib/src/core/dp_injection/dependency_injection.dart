// ignore added because awesome dio interceptor is a dev dependency
// ignore: depend_on_referenced_packages
import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rateeat_mobile/src/core/hive/hive_init.dart';
import 'package:rateeat_mobile/src/core/service/firebase_analytics.dart';
import 'package:rateeat_mobile/src/core/service/firebase_crachlytics.dart';
import 'package:rateeat_mobile/src/core/service/firebase_performance.dart';
import 'package:rateeat_mobile/src/core/service/local_analytics.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/data/datasources/remote_favorite_datasource.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/data/repositories/favorite_repository_impl.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/repositories/favorite_repository.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/use_cases/use_cases.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/presentation/bloc/favorite_bloc.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/data/data_sources/candid_rest_data_sources.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/data/repository/candidate_repo_impl.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/domain/repository/candidate_repo.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/domain/usecase/candidate_usecase.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/presentation/bloc/candidate_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/data_sources/nearby_data_provider.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/repositories/categories_repository_impl.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/repositories/nearby_repo_impl.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/repositories/categories_repository.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/repositories/nearby_repository.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/use_cases/nearby_usecase.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/category/category_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/near_by_rest_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/pages/filter_modal_sheet.dart';
import 'package:rateeat_mobile/src/features/homepage/data/datasource/local_homepage_dataprovider.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_bloc.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/data_sources/local_item_detail_datasource.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/repositories/item__detail_repository_impl.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/datasource/remote_leaderboard_datasource.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/datasource/remote_user_rank_datasource.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/repostitories/leader_board_repository_impl.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/repostitories/user_rank_repository_impl.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/repositories/leader_board_repository.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/repositories/user_rank_repository.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/all_time_leaderboard_usecase.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/monthly_leader_board_usecase.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/user_rank_use_case.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/weekly_leader_board_usecase.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/leadear_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/monthly_leader_board/monthly_leader_board_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/weekly_leader_board/weekly_leader_board_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/pages/leaderboard.dart';
import 'package:rateeat_mobile/src/features/live_search/data/repositories/live_search_repo_impl.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/repository/live_search_repo.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/use_case/get_popular_search_items.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/use_case/use_cases.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/live_search/search_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/local_history/local_search_history_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/popular_searches/popular_search_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/pages/live_search_page.dart';
import 'package:rateeat_mobile/src/features/location_search/domain/usecases/google_search_places.dart';
import 'package:rateeat_mobile/src/features/location_search/domain/usecases/search_location_usecase.dart';
import 'package:rateeat_mobile/src/features/map_section/data/data_sources/location_based_restaurants_dp.dart';
import 'package:rateeat_mobile/src/features/map_section/data/repositories/location_based_restaurants_repo_impl.dart';
import 'package:rateeat_mobile/src/features/map_section/domain/repositories/location_based_restaurant_repo.dart';
import 'package:rateeat_mobile/src/features/map_section/domain/use_cases/get_location_based_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/bloc/location_based_restaurants/location_based_restaurants_bloc.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/widgets/google_map_content.dart';
import 'package:rateeat_mobile/src/features/notification/data/repositories/notification.dart';
import 'package:rateeat_mobile/src/features/notification/domain/repositories/notification.dart';
import 'package:rateeat_mobile/src/features/notification/domain/use_cases/mark_notification_read_status.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/datasources/nearby_places_datasource.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/repositories/nearby_places_repository_impl.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/repositories/nearby_places_repository.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/usecases/add_review_to_draft_usecase.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/usecases/get_nearby_restaurant_items_usecase.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/usecases/get_nearby_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/add_review_to_draft/add_review_to_draft_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/nearby_items/nearby_item_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/nearby_restaurant/nearby_restaurant_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/nearby_item_result.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/nearby_restaurant_result.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';
import 'package:rateeat_mobile/src/features/order/presentation/bloc/create_order/create_order_bloc.dart';
import 'package:rateeat_mobile/src/features/order/presentation/bloc/total_price/total_price_bloc.dart';
import 'package:rateeat_mobile/src/features/order/presentation/widgets/widgets.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/datasources/remote_restaurant_detail_data_provider.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/repositories/restaurant_detail_repository_impl.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/repositories/restaurant__detail_repository.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/use_cases/get_popular_items_usecase.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/use_cases/get_restaurant_popular_reviews_usecase.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/use_cases/restaurant_detail_usecase.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_detail/restaurant_detail_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_items/popular_restaurant_items_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_popular_reviews/restaurant_popular_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/data_sources/restaurant_menu_data_provider.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/repositories/restaurant_menu_repository_impl.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/repositories/restaurant_menu_repository.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/use_cases/get_restaurant_menu_category_items_use_case.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/bloc/restaurant_menu/restaurant_menu_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/add_candidate_item.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_item_price_review.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_item_review_datasource.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_price_review_datasource.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_restaurant_review_datasource.dart';
import 'package:rateeat_mobile/src/features/review/data/repositories/item_review_repository_impl.dart';
import 'package:rateeat_mobile/src/features/review/data/repositories/price_item_review_repository_impl.dart';
import 'package:rateeat_mobile/src/features/review/data/repositories/price_review_repository_impl.dart';
import 'package:rateeat_mobile/src/features/review/data/repositories/restaurant_review_repository_impl.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/item_review_repository.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/price_item_update_repository.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/price_update_repository.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/restaurant_review_repository.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/delete_draft_review_usecase.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/price_item_update_usecase.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/price_update_usecase.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/send_draft_to_review_usecase.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/add_item_review/add_item_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/add_restaurant_review/add_restaurant_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_draft_review/delete_draft_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_item_review/delete_item_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_restaurant_review/delete_restaurant_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/draft_to_review/draft_to_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/edit_item_review/edit_item_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/edit_restaurant_review/edit_restaurant_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/get_item_reviews/get_item_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/get_restaurant_reviews/get_restaurant_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/item_review_card_flag/item_review_flag_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/item_price_update/item_price_update_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/restaurant_price_update/restaurant_price_update_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/item_reviews_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/restaurant_reviews_page.dart';
import 'package:rateeat_mobile/src/features/search_result/data/datasources/datasources.dart';
import 'package:rateeat_mobile/src/features/search_result/data/repositories/item_result_repository_impl.dart';
import 'package:rateeat_mobile/src/features/search_result/data/repositories/restaurant_result_repository_impl.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/repositories/item_search_result.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/repositories/restaurant_search_result.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/items/get_closest_items_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/items/get_highest_rated_items_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/items/get_most_popular_items_use_case.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/items/get_price_sorted_items_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/restaurants/get_closest_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/restaurants/get_highest_rated_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/restaurants/get_most_popular_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/restaurants/get_price_sorted_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/pages/search_result_page.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/search_result.dart';
import 'package:rateeat_mobile/src/features/settings/data/datasources/remote_feedback_datasource.dart';
import 'package:rateeat_mobile/src/features/settings/data/repostiories/feedbackrepoimpl.dart';
import 'package:rateeat_mobile/src/features/settings/domain/repostiory/feedbackrepo.dart';
import 'package:rateeat_mobile/src/features/settings/domain/usecase/feedbackusecase.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/give_feedback/give_feedback_bloc.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/user_preference/user_preference.dart';
import 'package:rateeat_mobile/src/features/shared_media_review/data/datasources/get_food_dp.dart';
import 'package:rateeat_mobile/src/features/shared_media_review/domain/repositories/get_food_repository.dart';
import 'package:rateeat_mobile/src/features/shared_media_review/domain/usecases/search_food_usecase.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data_provider/other_profile_provider.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/repository/others_profile_repository_impl.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/repository/others_profile_repository.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/current_user/check_username_availability_use_case.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/current_user/get_current_user_user_case.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/current_user/get_saved_reviews_use_case.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/follow/follow_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/others_profile/get_others_profile_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/others_profile/others_favorites_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/others_profile/others_user_review_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/saved_reviews/saved_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/username_availability/username_availability_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/verify_edit_profile/verify_edit_profile_bloc.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/data/data_sources/review_vote_dp.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/data/repository/vote_on_review_impl.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/repository/vote_on_review_repo.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_item_review.dart';

import '../../features/discover_item/data/data_sources/catagories_data_provider.dart';
import '../../features/discover_item/data/data_sources/filter_page_data_provider.dart';
import '../../features/discover_item/data/data_sources/local_nearby_restaurant_data_provider.dart';
import '../../features/discover_item/data/data_sources/search_page_data_provider.dart';
import '../../features/discover_item/data/repositories/filter_page_repostiory_impl.dart';
import '../../features/discover_item/data/repositories/search_page_repoistory_impl.dart';
import '../../features/discover_item/domain/repositories/filter_page_repository.dart';
import '../../features/discover_item/domain/repositories/search_page_repostiory.dart';
import '../../features/discover_item/domain/use_cases/categories_usecase.dart';
import '../../features/discover_item/domain/use_cases/filer_page_usecase.dart';
import '../../features/discover_item/domain/use_cases/search_page_use_case.dart';
import '../../features/discover_item/presentation/bloc/filter/filter_items_bloc.dart';
import '../../features/discover_item/presentation/bloc/search/search_restaurant.dart';
import '../../features/discover_item/presentation/bloc/search/selected_restaurant.dart';
import '../../features/discover_item/presentation/pages/item_result_page.dart';
import '../../features/discover_restaurant_result/data/datasources/discover_restaurant_dp.dart';
import '../../features/discover_restaurant_result/data/repositories/discover_repo_impl.dart';
import '../../features/discover_restaurant_result/domain/repositories/discover_restaurant_repo.dart';
import '../../features/discover_restaurant_result/domain/use_cases/discover_restaurant_use_case.dart';
import '../../features/discover_restaurant_result/presentation/bloc/restaurant_bloc/discover_result_bloc.dart';
import '../../features/features.dart';
import '../../features/item_category/data/dataprovider/local_item_category_data_provider.dart';
import '../../features/item_detail/item_detail.dart';
import '../../features/live_search/data/data_sources/live_search_data_provider.dart';
import '../../features/live_search/data/data_sources/local_search_history_data_source.dart';
import '../../features/location_search/domain/usecases/get_location_description_usecase.dart';
import '../../features/location_search/presentation/bloc/location_description/location_description_bloc.dart';
import '../../features/map_section/data/data_sources/map_markers_data_source.dart';
import '../../features/map_section/data/repositories/map_markers_repository_impl.dart';
import '../../features/map_section/domain/repositories/map_markers_repository.dart';
import '../../features/map_section/domain/use_cases/load_markers.dart';
import '../../features/map_section/presentation/bloc/map_markers/map_markers_bloc.dart';
import '../../features/notification/data/data_sources/notification.dart';
import '../../features/notification/domain/use_cases/get_un_read_notifications_count_use_case.dart';
import '../../features/notification/domain/use_cases/get_user_notifications.dart';
import '../../features/notification/presentation/bloc/fetch_notifications/notification_bloc.dart';
import '../../features/notification/presentation/bloc/notification_mark_as_read/notifications_mark_as_read_bloc.dart';
import '../../features/notification/presentation/bloc/un_read_notification_counter/un_read_notification_counter_bloc.dart';
import '../../features/notification/presentation/pages/pages.dart';
import '../../features/restaurant_detail/data/datasources/local_restaurant_detail_data_provider.dart';
import '../../features/restaurant_menu/domain/use_cases/add_candidate_item_use_case.dart';
import '../../features/restaurant_menu/domain/use_cases/get_restaurant_menu_categories.dart';
import '../../features/restaurant_menu/domain/use_cases/get_restaurant_menu_items_use_case.dart';
import '../../features/restaurant_menu/presentation/bloc/candidate_item/candidate_item_bloc.dart';
import '../../features/restaurant_menu/presentation/bloc/restaurant_category/restaurant_category_bloc.dart';
import '../../features/restaurant_menu/presentation/widgets/candidate_item.dart';
import '../../features/restaurant_menu/presentation/widgets/category_items.dart';
import '../../features/review/domain/use_cases/add_item_review_usecase.dart';
import '../../features/review/domain/use_cases/add_restaurant_review_usecase.dart';
import '../../features/review/domain/use_cases/delete_item_review_usecase.dart';
import '../../features/review/domain/use_cases/delete_restaurant_review_usecase.dart';
import '../../features/review/domain/use_cases/edit_item_review_usecase.dart';
import '../../features/review/domain/use_cases/edit_restaurant_review_usecase.dart';
import '../../features/review/domain/use_cases/flag_review.dart';
import '../../features/review/domain/use_cases/get_item_reviews_by_popularity_usecase.dart';
import '../../features/review/domain/use_cases/get_item_reviews_by_time_usecase.dart';
import '../../features/review/domain/use_cases/get_restaurant_reviews_by_popularity_usecase.dart';
import '../../features/review/domain/use_cases/get_restaurant_reviews_by_time_usecase.dart';
import '../../features/review/presentation/bloc/flag_review/flag_review_bloc.dart';
import '../../features/shared_media_review/data/datasources/add_food_review_dp.dart';
import '../../features/shared_media_review/data/datasources/add_restaurant_review_dp.dart';
import '../../features/shared_media_review/data/datasources/get_restaurant_dp.dart';
import '../../features/shared_media_review/data/repositories/add_food_review_repo.dart';
import '../../features/shared_media_review/data/repositories/add_restaurant_review_repo.dart';
import '../../features/shared_media_review/data/repositories/get_food_repo.dart';
import '../../features/shared_media_review/data/repositories/get_restaurant_repo.dart';
import '../../features/shared_media_review/domain/repositories/add_food_review_repository.dart';
import '../../features/shared_media_review/domain/repositories/add_restaurant_review_repository.dart';
import '../../features/shared_media_review/domain/repositories/get_restaurant_repository.dart';
import '../../features/shared_media_review/domain/usecases/add_food_review_usecase.dart';
import '../../features/shared_media_review/domain/usecases/add_restaurant_review_usecase.dart';
import '../../features/shared_media_review/domain/usecases/get_highest_rated_food_usecase.dart';
import '../../features/shared_media_review/domain/usecases/get_nearby_restaurant_usecase.dart';
import '../../features/shared_media_review/domain/usecases/search_restaurant_usecase.dart';
import '../../features/shared_media_review/presentation/bloc/food_review/food_review_bloc.dart';
import '../../features/shared_media_review/presentation/bloc/restaurant_review/restaurant_review_bloc.dart';
import '../../features/shared_media_review/presentation/bloc/search_food/search_food_bloc.dart';
import '../../features/shared_media_review/presentation/bloc/search_restaurant/search_restaurant_bloc.dart';
import '../../features/shared_media_review/presentation/bloc/share_media/share_media_bloc.dart';
import '../../features/user_profile/presentation/pages/custom_tab_bar.dart';
import '../../features/user_profile/user_profile.dart';
import '../../features/vote_on_review/domain/use_cases/down_vote_restaurant_review.dart';
import '../../features/vote_on_review/domain/use_cases/up_vote_restaurant_review.dart';
import '../../features/currency_exchange/data/datasources/datasources.dart';
import '../../features/currency_exchange/data/repositories/repositories.dart';
import '../../features/currency_exchange/domain/repositories/currency_repository.dart';
import '../../features/currency_exchange/domain/usecases/usecases.dart';
import '../../features/currency_exchange/presentation/bloc/bloc.dart';
import '../core.dart';
import '../currency/general_currency_bloc.dart';
import '../widgets/custom_persistent_bottom_navbar.dart';

final dpLocator = GetIt.instance;
Future<void> serviceLocatorInit() async {
  //Flag reviews
  dpLocator.registerLazySingleton<FlagReviewBloc>(
    () => FlagReviewBloc(
      flagReviewsUseCase: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<ItemReviewsCardBloc>(
    () => ItemReviewsCardBloc(),
  );

  dpLocator.registerFactory<FlagReviewUseCase>(
    () => FlagReviewUseCase(
      itemReviewRepository: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<CategoriesToggleBloc>(
    () => CategoriesToggleBloc(),
  );
  dpLocator.registerLazySingleton<SelectedRestaurantBloc>(
    () => SelectedRestaurantBloc(),
  );

  //* Bottom nav
  dpLocator.registerFactory<BottomNavIndexBloc>(
    () => BottomNavIndexBloc(
      1,
    ),
  );
  dpLocator.registerFactory<CandidateItemCubit>(
    () => CandidateItemCubit(),
  );
  dpLocator.registerLazySingleton(
    () => BottomNavigationCubit(),
  );
  //Candidate Item
  dpLocator.registerFactory<CandidateItemBloc>(
    () => CandidateItemBloc(
      addCandidateItemUseCase: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<AddCandidateItemUseCase>(
    () => AddCandidateItemUseCase(
      restaurantMenuRepository: dpLocator(),
    ),
  );

  //* Decide the selected discover screen
  dpLocator.registerFactory<DiscoverSelectedScreenCubit>(
    () => DiscoverSelectedScreenCubit(),
  );
  //* Feature - Restaurant Menu
  dpLocator.registerFactory<RestaurantMenuBloc>(
    () => RestaurantMenuBloc(
      itemsUseCase: dpLocator(),
      categoryItemsUseCase: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<GetRestaurantMenuItemsUseCase>(
    () => GetRestaurantMenuItemsUseCase(
      restaurantMenuRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<GetRestaurantMenuCategoryItemsUseCase>(
    () => GetRestaurantMenuCategoryItemsUseCase(
      restaurantMenuRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<RestaurantMenuRepository>(
    () => RestaurantMenuRepositoryImpl(
      restaurantDataProvider: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<RestaurantMenuDataProvider>(
    () => RestaurantMenuDataProviderImpl(
      dio: dpLocator(),
    ),
  );
  //live search
  dpLocator.registerFactory<SearchBloc>(
    () => SearchBloc(
      liveSearchRestaurantsUseCase: dpLocator(),
      liveSearchItemsUseCase: dpLocator(),
    ),
  );
  dpLocator
      .registerFactory<LocalSearchHistoryBloc>(() => LocalSearchHistoryBloc(
            addLocalSearchHistoryUseCase: dpLocator(),
            clearLocalHistoryUseCase: dpLocator(),
            deleteLocalHistoryUseCase: dpLocator(),
            getLocalHistoryUseCase: dpLocator(),
          ));
  dpLocator.registerLazySingleton<GetLocalHistoryUseCase>(
    () => GetLocalHistoryUseCase(
      liveSearchRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<AddLocalSearchHistoryUseCase>(
    () => AddLocalSearchHistoryUseCase(
      liveSearchRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<ClearLocalHistoryUseCase>(
    () => ClearLocalHistoryUseCase(
      liveSearchRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<DeleteLocalHistoryUseCase>(
    () => DeleteLocalHistoryUseCase(
      liveSearchRepository: dpLocator(),
    ),
  );
  //
  dpLocator.registerLazySingleton<LiveSearchRepository>(
    () => LiveSearchRepoImpl(
      liveSearchDataProvider: dpLocator(),
      localSearchHistoryDataSource: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<LiveSearchRestaurantsUseCase>(
    () => LiveSearchRestaurantsUseCase(liveSearchRepository: dpLocator()),
  );
  dpLocator.registerLazySingleton<LiveSearchItemsUseCase>(
    () => LiveSearchItemsUseCase(liveSearchRepository: dpLocator()),
  );
  dpLocator.registerLazySingleton<LiveSearchDataProvider>(
      () => LiveSearchDataProviderImpl(dio: dpLocator()));
  dpLocator.registerLazySingleton<LocalSearchHistoryDataSource>(
    () => LocalSearchHistoryDataSourceImpl(),
  );
  // filter items
  dpLocator.registerFactory<FilterItemsBloc>(
    () => FilterItemsBloc(
      filterItemsUseCase: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<FilterItemsUseCase>(
    () => FilterItemsUseCase(
      filterItemsRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<FilterItemsRepository>(
    () => FilterItemsRepoImpl(
      filterItemsDataProvider: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<FilterItemsDataProvider>(
    () => FilterItemsDataProvider(
      dio: dpLocator(),
    ),
  );

  // get category items
  dpLocator.registerFactory<CategoryBloc>(
    () => CategoryBloc(
      categoriesUsecase: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<CategoriesUsecase>(
    () => CategoriesUsecase(
      repository: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(
      getCategoriesDataProvider: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<CatagoriesDataProvider>(
    () => CatagoriesDataProvider(
      dio: dpLocator(),
    ),
  );

  //* restaurant search
  dpLocator.registerFactory<SearchRestaurantsBloc>(
    () => SearchRestaurantsBloc(
      searchPageUseCase: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<SearchPageUseCase>(
    () => SearchPageUseCase(
      searchPageRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<SearchPageRepository>(
    () => SearchPageRepositoryImpl(
      searchPageDataProvider: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<SearchPageDataProvider>(
    () => SearchPageDataProvider(
      dio: dpLocator(),
    ),
  );

  //restaurant search result
  dpLocator.registerFactory<RestaurantsFilterSearchResultsBloc>(
    () => RestaurantsFilterSearchResultsBloc(
      getMostPopularRestaurantsUseCase: dpLocator(),
      getHighestRatedRestaurantsUseCase: dpLocator(),
      getPriceSortedRestaurantsUseCase: dpLocator(),
      getClosestRestaurantsUseCase: dpLocator(),
    ),
  );
  //Items search result
  dpLocator.registerFactory<ItemsFilterSearchResultsBloc>(
    () => ItemsFilterSearchResultsBloc(
      getHighestRatedItemsUseCase: dpLocator(),
      getClosestItemsUseCase: dpLocator(),
      getMostPopularItemsUseCase: dpLocator(),
      getPriceSortedItemsUseCase: dpLocator(),
    ),
  );
  //restaurants
  dpLocator.registerLazySingleton(() => GetMostPopularRestaurantsUseCase(
      restaurantResultRepository: dpLocator()));

  dpLocator.registerLazySingleton(() => GetHighestRatedRestaurantsUseCase(
      restaurantResultRepository: dpLocator()));

  dpLocator.registerLazySingleton(() => GetPriceSortedRestaurantsUseCase(
      restaurantResultRepository: dpLocator()));

  dpLocator.registerLazySingleton(() =>
      GetClosestRestaurantsUseCase(restaurantResultRepository: dpLocator()));

  //items
  dpLocator.registerLazySingleton(
      () => GetHighestRatedItemsUseCase(itemResultRepository: dpLocator()));
  dpLocator.registerLazySingleton(
      () => GetMostPopularItemsUseCase(itemResultRepository: dpLocator()));
  dpLocator.registerLazySingleton(
      () => GetClosestItemsUseCase(itemResultRepository: dpLocator()));
  dpLocator.registerLazySingleton(
      () => GetPriceSortedItemsUseCase(itemResultRepository: dpLocator()));

  dpLocator.registerLazySingleton<RestaurantResultRepository>(
    () => RestaurantResultRepositoryImpl(
      remoteDataSource: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<ItemResultRepository>(
    () => ItemResultRepositoryImpl(
      remoteDataSource: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<SearchResultRemoteDataSource>(
    () => SearchResultRemoteDataSourceImpl(
      dio: dpLocator(),
    ),
  );

  //* Feature - Authentication
  // bloc
  dpLocator.registerFactory(
    () => AuthenticationBloc(
      signInWithGoogleUseCase: dpLocator(),
      signOutWithGoogleUseCase: dpLocator(),
      signInWithFacebookUseCase: dpLocator(),
      signOutWithFacebookUseCase: dpLocator(),
      signOutWithAppleUseCase: dpLocator(),
      signInWithAppleUseCase: dpLocator(),
      loginFacebookUseCase: dpLocator(),
      loginGoogleUseCase: dpLocator(),
      sendPhoneOtpUseCase: dpLocator(),
      sendEmailOtpUseCase: dpLocator(),
      sendEditPhoneOtpUseCase: dpLocator(),
      sendEditEmailOtpUseCase: dpLocator(),
      verifyOtpUseCase: dpLocator(),
      verifyEmailOtpUseCase: dpLocator(),
      resendOtpUseCase: dpLocator(),
      resendEmailOtpUseCase: dpLocator(),
      signUpUseCase: dpLocator(),
      logoutUseCase: dpLocator(),
      deleteAccountUseCase: dpLocator(),
      localSearchHistoryBloc: dpLocator(),
    ),
  );

  dpLocator.registerFactory<UserDataCubit>(() => UserDataCubit());
  // usecases
  dpLocator.registerLazySingleton(
      () => SignInWithGoogleUseCase(repository: dpLocator()));
  dpLocator.registerLazySingleton(
      () => SignOutWithGoogleUseCase(repository: dpLocator()));
  dpLocator.registerLazySingleton(
      () => SignInWithFacebookUseCase(repository: dpLocator()));
  dpLocator.registerLazySingleton(
      () => SignOutWithFacebookUseCase(repository: dpLocator()));

  dpLocator.registerLazySingleton(
      () => LoginFacebookUseCase(repository: dpLocator()));
  dpLocator
      .registerLazySingleton(() => LoginGoogleUseCase(repository: dpLocator()));
  dpLocator.registerLazySingleton(
      () => SendPhoneOtpUseCase(repository: dpLocator()));
  dpLocator.registerLazySingleton(
      () => SendEmailOtpUseCase(repository: dpLocator()));
  dpLocator.registerLazySingleton(
      () => SendEditPhoneOtpUseCase(repository: dpLocator()));
  dpLocator.registerLazySingleton(
      () => SendEditEmailOtpUseCase(repository: dpLocator()));
  dpLocator
      .registerLazySingleton(() => VerifyOtpUseCase(repository: dpLocator()));
  dpLocator.registerLazySingleton(
      () => VerifyEmailOtpUseCase(repository: dpLocator()));
  dpLocator.registerLazySingleton(
      () => ResendEmailOtpUseCase(repository: dpLocator()));
  dpLocator
      .registerLazySingleton(() => ResendOtpUseCase(repository: dpLocator()));
  dpLocator.registerLazySingleton(() => SignupUseCase(repository: dpLocator()));
  dpLocator.registerLazySingleton(() => LogoutUseCase(repository: dpLocator()));
  dpLocator.registerLazySingleton(
      () => DeleteAccountUseCase(repository: dpLocator()));
  dpLocator.registerLazySingleton(
      () => SignInWithAppleUsecase(repository: dpLocator()));
  dpLocator.registerLazySingleton(
    () => LogoutWithAppleUsecase(repository: dpLocator()),
  );
  // Repository
  dpLocator.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      remoteSource: dpLocator(),
      localSource: dpLocator(),
      observer: dpLocator(),
      log: dpLocator(),
    ),
  );
  // DataSource
  dpLocator.registerLazySingleton(
    () => HiveService(),
  );
  dpLocator.registerLazySingleton<RemoteAuthenticationSource>(
    () => RemoteAuthenticationSourceImpl(
      dio: dpLocator(),
      service: dpLocator(),
      localSource: dpLocator(),
    ),
  );
  //* ---------------------------------- Get user profile(Add each bloc) -----------------------------
  // User profile bloc
  dpLocator.registerFactory<GetUserProfileBloc>(
    () => GetUserProfileBloc(
      getCurrentUserUseCase: dpLocator(),
      localProfileDataProvider: dpLocator(),
    ),
  );

  // Follow user bloc
  dpLocator.registerFactory<FollowBloc>(
    () => FollowBloc(
      unfollowUseCase: dpLocator(),
      followUseCase: dpLocator(),
    ),
  );
  // User reviews bloc
  dpLocator.registerFactory<UserReviewBloc>(
    () => UserReviewBloc(
      getUserReviewsUseCase: dpLocator(),
    ),
  );
  // User reviews bloc
  dpLocator.registerFactory<UserFavoriteBloc>(
    () => UserFavoriteBloc(
      getUserFavoritesUseCase: dpLocator(),
    ),
  );

  // User recommendation bloc
  dpLocator.registerFactory<RecommendationBloc>(
    () => RecommendationBloc(
      getUserRecommendationUseCase: dpLocator(),
    ),
  );

  // Other User recommendation bloc
  dpLocator.registerFactory<OtherRecommendationBloc>(
    () => OtherRecommendationBloc(
      getOtherUserRecommendationUseCase: dpLocator(),
    ),
  );

  // add recommendation item and restaurant bloc
  dpLocator.registerFactory<AddRecommendationBloc>(
    () => AddRecommendationBloc(
      addItemRecommendationUseCase: dpLocator(),
      addRestaurantRecommendationUseCase: dpLocator(),
    ),
  );

  // get following list
  dpLocator.registerFactory<FollowingListBloc>(() => FollowingListBloc(
        getCurrentUserFollowingsUseCase: dpLocator(),
        getOtherUserFollowingsUseCase: dpLocator(),
        followUserUseCase: dpLocator(),
        unfollowUserUseCase: dpLocator(),
      ));

  // get follower list
  dpLocator.registerFactory<FollowerListBloc>(() => FollowerListBloc(
        getCurrentUserFollowersUseCase: dpLocator(),
        getOtherUserFollowersUseCase: dpLocator(),
      ));

  // Edit profile bloc
  dpLocator.registerFactory<EditProfileBloc>(
    () => EditProfileBloc(
      editProfileUseCase: dpLocator(),
    ),
  );
  dpLocator.registerFactory<VerifyEditProfileBloc>(
    () => VerifyEditProfileBloc(
      editProfileUseCase: dpLocator(),
    ),
  );
  dpLocator.registerFactory(
    () => UsernameAvailabilityBloc(
      checkUserNameAvailabilityUseCase: dpLocator(),
    ),
  );

  //update user preference bloc
  dpLocator.registerFactory<UserPreferenceBloc>(
    () => UserPreferenceBloc(
        updateUserPreferenceUseCase: dpLocator(),
        getUserPreferenceUseCase: dpLocator()),
  );

  // Saved  Reviews
  dpLocator.registerFactory<SavedReviewsBloc>(
    () => SavedReviewsBloc(
      getSavedReviewsUseCase: dpLocator(),
    ),
  );

  // qr menu bloc
  dpLocator.registerFactory<QRMenuBloc>(
    () => QRMenuBloc(
      getQrMenuUsecase: dpLocator(),
    ),
  );
  dpLocator.registerFactory<ItemsCountPerPriceBloc>(
    () => ItemsCountPerPriceBloc(
      getNumberOfItemsPerPriceRangeUsecase: dpLocator(),
    ),
  );

// create qr order bloc
  dpLocator.registerFactory<QROrderBloc>(
    () => QROrderBloc(
      createQROrderUsecase: dpLocator(),
    ),
  );
  // edit qr order bloc
  dpLocator.registerFactory<EditQROrderBloc>(
    () => EditQROrderBloc(
      getQROrderUsecase: dpLocator(),
      updateQROrderUsecase: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<QROrderSocketStatusBloc>(
      () => QROrderSocketStatusBloc());
  dpLocator.registerLazySingleton<QROrderStatusBloc>(
    () => QROrderStatusBloc(
      orderStatusUseCase: dpLocator<GetQROrderUsecase>(),
    ),
  );
  dpLocator.registerLazySingleton<GetQROrderBloc>(
    () => GetQROrderBloc(
      qrOrderUsecase: dpLocator<GetQROrderUsecase>(),
    ),
  );

  // User Reviews Page count
  dpLocator.registerFactory(
    () => UserReviewsPageCubit(),
  );
  // User Saved Reviews Page count
  dpLocator.registerFactory(
    () => SavedReviewsPageCubit(),
  );
  //Edit profile use case
  dpLocator.registerLazySingleton<EditProfileUseCase>(
    () => EditProfileUseCase(
      profileRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<CheckUserNameAvailabilityUseCase>(
    () => CheckUserNameAvailabilityUseCase(
      profileRepository: dpLocator(),
    ),
  );
  // Get User use-case
  dpLocator.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(
      profileRepository: dpLocator(),
    ),
  );
  // Get User use-case
  dpLocator.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(
      profileRepository: dpLocator(),
    ),
  );

  // get user recommendations use case
  dpLocator.registerLazySingleton<GetUserRecommendationUseCase>(
    () => GetUserRecommendationUseCase(
      repository: dpLocator(),
    ),
  );

  // get other user recommendations use case
  dpLocator.registerLazySingleton<GetOtherUserRecommendationUseCase>(
    () => GetOtherUserRecommendationUseCase(
      repository: dpLocator(),
    ),
  );

  //add new item recommendation use case
  dpLocator.registerLazySingleton<AddItemRecommendationUseCase>(
    () => AddItemRecommendationUseCase(
      addRecommendationRepository: dpLocator(),
    ),
  );

  //add new restaurant recommendation use case
  dpLocator.registerLazySingleton<AddRestaurantRecommendationUseCase>(
    () => AddRestaurantRecommendationUseCase(
      addRecommendationRepository: dpLocator(),
    ),
  );

  //get current user followers list
  dpLocator.registerLazySingleton<GetCurrentUserFollowersUseCase>(
    () => GetCurrentUserFollowersUseCase(
      profileRepository: dpLocator(),
    ),
  );

  //get current user following list
  dpLocator.registerLazySingleton<GetCurrentUserFollowingsUseCase>(
    () => GetCurrentUserFollowingsUseCase(
      profileRepository: dpLocator(),
    ),
  );

  // get previous preference use case
  dpLocator.registerLazySingleton<GetUserPreferenceUseCase>(
    () => GetUserPreferenceUseCase(
      profileRepository: dpLocator(),
    ),
  );
  // update user preferences use case
  dpLocator.registerLazySingleton<UpdateUserPreferenceUseCase>(
    () => UpdateUserPreferenceUseCase(
      profileRepository: dpLocator(),
    ),
  );

  //get other user following list
  dpLocator.registerLazySingleton<GetOtherUserFollowingsUseCase>(
    () => GetOtherUserFollowingsUseCase(
      othersProfileRepository: dpLocator(),
    ),
  );

  // get other user followers list
  dpLocator.registerLazySingleton<GetOtherUserFollowersUseCase>(
    () => GetOtherUserFollowersUseCase(
      othersProfileRepository: dpLocator(),
    ),
  );

  // Follow user use case
  dpLocator.registerLazySingleton<FollowUserUseCase>(
    () => FollowUserUseCase(
      followUnfollowRepository: dpLocator(),
    ),
  );

  // Unfollow user use case
  dpLocator.registerLazySingleton<UnFollowUserUseCase>(
    () => UnFollowUserUseCase(
      followUnfollowRepository: dpLocator(),
    ),
  );

  //Get User Reviews use-case
  dpLocator.registerLazySingleton<GetUserReviewsUseCase>(
    () => GetUserReviewsUseCase(
      profileRepository: dpLocator(),
    ),
  );
  //Get User Favorites use-case
  dpLocator.registerLazySingleton<GetUserFavoritesUseCase>(
    () => GetUserFavoritesUseCase(
      profileRepository: dpLocator(),
    ),
  );
  // Get Saved Reviews Use-case
  dpLocator.registerLazySingleton<GetSavedReviewsUseCase>(
    () => GetSavedReviewsUseCase(
      profileRepository: dpLocator(),
    ),
  );

  // Get qr menu use case
  dpLocator.registerLazySingleton<GetQRMenuUsecase>(
    () => GetQRMenuUsecase(
      qrMenuRepository: dpLocator(),
    ),
  );

  //create qr order usecase
  dpLocator.registerLazySingleton<CreateQROrderUsecase>(
    () => CreateQROrderUsecase(
      qrMenuRepository: dpLocator(),
    ),
  );

  //get qr order usecase
  dpLocator.registerLazySingleton<GetQROrderUsecase>(
    () => GetQROrderUsecase(
      qrMenuRepository: dpLocator(),
    ),
  );

  //update qr order usecase
  dpLocator.registerLazySingleton<UpdateQROrderUsecase>(
    () => UpdateQROrderUsecase(
      qrMenuRepository: dpLocator(),
    ),
  );

  //get number of items per price range
  dpLocator.registerLazySingleton<GetNumberOfItemsPerPriceRangeUsecase>(
    () => GetNumberOfItemsPerPriceRangeUsecase(
      qrMenuRepository: dpLocator(),
    ),
  );
  //Current user's repository
  dpLocator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepoImpl(
      profileDataProvider: dpLocator(),
    ),
  );
  //Local profile data provider
  dpLocator.registerLazySingleton<LocalProfileDataProvider>(
    () => LocalProfileDataProviderImpl(),
  );
  //Follow and unfollow user repository
  dpLocator.registerLazySingleton<FollowUnfollowRepository>(
    () => FollowUnfollowRepositoryImpl(
      othersProfileDataProvider: dpLocator(),
    ),
  );
  //Current user's data provider
  dpLocator.registerLazySingleton<ProfileDataProvider>(
    () => ProfileDataProvider(
      dio: dpLocator(),
    ),
  );

  //add recommendations repository
  dpLocator.registerLazySingleton<AddRecommendationRepository>(
    () => AddRecommendationRepositoryImpl(
      addRecommendationDataProvider: dpLocator(),
    ),
  );

  // get qr menu repository
  dpLocator.registerLazySingleton<QRMenuRepository>(
    () => QRMenuRepositoryImpl(
      qrMenuRemoteDataSource: dpLocator(),
    ),
  );

  //* Others Review
  // User profile bloc
  dpLocator.registerFactory<GetOthersProfileBloc>(
    () => GetOthersProfileBloc(
      getOtherUserUseCase: dpLocator(),
    ),
  );
  // User reviews bloc
  dpLocator.registerFactory<OthersReviewBloc>(
    () => OthersReviewBloc(
      getOtherUserReviewsUseCase: dpLocator(),
    ),
  );
// User reviews bloc
  dpLocator.registerFactory<OthersFavoriteBloc>(
    () => OthersFavoriteBloc(
      getOtherUserFavoritesUseCase: dpLocator(),
    ),
  );
  // Get Other User use-case
  dpLocator.registerLazySingleton<GetOtherUserUseCase>(
    () => GetOtherUserUseCase(
      othersProfileRepository: dpLocator(),
    ),
  );
  //Get Other User Reviews use-case
  dpLocator.registerLazySingleton<GetOtherUserReviewsUseCase>(
    () => GetOtherUserReviewsUseCase(
      othersProfileRepository: dpLocator(),
    ),
  );
  //Get Other User Favorites use-case
  dpLocator.registerLazySingleton<GetOtherUserFavoritesUseCase>(
    () => GetOtherUserFavoritesUseCase(
      othersProfileRepository: dpLocator(),
    ),
  );
  //Other user's repository
  dpLocator.registerLazySingleton<OthersProfileRepository>(
    () => OthersProfileRepoImpl(
      profileDataProvider: dpLocator(),
    ),
  );
  //Other user's data provider
  dpLocator.registerLazySingleton<OthersProfileDataProvider>(
    () => OthersProfileDataProvider(
      dio: dpLocator(),
    ),
  );

  // add recommendations data provider
  dpLocator.registerLazySingleton<AddRecommendationDataProvider>(
    () => AddRecommendationDataProvider(
      dio: dpLocator(),
    ),
  );

  //search
  dpLocator.registerLazySingleton<FoodCategoryDataProvider>(
      () => FoodCategoryDataProvider());
  dpLocator.registerLazySingleton<FoodCategoryRepository>(
      () => FoodCategoryRepositoryImpl(searchDataProvider: dpLocator()));
  dpLocator.registerLazySingleton<SearchFoodCategoryUseCase>(
    () => SearchFoodCategoryUseCase(repository: dpLocator()),
  );
  dpLocator.registerLazySingleton<GeTagSuggestionUseCase>(
    () => GeTagSuggestionUseCase(repository: dpLocator()),
  );
  dpLocator.registerFactory<SearchFoodCategoryBloc>(
    () => SearchFoodCategoryBloc(
      geTagSuggestionUseCase: dpLocator(),
      searchFoodCategoryUseCase: dpLocator(),
    ),
  );
  dpLocator.registerFactory<SearchFoodCategoryQueryCubit>(
    () => SearchFoodCategoryQueryCubit(),
  );
  //filter
  dpLocator
      .registerLazySingleton<FilterDataProvider>(() => FilterDataProvider());
  dpLocator.registerLazySingleton<FilterRepository>(
    () => FilterRepositoryImpl(
      filterDataProvider: dpLocator(),
    ),
  );

  //qr menu data provider
  dpLocator.registerLazySingleton<QRMenuRemoteDatasource>(
    () => QRMenuRemoteDatasource(
      dio: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<FilterRestaurantUseCase>(
    () => FilterRestaurantUseCase(
      repository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<GetRatingUseCase>(
    () => GetRatingUseCase(repository: dpLocator()),
  );
  dpLocator.registerLazySingleton<GetPriceRangeUseCase>(
    () => GetPriceRangeUseCase(repository: dpLocator()),
  );
  dpLocator.registerLazySingleton<GetPriceUseCase>(
    () => GetPriceUseCase(repository: dpLocator()),
  );
  dpLocator.registerFactory<UserLocationBloc>(
    () => UserLocationBloc(
      getLocationUseCase: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<GetLocationUseCase>(
    () => GetLocationUseCase(
      discoverRepo: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<DiscoverRepo>(
    () => DiscoverRepoImpl(
      locationDataProvider: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<LocationDataProvider>(
    () => LocationDataProvider(),
  );

  dpLocator.registerLazySingleton<MapZoomBloc>(
    () => MapZoomBloc(),
  );
  dpLocator.registerLazySingleton(
    () => NetworkBloc(),
  );
  dpLocator.registerLazySingleton(
    () => AllRestaurantsBloc(
      mapFunctionRepo: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<MapFunctionRepo>(
    () => MapFunctionRepoImpl(
      allRestaurantsDataProvider: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton(
    () => AllRestaurantsDataProvider(
      dio: dpLocator(),
    ),
  );

  //* Feature - Location Search
  // bloc
  dpLocator.registerFactory(
    () => AutoCompleteBloc(
        searchLocationUseCase: dpLocator(), googleLocationUseCase: dpLocator()),
  );
  // usecase
  dpLocator.registerLazySingleton(
      () => SearchLocationUseCase(repository: dpLocator()));
  dpLocator.registerLazySingleton(
      () => GoogleLocationUseCase(repository: dpLocator()));
  // Repository
  dpLocator.registerLazySingleton<SearchLocationRepository>(
    () => SearchLocationRepositoryImpl(
      remoteSource: dpLocator(),
    ),
  );
  // dataSource
  dpLocator.registerLazySingleton<SearchLocationRemoteSource>(
    () => SearchLocationRemoteSourceImpl(
      dio: dpLocator(),
    ),
  );

  // ? Get user location description
  dpLocator.registerLazySingleton(
    () => LocationDescriptionBloc(
      getLocationDescriptionUseCase: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton(
    () => GetLocationDescriptionUseCase(
      searchLocationRepository: dpLocator(),
    ),
  );

  //* Feature - HomePage

  dpLocator.registerFactory(
    () => PopularBloc(
      getPopularUseCase: dpLocator(),
    ),
  );
  dpLocator.registerFactory(
    () => RecommendedBloc(
      getRecommendedUseCase: dpLocator(),
    ),
  );
  dpLocator.registerFactory(
    () => PromotionBloc(
      getPromotionUseCase: dpLocator(),
    ),
  );
  // usecase
  dpLocator.registerLazySingleton(
    () => GetPopularUseCase(
      repository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton(
    () => GetPromotionUseCase(
      repository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton(
    () => GetRestaurantRecommendationsUseCase(
      repository: dpLocator(),
    ),
  );
  // repository
  dpLocator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteSource: dpLocator(),
    ),
  );
  // dataSource
  dpLocator.registerLazySingleton<RemoteHomeSource>(
    () => RemoteHomeSourceImpl(
      dio: dpLocator(),
    ),
  );

  //* Feature - Discover Flow Filter
  // bloc
  dpLocator.registerLazySingleton(
    () => DiscoveryStepsBloc(),
  );

  //* Feature - Favorite
  // bloc
  dpLocator.registerFactory(
    () => FavoriteBloc(
      addToFavorite: dpLocator(),
      removeFromFavorite: dpLocator(),
      addRestaurantToFavorite: dpLocator(),
      removeRestaurantFromFavorite: dpLocator(),
    ),
  );
  // usecases
  dpLocator.registerLazySingleton(
    () => AddItemToFavoriteUseCase(
      repository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton(
    () => RemoveItemFromFavoriteUseCase(
      repository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton(
    () => AddRestaurantToFavoriteUseCase(
      repository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton(
    () => RemoveRestaurantFromFavoriteUseCase(
      repository: dpLocator(),
    ),
  );
  // repository
  dpLocator.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(
      remoteSource: dpLocator(),
    ),
  );
  // dataSource
  dpLocator.registerLazySingleton<RemoteFavoriteSource>(
    () => RemoteFavoriteSourceImpl(
      dio: dpLocator(),
      localSource: dpLocator(),
    ),
  );
// * Feature - Vote on review
  // dpLocator.registerFactory(
  //   () => VoteOnReviewBloc(
  //     voteOnReviewUseCase: dpLocator(),
  //   ),
  // );

  dpLocator.registerLazySingleton(
    () => UpVoteItemReviewUseCase(
      voteOnReviewRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton(
    () => DownVoteItemReviewUseCase(
      voteOnReviewRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton(
    () => UpVoteRestaurantReviewUseCase(
      voteOnReviewRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton(
    () => DownVoteRestaurantReviewUseCase(
      voteOnReviewRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<VoteOnReviewRepository>(
    () => VoteOnReviewRepoImpl(
      voteOnReviewDataProvider: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton(
    () => VoteOnReviewDataProvider(
      dio: dpLocator(),
    ),
  );

  dpLocator.registerFactory(
    () => FetchDiscoverRestaurantResultBloc(
      discoverRestaurantUseCase: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton(
    () => DiscoverRestaurantUseCase(
      fetchRestaurantRepo: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<FetchRestaurantRepo>(
    () => FetchRestaurantRepoImpl(
      discoverRestaurantResultDataProvider: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton(
    () => DiscoverRestaurantDataProvider(
      dio: dpLocator(),
    ),
  );

  //* Restaurant Count

  dpLocator.registerFactory(
    () => LocationBasedRestaurantsBloc(
      searchRestaurantsCountUseCase: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton(
    () => LocationBasedRestaurantUseCase(
      repository: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<LocationBasedRestaurantsRepository>(
    () => LocationBasedRestaurantsRepositoryImpl(
      remoteSource: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<LocationRestaurantsRemoteSource>(
    () => LocationBasedRestaurantRemoteSourceImpl(
      dio: dpLocator(),
    ),
  );

  //* Search Query
  dpLocator.registerLazySingleton(
    () => SearchQueryCubit(),
  );

  dpLocator.registerLazySingleton(
    () => RatingBloc(),
  );

  dpLocator.registerLazySingleton(
    () => PriceMultiChipsBlock(),
  );

  //* Restaurant and Item page count
  dpLocator.registerFactory(
    () => SearchPageCubit(),
  );

  dpLocator.registerFactory(
    () => MapStateCubit(),
  );

  dpLocator.registerLazySingleton(
    () => DisplayRestaurantCountAndWalkingDistance(),
  );

  //* Discovery Item page count
  dpLocator.registerFactory(
    () => DiscoveryItemPageCubit(),
  );
  //Multi chips bloc
  dpLocator.registerFactory<MultiChipsCubit>(
    () => MultiChipsCubit(),
  );
  dpLocator.registerFactory<LiveSearchCubit>(
    () => LiveSearchCubit(),
  );
  //popular searches bloc
  dpLocator.registerFactory<PopularSearchesBloc>(
    () => PopularSearchesBloc(
      getPopularSearchesUseCase: dpLocator(),
    ),
  );
  //get popular searches usecase
  dpLocator.registerLazySingleton<GetPopularSearchesUseCase>(
    () => GetPopularSearchesUseCase(
      repository: dpLocator(),
    ),
  );

  //* --------------- Feature Notification --------------------
  dpLocator.registerFactory<NotificationsBloc>(
    () => NotificationsBloc(
      getUserNotificationsUseCase: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<GetUserNotificationsUseCase>(
    () => GetUserNotificationsUseCase(
      notificationRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<MarkNotificationReadStatusUseCase>(
    () => MarkNotificationReadStatusUseCase(
      notificationRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(
      notificationRemoteDataSource: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(
      dio: dpLocator(),
    ),
  );
  //*---------------- Mark Notification Bloc  --------------------
  dpLocator.registerFactory<NotificationsMarkAsReadBloc>(
    () => NotificationsMarkAsReadBloc(
      markNotificationReadStatusUseCase: dpLocator(),
    ),
  );

  //* --------------- Get NotificationsCounter --------------------
  dpLocator.registerFactory<UnreadNotificationsCounterBloc>(
    () => UnreadNotificationsCounterBloc(
        getUnReadNotificationsCountUseCase: dpLocator()),
  );
  dpLocator.registerLazySingleton<GetUnreadNotificationsCountUseCase>(
    () => GetUnreadNotificationsCountUseCase(
      notificationRepository: dpLocator(),
    ),
  );
  //notifications page cubit
  dpLocator.registerFactory<NotificationsPageCubit>(
    () => NotificationsPageCubit(),
  );
  //* --------------- Feature Restaurant Detail --------------------
  //* Blocs
  dpLocator.registerFactory<RestaurantDetailBloc>(
    () => RestaurantDetailBloc(
      restaurantUseCase: dpLocator(),
    ),
  );
  dpLocator.registerFactory<RestaurantPopularReviewsBloc>(
    () => RestaurantPopularReviewsBloc(
      getPopularRestaurantReviews: dpLocator(),
    ),
  );
  dpLocator.registerFactory<RestaurantPopularItemsBloc>(
    () => RestaurantPopularItemsBloc(
      getPopularItemsUseCase: dpLocator(),
    ),
  );
  //* Use cases
  dpLocator.registerLazySingleton<RestaurantDetailUseCase>(
    () => RestaurantDetailUseCase(
      restaurantRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<GetPopularItemsUseCase>(
    () => GetPopularItemsUseCase(
      repository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<GetPopularRestaurantReviewsUseCase>(
    () => GetPopularRestaurantReviewsUseCase(
      repository: dpLocator(),
    ),
  );
  //* Repository
  dpLocator.registerLazySingleton<RestaurantDetailRepository>(
    () => RestaurantRepositoryImpl(
      restaurantDataProvider: dpLocator(),
    ),
  );

  //* Data provider
  dpLocator.registerLazySingleton<RestaurantDetailDataSource>(
    () => RestaurantDetailDataSourceImpl(
      dio: dpLocator(),
    ),
  );

  //* --------------- Feature Item Detail --------------------
  //* Blocs
  dpLocator.registerFactory<ItemDetailBloc>(
    () => ItemDetailBloc(
      itemUseCase: dpLocator(),
    ),
  );
  dpLocator.registerFactory<DetailRecommendationBloc>(
    () => DetailRecommendationBloc(
      getItemRecommendationsUseCase: dpLocator(),
    ),
  );
  dpLocator.registerFactory<PopularItemReviewsBloc>(
    () => PopularItemReviewsBloc(
      getPopularItemReviewsUseCase: dpLocator(),
    ),
  );
//* Use cases
  dpLocator.registerLazySingleton<GetItemUseCase>(
    () => GetItemUseCase(
      itemRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<GetItemRecommendationsUseCase>(
    () => GetItemRecommendationsUseCase(
      recommendationRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<GetPopularItemReviewsUseCase>(
    () => GetPopularItemReviewsUseCase(
      reviewRepository: dpLocator(),
    ),
  );

  //* Repository
  dpLocator.registerLazySingleton<ItemRepository>(
      () => ItemRepositoryImpl(itemDataProvider: dpLocator()));
  //* Data Provider
  dpLocator.registerLazySingleton<ItemDataProvider>(
      () => ItemDataProviderImpl(dio: dpLocator()));
  dpLocator.registerLazySingleton<LocalItemDetailDataSource>(
      () => LocalItemDetailDataSource());

  //* --------------- Feature Item Review --------------------
  //* Add Item Review Bloc
  dpLocator.registerFactory<AddItemReviewBloc>(
    () => AddItemReviewBloc(
      addItemReviewUseCase: dpLocator(),
    ),
  );
  //* Edit Item Review Bloc
  dpLocator.registerFactory<EditItemReviewBloc>(
    () => EditItemReviewBloc(
      editItemReviewUseCase: dpLocator(),
    ),
  );
  //* Delete Item Review Bloc
  dpLocator.registerFactory<DeleteItemReviewBloc>(
    () => DeleteItemReviewBloc(
      deleteItemReviewUseCase: dpLocator(),
    ),
  );
  //* Get Item Reviews Bloc
  dpLocator.registerFactory<GetItemReviewsBloc>(
    () => GetItemReviewsBloc(
      getItemReviewsByPopularityUseCase: dpLocator(),
      getItemReviewsByTimeUseCase: dpLocator(),
    ),
  );
  //* Restaurant Reviews Page Controller Cubit
  dpLocator.registerFactory<ItemReviewsPageControllerCubit>(
    () => ItemReviewsPageControllerCubit(),
  );

  //* Add Item review UseCase
  dpLocator.registerLazySingleton<AddItemReviewUseCase>(
    () => AddItemReviewUseCase(
      repository: dpLocator(),
    ),
  );
  //* Edit Item Review UseCase
  dpLocator.registerLazySingleton<EditItemReviewUseCase>(
    () => EditItemReviewUseCase(
      repository: dpLocator(),
    ),
  );
  //* Delete Item Review UseCase
  dpLocator.registerLazySingleton<DeleteItemReviewUseCase>(
    () => DeleteItemReviewUseCase(
      repository: dpLocator(),
    ),
  );
  //* Get Item Reviews UseCase By Popularity
  dpLocator.registerLazySingleton<GetItemReviewsByPopularityUseCase>(
    () => GetItemReviewsByPopularityUseCase(
      repository: dpLocator(),
    ),
  );
  //* Get Item Reviews UseCase By Time
  dpLocator.registerLazySingleton<GetItemReviewsByTimeUseCase>(
    () => GetItemReviewsByTimeUseCase(
      repository: dpLocator(),
    ),
  );

  //* Item Review Repository
  dpLocator.registerLazySingleton<ItemReviewRepository>(
    () => ItemReviewRepositoryImpl(
      itemReviewSource: dpLocator(),
    ),
  );
  //* Item Review Data Provider
  dpLocator.registerLazySingleton<ItemReviewDataSource>(
    () => ItemReviewDataSourceImpl(
      dio: dpLocator(),
    ),
  );

  //* --------------- Feature Restaurant Review --------------------
  //  //* Add Restaurant Review Bloc
  dpLocator.registerFactory<AddRestaurantReviewBloc>(
    () => AddRestaurantReviewBloc(
      addRestaurantReviewUseCase: dpLocator(),
    ),
  );
  //*  Edit Restaurant Review Bloc
  dpLocator.registerFactory<EditRestaurantReviewBloc>(
    () => EditRestaurantReviewBloc(
      editRestaurantReviewUseCase: dpLocator(),
    ),
  );
  //*  Delete Restaurant Review Bloc
  dpLocator.registerFactory<DeleteRestaurantReviewBloc>(
    () => DeleteRestaurantReviewBloc(
      deleteRestaurantReviewUseCase: dpLocator(),
    ),
  );
  //*  Get Restaurant Reviews Bloc
  dpLocator.registerFactory<GetRestaurantReviewsBloc>(
    () => GetRestaurantReviewsBloc(
      getPopularRestaurantReviewsUseCase: dpLocator(),
      getRecentRestaurantReviewsUseCase: dpLocator(),
    ),
  );
  //* Restaurant Reviews Page Controller Cubit
  dpLocator.registerFactory<RestaurantReviewsPageControllerCubit>(
    () => RestaurantReviewsPageControllerCubit(),
  );

  //* Add Restaurant Review UseCase
  dpLocator.registerLazySingleton<AddRestaurantReviewUseCase>(
    () => AddRestaurantReviewUseCase(
      repository: dpLocator(),
    ),
  );

  //* Edit Restaurant Review UseCase
  dpLocator.registerLazySingleton<EditRestaurantReviewUseCase>(
    () => EditRestaurantReviewUseCase(
      repository: dpLocator(),
    ),
  );
  //* Delete Restaurant Review UseCase
  dpLocator.registerLazySingleton<DeleteRestaurantReviewUseCase>(
    () => DeleteRestaurantReviewUseCase(
      repository: dpLocator(),
    ),
  );
  //* Get Restaurant Reviews UseCase By Popularity
  dpLocator.registerLazySingleton<GetRestaurantReviewsByPopularityUseCase>(
    () => GetRestaurantReviewsByPopularityUseCase(
      repository: dpLocator(),
    ),
  );
  //* Get Restaurant Reviews By Time UseCase
  dpLocator.registerLazySingleton<GetRestaurantReviewsByTimeUseCase>(
    () => GetRestaurantReviewsByTimeUseCase(
      repository: dpLocator(),
    ),
  );
  //* Restaurant Review Repository
  dpLocator.registerLazySingleton<RestaurantReviewRepository>(
    () => RestaurantReviewRepositoryImpl(
      restaurantReviewSource: dpLocator(),
    ),
  );
  //* Restaurant Review Data Provider
  dpLocator.registerLazySingleton<RestaurantReviewDataSource>(
    () => RestaurantReviewDataSourceImpl(dio: dpLocator()),
  );

  //* --------------- Price update feature  --------------------

  dpLocator.registerFactory<PriceItemUpdateBloc>(
      () => PriceItemUpdateBloc(priceItemUsecase: dpLocator()));
  dpLocator.registerFactory<PriceUpdateBloc>(
      () => PriceUpdateBloc(priceReviewUsecase: dpLocator()));
  dpLocator.registerLazySingleton<PriceItemUsecase>(
      () => PriceItemUsecase(itemPriceReviewRepository: dpLocator()));
  dpLocator.registerLazySingleton<PriceReviewUsecase>(
      () => PriceReviewUsecase(priceReviewRepository: dpLocator()));
  dpLocator.registerLazySingleton<ItemPriceReviewRepository>(
      () => PriceItemReviewRepoImpl(itemPriceReviewDataSource: dpLocator()));
  dpLocator.registerLazySingleton<PriceReviewRepository>(
      () => PriceReviewRepoImpl(priceReviewDataSource: dpLocator()));
  dpLocator.registerLazySingleton<ItemPriceReviewDataSource>(
      () => ItemPriceReviewDataSourceImpl(dio: dpLocator()));
  dpLocator.registerLazySingleton<PriceReviewDataSource>(
      () => PriceReviewDataSourceImpl(dio: dpLocator()));

  //* --------------- Firebase Analytics --------------------
  dpLocator.registerLazySingleton(
    () => AnalyticsObserver(),
  );
  dpLocator.registerLazySingleton(
    () => LocalAnalyticsObserver(),
  );
  dpLocator.registerLazySingleton(
    () => FirebaseCrashLogger(),
  );
  dpLocator.registerLazySingleton(
    () => FirebasePerformanceTracker(),
  );

//* --------------- Discover Item Filtering Blocs  --------------------
  dpLocator.registerLazySingleton(
    () => DiscoverMenuPriceSelectorCubit(),
  );
  dpLocator.registerLazySingleton(
    () => DiscoverMenuRatingSelectorCubit(),
  );
  dpLocator.registerLazySingleton(
    () => DiscoverMenuFastingSelectorCubit(),
  );

  dpLocator.registerLazySingleton(
    () => DiscoverMenuCategoryIdCubit(),
  );

  dpLocator.registerLazySingleton(
    () => DiscoverMenuSelectedCategoryCubit(),
  );
  //* ------------------------------------------ Feature Discover Restaurant Category Selector ----------------------------------
  dpLocator.registerLazySingleton(
    () => SelectFoodCategoryBloc(),
  );

  //* Map Markers
  dpLocator.registerFactory<MapMarkersBloc>(
    () => MapMarkersBloc(
      loadMarkersUseCase: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<LoadMapMarkersUseCase>(
    () => LoadMapMarkersUseCase(
      mapMarkersRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<MapMarkersRepository>(
    () => MapMarkersRepositoryImpl(
      mapMarkersDataSource: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<MapMarkersDataSource>(
    () => MapMarkersDataSourceImpl(),
  );

  // feedback

  dpLocator.registerFactory<FeedbackBloc>(
      () => FeedbackBloc(feedbackUseCase: dpLocator()));

  dpLocator.registerLazySingleton<FeedbackUseCase>(
      () => FeedbackUseCase(feedbackRepository: dpLocator()));

  dpLocator.registerLazySingleton<FeedbackRepository>(
      () => FeedbackRepoImpl(feedbackDataSource: dpLocator()));
  dpLocator.registerLazySingleton<FeedbackDataSource>(
      () => FeedbackDataSource(dio: dpLocator()));
//leaderboard
  dpLocator.registerFactory<LeaderBoardBloc>(
      () => LeaderBoardBloc(leaderBoardUseCase: dpLocator()));
  dpLocator.registerFactory<WeeklyLeaderBoardBloc>(
      () => WeeklyLeaderBoardBloc(getWeeklyLeaderBoardUseCase: dpLocator()));
  dpLocator.registerFactory<MonthlyLeaderBoardBloc>(
      () => MonthlyLeaderBoardBloc(getMonthlyLeaderBoardUseCase: dpLocator()));
  dpLocator.registerFactory<WeeklyLeaderBoardPageCubit>(
      () => WeeklyLeaderBoardPageCubit());
  dpLocator.registerFactory<TransportModeCubit>(
    () => TransportModeCubit(),
  );
  dpLocator.registerFactory<MonthlyLeaderBoardPageCubit>(
      () => MonthlyLeaderBoardPageCubit());
  dpLocator.registerFactory<AllTimeLeaderBoardPageCubit>(
      () => AllTimeLeaderBoardPageCubit());
  dpLocator.registerLazySingleton<LeaderBoardUseCase>(
      () => LeaderBoardUseCase(leaderRepository: dpLocator()));
  dpLocator.registerLazySingleton<GetWeeklyLeaderBoardUseCase>(
      () => GetWeeklyLeaderBoardUseCase(leaderRepository: dpLocator()));
  dpLocator.registerLazySingleton<GetMonthlyLeaderBoardUseCase>(
      () => GetMonthlyLeaderBoardUseCase(leaderRepository: dpLocator()));
  dpLocator.registerLazySingleton<LeaderRepository>(
      () => LeaderRepoImpl(leaderDataSource: dpLocator()));
  dpLocator.registerLazySingleton<LeaderDataSource>(
      () => LeaderDataSource(dio: dpLocator()));

  //* --------------- One-Click Add Review --------------------
  dpLocator.registerLazySingleton<SimpleReviewStepperBloc>(
    () => SimpleReviewStepperBloc(),
  );
  dpLocator.registerFactory<NearByRestaurantBloc>(
    () => NearByRestaurantBloc(
      getNearByRestaurantsUseCase: dpLocator(),
    ),
  );
  dpLocator.registerFactory<NearbyItemBloc>(
    () => NearbyItemBloc(
      getNearByItemsUseCase: dpLocator(),
    ),
  );
  dpLocator.registerFactory<AddReviewToDraftBloc>(
    () => AddReviewToDraftBloc(
      addReviewToDraftUseCase: dpLocator(),
    ),
  );
  dpLocator.registerFactory<DraftToReviewBloc>(
    () => DraftToReviewBloc(
      sendDraftToReviewUSeCase: dpLocator(),
    ),
  );
  dpLocator.registerFactory<DeleteDraftReviewBloc>(
    () => DeleteDraftReviewBloc(
      deleteDraftItemReviewUseCase: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<GetNearByRestaurantsUseCase>(
    () => GetNearByRestaurantsUseCase(
      repository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<GetNearByRestaurantItemsUseCase>(
    () => GetNearByRestaurantItemsUseCase(
      repository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<AddReviewToDraftUseCase>(
    () => AddReviewToDraftUseCase(
      repository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<SendDraftToReviewUSeCase>(
    () => SendDraftToReviewUSeCase(
      repository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<DeleteDraftItemReviewUseCase>(
    () => DeleteDraftItemReviewUseCase(
      repository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<NearByPlacesRepository>(
    () => NearByPlacesRepositoryImpl(
      nearbyPlacesDataSource: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<NearbyPlacesDataSource>(
    () => NearbyPlacesDataSourceImpl(
      dio: dpLocator(),
    ),
  );
  dpLocator.registerFactory<NearByRestaurantPageCubit>(
    () => NearByRestaurantPageCubit(),
  );
  dpLocator.registerFactory<NearByItemPageCubit>(
    () => NearByItemPageCubit(),
  );

  //user rank
  dpLocator
      .registerFactory<RankBloc>(() => RankBloc(userRankUseCase: dpLocator()));
  dpLocator.registerLazySingleton<UserRankUseCase>(
      () => UserRankUseCase(userRankRepository: dpLocator()));
  dpLocator.registerLazySingleton<UserRankRepository>(
      () => UserRankImpl(userRankDataSource: dpLocator()));
  dpLocator.registerLazySingleton<UserRankDataSource>(
      () => UserRankDataSource(dio: dpLocator()));
  //nearby restaurants

  dpLocator.registerFactory<HomePageNearbyRestaurantBloc>(
    () => HomePageNearbyRestaurantBloc(
      nearbyUseCase: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<NearbyUseCase>(
      () => NearbyUseCase(nearbyRestaurantsRepo: dpLocator()));
  dpLocator.registerLazySingleton<NearbyRestaurantsRepo>(
      () => NearByRestaurantsRepoImpl(nearByDataProvider: dpLocator()));
  dpLocator.registerLazySingleton<NearByDataProvider>(
      () => NearByDataProvider(dio: dpLocator()));

  dpLocator.registerFactory<CandidateBloc>(
      () => CandidateBloc(candidateUseCase: dpLocator()));
  dpLocator.registerLazySingleton<CandidateUseCase>(
      () => CandidateUseCase(candidateRepository: dpLocator()));
  dpLocator.registerLazySingleton<CandidateRepository>(
      () => CandidateRepoImpl(candidateDataSource: dpLocator()));
  dpLocator.registerLazySingleton<CandidateDataSource>(
    () => CandidateDataSource(
      dio: dpLocator(),
    ),
  );
  dpLocator.registerFactory<CategoriesPageCubit>(
    () => CategoriesPageCubit(),
  );

  //Restaurant menu categories
  dpLocator.registerFactory<RestaurantCategoryBloc>(
    () => RestaurantCategoryBloc(
      getRestaurantMenuCategories: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<GetRestaurantMenuCategories>(
    () => GetRestaurantMenuCategories(
      restaurantMenuRepository: dpLocator(),
    ),
  );

  dpLocator.registerFactory<TagBloc>(() => TagBloc());

  //* Feature - Order
  // bloc
  dpLocator.registerLazySingleton<OrdersCountBloc>(
    () => OrdersCountBloc(
      fetchOrdersCountUseCase: dpLocator(),
    ),
  );
  dpLocator.registerFactory<CartCubit>(
    () => CartCubit(),
  );

  dpLocator.registerFactory<TotalPriceBloc>(
    () => TotalPriceBloc(
      getOrderTotalPriceUseCase: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<OrderSocketStatusBloc>(
    () => OrderSocketStatusBloc(),
  );
  dpLocator.registerLazySingleton<OrderStatusBloc>(
    () => OrderStatusBloc(
      orderStatusUseCase: dpLocator(),
    ),
  );
  dpLocator.registerFactory<OrderCategoriesPageCubit>(
    () => OrderCategoriesPageCubit(),
  );
  dpLocator.registerFactory<CreateOrderBloc>(
    () => CreateOrderBloc(
      createOrderUseCase: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<PayOrderBloc>(
    () => PayOrderBloc(
      payOrderUseCase: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<CancelOrderBloc>(
    () => CancelOrderBloc(
      cancelOrderUseCase: dpLocator(),
    ),
  );

  // use_case
  dpLocator.registerLazySingleton<GetOrderTotalPriceUseCase>(
    () => GetOrderTotalPriceUseCase(
      orderRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<FetchOrdersCountUseCase>(
    () => FetchOrdersCountUseCase(
      ordersCountRepo: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<CreateOrderUseCase>(
    () => CreateOrderUseCase(
      orderRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<PayOrderUseCase>(
    () => PayOrderUseCase(
      orderRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<CancelOrderUseCase>(
    () => CancelOrderUseCase(
      orderRepository: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<GetOrderStatusUseCase>(
    () => GetOrderStatusUseCase(
      orderRepository: dpLocator(),
    ),
  );

  // repository
  dpLocator.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      orderDataSource: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<OrdersCountRepo>(
    () => OrdersCountRepoImpl(
      orderHistoryDataSource: dpLocator(),
    ),
  );

  // data_source
  dpLocator.registerLazySingleton<OrderDataSource>(
    () => OrderDataSourceImpl(
      dio: dpLocator(),
    ),
  );

  //* Feature - Order-History
  // bloc
  dpLocator.registerLazySingleton<OrderHistoryBloc>(
    () => OrderHistoryBloc(
      fetchOrderHistoryUseCase: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<OrderDetailBloc>(
    () => OrderDetailBloc(
      orderUseCase: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<OrderHistoryStatusBloc>(
    () => OrderHistoryStatusBloc(),
  );
  // use_case
  dpLocator.registerLazySingleton<FetchOrderHistoryUseCase>(
    () => FetchOrderHistoryUseCase(
      orderHistoryRepo: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<GetOrderDetailUseCase>(
    () => GetOrderDetailUseCase(
      orderHistoryRepo: dpLocator(),
    ),
  );
  // repository
  dpLocator.registerLazySingleton<OrderHistoryRepo>(
    () => OrderHistoryRepoImpl(
      orderHistoryDataSource: dpLocator(),
    ),
  );
  // data_source
  dpLocator.registerLazySingleton<OrderHistoryDataSource>(
    () => OrderHistoryDataSourceImpl(
      dio: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<SharedMediaBloc>(
    () => SharedMediaBloc(),
  );

  dpLocator.registerLazySingleton<SearchRestaurantBloc>(
    () => SearchRestaurantBloc(
      searchRestaurantUseCase: dpLocator(),
      getNearbyRestaurantUsecase: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<SearchRestaurantUseCase>(
    () => SearchRestaurantUseCase(
      getRestaurantRepository: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<GetNearbyRestaurantUsecase>(
    () => GetNearbyRestaurantUsecase(
      getRestaurantRepository: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<GetRestaurantRepository>(
    () => GetRestaurantRepoImpl(
      getRestaurantDataProvider: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<GetRestaurantDataProvider>(
    () => GetRestaurantDataProvider(
      dio: dpLocator(),
    ),
  );

  dpLocator.registerFactory<RestaurantReviewBloc>(
    () => RestaurantReviewBloc(
      addRestaurantReviewUsecase: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<AddRestaurantReviewUsecase>(
    () => AddRestaurantReviewUsecase(
      repository: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<AddRestaurantReviewRepository>(
    () => AddRestaurantReviewRepoImpl(
      addRestaurantReviewDataSource: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<AddRestaurantReviewDp>(
    () => AddRestaurantReviewDp(
      dio: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<SearchFoodBloc>(
    () => SearchFoodBloc(
      searchFoodUseCase: dpLocator(),
      getHighestRatedFoodUsecase: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<GetHighestRatedFoodUsecase>(
    () => GetHighestRatedFoodUsecase(
      getFoodRepository: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<SearchFoodUseCase>(
    () => SearchFoodUseCase(
      getFoodRepository: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<GetFoodRepository>(
    () => GetFoodRepoImpl(
      getFoodDataProvider: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<GetFoodDataProvider>(
    () => GetFoodDataProvider(
      dio: dpLocator(),
    ),
  );

  dpLocator.registerFactory<FoodReviewBloc>(
    () => FoodReviewBloc(
      addFoodReviewUsecase: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<AddFoodReviewUsecase>(
    () => AddFoodReviewUsecase(
      repository: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<AddFoodReviewRepository>(
    () => AddFoodReviewRepoImpl(
      addFoodReviewDataSource: dpLocator(),
    ),
  );

  dpLocator.registerLazySingleton<AddFoodReviewDp>(
    () => AddFoodReviewDp(
      dio: dpLocator(),
    ),
  );

  // Item suggestion image selector cubit
  dpLocator.registerFactory<SelecteImagesCubit>(
    () => SelecteImagesCubit(),
  );
  //* ----------- General Currency Preference ------------------
  dpLocator.registerFactory(() => GeneralCurrencyBloc());
  //* --------------- Feature Currency Exchange --------------------
  // bloc
  dpLocator.registerFactory<CurrencyBloc>(
    () => CurrencyBloc(
      convertCurrencyUseCase: dpLocator(),
    ),
  );
  // usecase
  dpLocator.registerLazySingleton<ConvertCurrencyUseCase>(
    () => ConvertCurrencyUseCase(
      repository: dpLocator(),
    ),
  );
  // repository
  dpLocator.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(
      remoteDataSource: dpLocator(),
      localDataSource: dpLocator(),
    ),
  );
  // datasources
  dpLocator.registerLazySingleton<RemoteCurrencyDataSource>(
    () => RemoteCurrencyDataSourceImpl(
      dio: dpLocator(),
    ),
  );
  dpLocator.registerLazySingleton<LocalCurrencyDataSource>(
    () => LocalCurrencyDataSourceImpl(
      hiveService: dpLocator(),
    ),
  );

  //! Extras
  //* --------------- Dio --------------------
  final dio = Dio();
  dio.interceptors.add(AwesomeDioInterceptor());
  dio.interceptors.add(CustomAuthInterceptor());
  dpLocator.registerSingleton<Dio>(dio);

  //* --------------- Local Data Providers --------------------

  dpLocator.registerLazySingleton<LocalItemCategoryDataProvider>(
    () => LocalItemCategoryDataProviderImpl(),
  );

  dpLocator.registerLazySingleton<AuthenticationLocalSource>(
    () => AuthenticationLocalSourceImpl(),
  );

  dpLocator.registerLazySingleton<LocalHomepageDataprovider>(
    () => LocalHomepageDataproviderImpl(),
  );

  dpLocator.registerLazySingleton<LocalNearbyRestaurantDataProvider>(
    () => LocalNearbyRestaurantDataProviderImpl(),
  );

  dpLocator.registerLazySingleton<RestaurantLocalDataSource>(
    () => RestaurantLocalDataSourceImpl(),
  );
}

ordersCountRepo({required Object ordersCountRepo}) {}

class AllReviewsRepositoryImpl {}
