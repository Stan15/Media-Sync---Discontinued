bool validateUrl({String url, String restrict}) {
  bool valid;
  if (restrict == null) {
    valid =  url.trim().isNotEmpty && url!=null;
  }else {
    if (restrict=='playlist') {
      bool isPlaylist = true;
      valid = url.trim().isNotEmpty && url!=null && isPlaylist;
    }else if (restrict=='video') {
      bool isVideo = true;
      valid = url.trim().isNotEmpty && url!=null && isVideo;
    }
  }
  return valid;
}