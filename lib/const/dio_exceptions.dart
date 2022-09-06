import 'package:dio/dio.dart';


//? Custom Network (Dio) Exceptions
class DioException implements Exception {
  DioException({required this.message});

  DioException.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "Cancelled loading!";
        break;
      case DioErrorType.connectTimeout:
        message = "Connection timeout! Check your network";
        break;
      case DioErrorType.receiveTimeout:
        message = "Failed to receive data! Check your network";
        break;
      case DioErrorType.response:
        message = _handleError(dioError.response!.statusCode!);
        break;
      case DioErrorType.sendTimeout:
        message = "errorSendTimeout";
        break;
      default:
        message = "errorInternetConnection";
        break;
    }
  }

  String message = "";

  String _handleError(int statusCode) {
    switch (statusCode) {
      case 400:
        return "Bad request!";
      case 404:
        return "No pokemon's found!";
      case 500:
        return "PokeAPI server is down! Try again";
      default:
        return "Something went wrong!";
    }
  }

  @override
  String toString() => message;
}