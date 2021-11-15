import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
const youtubedl = require('youtube-dl');
const os = require('os');
const tmpFilePath = os.tmpdir();
const path = require('path');
const customBinaryPath = path.resolve(tmpFilePath);
admin.initializeApp()

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const getDownloadLinks = functions.region('us-central1').https.onCall((data, context) => {
    
    

    const playlists = data.playlists;
    
    const vidsToDownload:string[] = [];

    const downloadLinks:string[] = ['dhdh','dudu'];
    const authorNames:string[] = ['ahah','auau'];
    const fileNames:string[] = ['fhfh','fifi'];
        
    console.log(getVidsInPlaylist(playlists[0]));

    return {
        "playlists":playlists,
        "vidsToDownload": vidsToDownload,
        "downloadLinks": downloadLinks,
        "fileNames": fileNames,
        "authorNames": authorNames,
    };

});

function getVidsInPlaylist(plist:string): string[]{
    const videos:string[] = [plist];
    
    console.log(tmpFilePath);

    youtubedl.setYtdlBinary(customBinaryPath)

    youtubedl.getInfo(plist, [], function(err:any, info:any) {
        if (err) throw err
       
        console.log('id:', info.id)
        console.log('title:', info.title)
        console.log('url:', info.url)
        console.log('thumbnail:', info.thumbnail)
        console.log('description:', info.description)
        console.log('filename:', info._filename)
        console.log('format id:', info.format_id)
      })

    return videos;
}

