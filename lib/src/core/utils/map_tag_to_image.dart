class ImageMapping {
  static Map<String, String> foodCategoryToImageMap = {
    'burger': 'https://i.ibb.co/mtPSng8/1-burger.png',
    'coffee': 'https://i.ibb.co/VHJpyjB/18-Coffee.png',
    'shawarma': 'https://i.ibb.co/y5GnhRX/Shawarma.png',
    'pizza': 'https://i.ibb.co/j6b3Dh2/pizza-slice.png',
    'egg': 'https://i.ibb.co/rHHjWW2/egg-and-bacon.png',
    'noodle': 'https://i.ibb.co/F7XMqtF/16-ramen.png',
    'sushi': 'https://i.ibb.co/q9n8yzR/sushi-caviar.png',
    'juice': 'https://i.ibb.co/Pj8F6Qv/16-Juice.png',
    'pasta': 'https://i.ibb.co/4NZyqzR/21-Fork-and-Knife.png',
    'sandwich': 'https://i.ibb.co/ryBHm9R/22-Sandwich.png',
    'drink': 'https://i.ibb.co/yYd9cdy/12-minum.png',
    'dessert': 'https://i.ibb.co/2WLXwkc/ice-cream.png',
    'chicken': 'https://i.ibb.co/TKDjFy9/7-ayam.png',
    'chips': 'https://i.ibb.co/Rv5Pt53/5-kentang.png',
    'fries': 'https://i.ibb.co/vY9Lx2q/french-fries.png',
    'tea': 'https://i.ibb.co/F8BnGT8/Tea.png',
    'smoothie': 'https://i.ibb.co/FJ3tcvP/20-Smoothie.png',
    'extra': 'https://i.ibb.co/RDpSFtX/mustard.png',
    'beer': 'https://i.ibb.co/pWqtgTt/19-Beer.png',
  };

  static Map<String, String> cachedKeywords = {};

  static String getItemFromRestaurantImage(
      Map<String, dynamic> restaurantImages) {
    // Check if the list is not empty
    if (restaurantImages['restaurant_images']?.isNotEmpty ?? false) {
      // Find the image with "is_leading" set to true, if available
      final leadingImage = restaurantImages['restaurant_images'].firstWhere(
        (image) => image['is_leading'] == true,
        orElse: () => null,
      );

      // If a leading image is found, return its URL
      if (leadingImage != null && leadingImage['url'] is String) {
        return leadingImage['url'];
      }

      // If no leading image is found, return the URL of the first image
      final firstImage = restaurantImages["restaurant_images"][0];
      if (firstImage != null && firstImage['url'] is String) {
        return firstImage['url'];
      }
    }
    // If the list is empty or no valid image URLs are found, return a default image URL
    return 'https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg';
  }

  // static function takes restaurant image and display it
  static String getRestaurantImage(Map<String, dynamic> restaurant) {
    // Check if the "categories" key exists in the JSON
    if (restaurant.containsKey('categories') &&
        restaurant['categories'] is Map &&
        restaurant['categories'].containsKey('menu') &&
        restaurant['categories']['menu'] is Map &&
        restaurant['categories']['menu'].containsKey('restaurant') &&
        restaurant['categories']['menu']['restaurant'] is Map &&
        restaurant['categories']['menu']['restaurant']
            .containsKey('restaurant_images') &&
        restaurant['categories']['menu']['restaurant']['restaurant_images']
            is List &&
        restaurant['categories']['menu']['restaurant']['restaurant_images']
            .isNotEmpty) {
      // Find the image with "is_leading" set to true, if available
      final leadingImage = restaurant['categories']['menu']['restaurant']
              ['restaurant_images']
          .firstWhere((image) => image['is_leading'] == true,
              orElse: () => null);

      // If a leading image is found, return its URL
      if (leadingImage != null && leadingImage['url'] is String) {
        return leadingImage['url'];
      }

      // If no leading image is found, return the URL of the first image
      return restaurant['categories']['menu']['restaurant']['restaurant_images']
          [0]['url'];
    } else {
      // If any key is missing or the list is empty, return a default image URL
      return 'https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg';
    }
  }

  static String getImageForFoodCategory(String foodName) {
    foodName = foodName.toLowerCase();

    // Check if we have cached the keyword
    if (cachedKeywords.containsKey(foodName)) {
      return foodCategoryToImageMap[cachedKeywords[foodName]]!;
    }

    // If not, search for a matching category
    for (final category in foodCategoryToImageMap.keys) {
      if (foodName.contains(category)) {
        // Cache the keyword for future use
        cachedKeywords[foodName] = category;
        return foodCategoryToImageMap[category]!;
      }
    }

    // If no matching category is found, return the default image
    return 'https://i.ibb.co/4NZyqzR/21-Fork-and-Knife.png';
  }
}
