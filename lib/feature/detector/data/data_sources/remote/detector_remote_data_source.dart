import 'package:gpt_detector/app/errors/exceptions.dart';
import 'package:gpt_detector/core/clients/network/network_client.dart';
import 'package:gpt_detector/feature/detector/data/model/detector/detector_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class DetectorRemoteDataSource {
  DetectorRemoteDataSource({
    required NetworkClient networkClient,
  }) : _networkClient = networkClient;
  final NetworkClient _networkClient;

  Future<DetectorModel> detect(String userInput) async {
    try {
      final response = await _networkClient.get<Map<String, dynamic>>('/?$userInput');
      final model = response.data;
      if (model == null) {
        throw NetworkException();
      } else {
        return DetectorModel.fromJson(model);
      }
    } catch (_) {
      throw NetworkException();
    }
  }
}
