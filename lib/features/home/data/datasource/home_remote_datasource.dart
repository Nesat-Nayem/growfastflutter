abstract class HomeRemoteDataSource {
  /// Calls the home API endpoint
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<String>> getBannerImages();
}