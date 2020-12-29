# Media-Sync---Discontinued

The project was not brought to completion due to both a limitation of Firebase functions (which i faultily chose to implement the required server functions), and the possibly illegal nature of an audio/video downloader software.

This discontinued software is not complete in its implementation, but was made, using flutter, as a mobile application which not only downloads media as either video or audio files from streaming sites such as YouTube and Vimeo, but also syncs YouTube playlists to your local device storage as either audio or video files.

The firebase function code, written in typescript, is also left above. It is written almost to completion, but is non-functional due to the aforementioned limitation.

# User authentication
User login through Firebase Authentication, and storing of user setting preferences with Cloud Firestore, and server functions with firebase functions(storage access limitation preventing the use of youtube-dl). Watch the following video.

![Firebase authentication demo](https://user-images.githubusercontent.com/47716543/103320066-0a695f80-4a02-11eb-8a04-f9ebb5103e79.gif)

# Syncing playlists
Playlist media are synced onto the user's local device, as video, audio, or both, in the location of their choosing.
![Syncing playlists](https://user-images.githubusercontent.com/47716543/103320427-4d780280-4a03-11eb-9424-e2b473cf115e.gif)
  |  ![Sync settings](https://user-images.githubusercontent.com/47716543/103320341-f5d99700-4a02-11eb-8cf2-0ecbfdf8dd4d.gif)

# Individual/One-time media download
Users can download individual media, or individual playlists, without having it constantly synced to their device.
![One-time download](https://user-images.githubusercontent.com/47716543/103320284-ba3ecd00-4a02-11eb-9f44-a3776d3cc233.gif)

# Sync/Download location and media format selection
Users can choose to sync media as either audio files, video files, or both and can specify the desired locations for these syncs or one-time downloads.

![File location](https://user-images.githubusercontent.com/47716543/103320469-7bf5dd80-4a03-11eb-9be3-85e3182a745f.gif)







