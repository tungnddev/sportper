import 'package:sportper/data/remote/services/storage_service.dart';
import 'package:sportper/domain/repositories/storate_repository.dart';

class StorageRepositoryImp extends StorageRepository {

  StorageRepositoryImp._privateConstructor();

  static final StorageRepository instance = StorageRepositoryImp._privateConstructor();

  StorageService service = StorageService.instance;

  @override
  Future<String> uploadAvatar(String localPath) {
    return service.uploadAvatar(localPath);
  }

  @override
  Future<String> uploadImagePost(String localPath) {
    return service.uploadImagePost(localPath);
  }

}