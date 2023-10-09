abstract class StorageRepository {
  Future<String> uploadAvatar(String localPath);
  Future<String> uploadImagePost(String localPath);
}