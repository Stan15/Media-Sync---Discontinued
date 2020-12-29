# Media-Sync---Discontinued
This discontinued software is not complete in its implementation, but was made, using flutter, as a mobile application which not only downloads media as either video or audio files from streaming sites such as YouTube and Vimeo, but also syncs YouTube playlists to your local device storage as either audio or video files.

The project was not brought to completion due to both a limitation of Firebase functions (which i faultily chose to implement the required server functions), and the possibly illegal nature of an audio/video downloader software.

User login through Firebase Authentication, and storing of user setting preferences with Cloud Firestore, and server functions with firebase functions(storage access limitation preventing the use of youtube-dl). Watch the following video.

[![Firebase authentication demo](https://user-images.githubusercontent.com/47716543/103262795-f6771c80-4973-11eb-927d-f2e37197dee7.png)](https://user-images.githubusercontent.com/47716543/103261279-f1639e80-496e-11eb-9b94-72184d07ee83.mp4 "Authhentication and user preference storage")

Syncing playlists
                           |  
:-------------------------:|:-------------------------:
[![Syncing playlists](https://user-images.githubusercontent.com/47716543/103262653-97190c80-4973-11eb-8b24-173126dec07e.png)](https://user-images.githubusercontent.com/47716543/103262014-97b0a380-4971-11eb-90c1-b5b730aaa0c4.mp4 "syncing YouTube playlists to local device")  |  [![Sync settings](https://user-images.githubusercontent.com/47716543/103262895-3ccc7b80-4974-11eb-9a06-ea727b938a58.png)](https://user-images.githubusercontent.com/47716543/103263027-ae0c2e80-4974-11eb-8a2a-3f461dc8ed62.mp4 "Adding YouTube playlists to be synced")









