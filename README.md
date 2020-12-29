# Media-Sync---Discontinued

The project was not brought to completion due to both a limitation of Firebase functions (which i faultily chose to implement the required server functions), and the possibly illegal nature of an audio/video downloader software.

This discontinued software is not complete in its implementation, but was made, using flutter, as a mobile application which not only downloads media as either video or audio files from streaming sites such as YouTube and Vimeo, but also syncs YouTube playlists to your local device storage as either audio or video files.

The firebase function code, written in typescript, is also left above. It is written almost to completion, but is non-functional due to the aforementioned limitation.

# User authentication
User login through Firebase Authentication, and storing of user setting preferences with Cloud Firestore, and server functions with firebase functions(storage access limitation preventing the use of youtube-dl). Watch the following video.

![Firebase authentication demo](https://user-images.githubusercontent.com/47716543/103320066-0a695f80-4a02-11eb-8a04-f9ebb5103e79.gif)

# Syncing playlists
Playlist media are synced onto the user's local device, as video, audio, or both, in the location of their choosing.
![Syncing playlists](https://user-images.githubusercontent.com/47716543/103320150-4dc3ce00-4a02-11eb-8737-6d264eb8550d.gif)
  |  [![Sync settings](https://user-images.githubusercontent.com/47716543/103262895-3ccc7b80-4974-11eb-9a06-ea727b938a58.png)](https://user-images.githubusercontent.com/47716543/103263027-ae0c2e80-4974-11eb-8a2a-3f461dc8ed62.mp4 "Adding YouTube playlists to be synced")

# Individual/One-time media download
Users can download individual media, or individual playlists, without having it constantly synced to their device.
[![Individual download](https://user-images.githubusercontent.com/47716543/103263540-29221480-4976-11eb-8b9c-4d69532bba6f.png)](https://user-images.githubusercontent.com/47716543/103263545-2c1d0500-4976-11eb-9e4a-e6e629e25bda.mp4 "Download individual media/playlist without syncing")

# Sync/Download location and media format selection
Users can choose to sync media as either audio files, video files, or both and can specify the desired locations for these syncs or one-time downloads.

[![File location](https://user-images.githubusercontent.com/47716543/103263727-ac436a80-4976-11eb-8db4-0f115b3075f0.png)](https://user-images.githubusercontent.com/47716543/103263643-769e8180-4976-11eb-93ee-15fb3c1bcec7.mp4 "File location and media format selection")






