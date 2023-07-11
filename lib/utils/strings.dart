String truncateFilename(String filename, int maxLength) {
  String extension = filename.split('.').last; // get the file extension
  String nameWithoutExtension =
      filename.substring(0, filename.length - extension.length - 1);
  if (nameWithoutExtension.length > maxLength) {
    nameWithoutExtension = "${nameWithoutExtension.substring(0, maxLength)}...";
  }

  return "$nameWithoutExtension.$extension";
}
