import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/food_card.dart';

import '../../../live_search/data/models/search_result_model.dart';

class RestaurantDishesList extends StatelessWidget {
  const RestaurantDishesList({super.key, required this.items});

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
              items.length,
              (index) => FoodCard(
                imageUrl:
                    'https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGJ1cmdlcnxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80',
                rating: 4.5,
                foodName: items[index].name,
                restaurantName: items[index].name,
                price: items[index].price,
                noOfReviews: 120,
                ontap: () {},
              ),
            ),
            FoodCard(
              imageUrl:
                  'https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGJ1cmdlcnxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80',
              rating: 2,
              foodName: "Special Shawarma combo",
              restaurantName: "Afro Burger",
              price: 200,
              noOfReviews: 25,
              ontap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
