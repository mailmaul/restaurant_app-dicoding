import 'package:flutter/material.dart';
import 'package:restaurant_app/detail_page.dart';
import 'package:restaurant_app/local_restaurant.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late List<Restaurant> restaurantList;
  late List<Restaurant> filteredList;

  @override
  void initState() {
    super.initState();
    restaurantList = [];
    filteredList = [];
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    String jsonStr =
        await rootBundle.loadString('assets/local_restaurant.json');
    parseRestaurant(jsonStr);
  }

  void parseRestaurant(String jsonStr) {
    final welcome = welcomeFromJson(jsonStr);
    restaurantList = welcome.restaurants;
    filteredList = List.from(restaurantList);
  }

  void filterList(String query) {
    setState(() {
      filteredList = restaurantList.where((restaurant) {
        final nameLower = restaurant.name.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    });
  }

  void navigateToDetailPage(Restaurant restaurant) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation1, animation2) => FadeTransition(
          opacity: animation1,
          child: DetailPage(restaurant: restaurant),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 15,
            horizontal: MediaQuery.of(context).size.width / 15),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Restaurant",
                    style: TextStyle(fontSize: 35),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Recommendation restaurant for you!",
                    style: TextStyle(fontSize: 19),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextField(
                  onChanged: (value) {
                    filterList(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search restaurant',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    Restaurant restaurant = filteredList[index];
                    return GestureDetector(
                      onTap: () {
                        navigateToDetailPage(restaurant);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    restaurant.pictureId,
                                    fit: BoxFit.cover,
                                    width: 150,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        restaurant.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(restaurant.city),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                  restaurant.rating.toString()),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
