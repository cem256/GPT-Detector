import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfoClient {
  Future<bool> get isConnected;
}

@Injectable(as: NetworkInfoClient)
class NetworkInfoClientImpl implements NetworkInfoClient {
  NetworkInfoClientImpl({required InternetConnectionChecker connectionChecker})
      : _connectionChecker = connectionChecker;

  final InternetConnectionChecker _connectionChecker;

  @override
  Future<bool> get isConnected => _connectionChecker.hasConnection;
}
