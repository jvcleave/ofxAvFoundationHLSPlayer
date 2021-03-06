#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofSetLogLevel(OF_LOG_VERBOSE);
    string v1="http://192.168.200.43:1935/vod/mp4:sample.mp4/playlist.m3u8";
    string v2 = "http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8";
    string v3="https://devimages.apple.com.edgekey.net/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8";
    string v4= "http://vod.edgecast.hls.ttvnw.net/v1/AUTH_system/vods_2d6e/milkgasm_22785175088_499182978/chunked/index-dvr.m3u8";
    string v5 = "http://iphone-streaming.ustream.tv/uhls/17074538/streams/live/iphone/playlist.m3u8";
    
    videoPlayer.load(v5);
}

//--------------------------------------------------------------
void ofApp::update(){
    videoPlayer.update();
}

//--------------------------------------------------------------
void ofApp::draw(){
    videoPlayer.drawDebug();
    stringstream info;
    info << videoPlayer.getInfo() << endl;
    info << ofGetFrameRate() << endl;

    ofDrawBitmapStringHighlight(info.str(), 20, 20, ofColor(ofColor::black, 90), ofColor::yellow);
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    if(key == '1')
    {
        videoPlayer.seekToTimeInSeconds(3);
    
    }
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
