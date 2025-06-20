import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../data/service/api_service.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/story_detail/views/story_detail_view.dart';
import '../modules/story_detail/controllers/story_detail_controller.dart';
import '../modules/add_story/views/add_story_view.dart';
import '../modules/add_story/controllers/add_story_controller.dart';
import '../widgets/google_maps_location_picker.dart';
import '../widgets/fullscreen_map_view.dart';
import '../data/models/location_coordinate.dart';
part 'app_routes.dart';

class AppRouter {
  static final _apiService = Get.find<ApiService>();
  static final GoRouter router = GoRouter(
    initialLocation: Routes.SPLASH,
    redirect: (context, state) {
      final isLoggedIn = _apiService.isLoggedIn();
      final isAuthRoute = state.matchedLocation == Routes.LOGIN || state.matchedLocation == Routes.REGISTER;
      final isSplash = state.matchedLocation == Routes.SPLASH;
      if (isSplash) {
        return null;
      }
      if (!isLoggedIn && !isAuthRoute) {
        return Routes.LOGIN;
      }
      if (isLoggedIn && isAuthRoute) {
        return Routes.HOME;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.SPLASH,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: Routes.LOGIN,
        builder: (context, state) {
          Get.lazyPut(() => AuthController());
          return const LoginView();
        },
      ),
      GoRoute(
        path: Routes.REGISTER,
        builder: (context, state) {
          Get.lazyPut(() => AuthController());
          return const RegisterView();
        },
      ),
      GoRoute(
        path: Routes.HOME,
        builder: (context, state) {
          Get.lazyPut(() => HomeController());
          return const HomeView();
        },
      ),
      GoRoute(
        path: Routes.STORY_DETAIL,
        builder: (context, state) {
          final storyId = state.uri.queryParameters['id']!;
          Get.lazyPut(() => StoryDetailController());
          return StoryDetailView(storyId: storyId);
        },
      ),
      GoRoute(
        path: Routes.ADD_STORY,
        builder: (context, state) {
          Get.lazyPut(() => AddStoryController());
          return const AddStoryView();
        },
      ),
      GoRoute(
        path: Routes.LOCATION_PICKER,
        builder: (context, state) {
          final lat = double.tryParse(state.uri.queryParameters['lat'] ?? '');
          final lng = double.tryParse(state.uri.queryParameters['lng'] ?? '');
          LocationCoordinate? initialLocation;
          if (lat != null && lng != null) {
            initialLocation = LocationCoordinate(lat, lng);
          }
          return GoogleMapsLocationPicker(
            onLocationSelected: (location) {
              context.pop(location);
            },
            initialLocation: initialLocation,
          );
        },
      ),
      GoRoute(
        path: Routes.MAP_FULLSCREEN,
        builder: (context, state) {
          final lat = double.parse(state.uri.queryParameters['lat']!);
          final lng = double.parse(state.uri.queryParameters['lng']!);
          final title = state.uri.queryParameters['title'];
          final description = state.uri.queryParameters['description'];
          final address = state.uri.queryParameters['address'];

          return FullScreenMapView(
            location: LocationCoordinate(lat, lng),
            title: title,
            description: description,
            address: address,
          );
        },
      ),
    ],
  );
}
