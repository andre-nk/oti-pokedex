import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

//? Dio instance provider
final dioProvider = Provider(
  (ref) => Dio(
    BaseOptions(baseUrl: 'https://pokeapi.co/api/v2/'),
  ),
);


//? SharedPreferences instance provider
final sharedPrefProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});


//? Capitalize string extension method
extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
}
