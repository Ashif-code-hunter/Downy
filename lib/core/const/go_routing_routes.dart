


import 'package:downy/features/home/presentation/views/home_screen.dart';
import 'package:downy/features/home/presentation/views/listing_screen.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/views/player_screen.dart';


enum AppRoute{
  homeScreen,
  listingScreen,
  viewScreen
}
final goRoute =GoRouter(
    initialLocation: '/home',

    routes: [
      GoRoute(
        path: "/home",
        name: AppRoute.homeScreen.name,
        builder: (context, state) {
          return const HomeScreen();
        },
        routes: [
          GoRoute(
              path: "listingScreen",
              name: AppRoute.listingScreen.name,
              builder: (context, state) {
                return const ListingScreen();
              },
              routes:[
                GoRoute(
                    path: "viewScreen",
                    name: AppRoute.viewScreen.name,
                    builder: (context, state) {
                      return   ViewScreenPlayer();
                    },
                ),
              ]
          ),
        ]
      ),
    ]


);