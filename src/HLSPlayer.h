#pragma once

#include "ofMain.h"


#ifdef __OBJC__
    #import "AVFPlayer.h"
#endif

#if defined TARGET_OF_IOS || defined TARGET_OSX
#import <CoreVideo/CoreVideo.h>
#endif

class HLSPlayer
{
    
public:
    
    HLSPlayer();
    ~HLSPlayer();
	   
    bool load(string name);

    void update();
    
    void drawDebug();
    void draw(float x, float y);
    float width;
    float height;
    float duration;
    float getCurrentTime();
    ofTexture outputTexture;
    unsigned char* pixels;
    void seekToTimeInSeconds(int);
    void togglePause();
    string getInfo();
#ifdef __OBJC__
    AVFPlayer* videoPlayer;
#else
    void * videoPlayer;
#endif
    
};

