#import "AVFPlayer.h"


@implementation AVFPlayer

@synthesize avPlayerItem = _avPlayerItem;
@synthesize avPlayer = _avPlayer;
static const NSString *ItemStatusContext = @"ItemStatusContext";


void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"exception %@", exception);
}


-(id) init
{
    self = [super init];
    self.avPlayer = [[AVPlayer alloc] init];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    return self;
    
}

-(void) loadFromURL:(NSURL *)url
{
    

    
    NSDictionary* pixelBufferAttributes = @{
        (NSString*) kCVPixelBufferIOSurfacePropertiesKey : @{}, // generally want this especially on iOS
        (NSString *)kCVPixelBufferOpenGLCompatibilityKey : @YES, // should never be no.
        (NSString *)kCVPixelBufferPixelFormatTypeKey     : [NSNumber numberWithInt:kCVPixelFormatType_32ARGB]
        };
    

    self.avPlayerItem = [[AVPlayerItem playerItemWithURL:url] retain];
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
    if(self.avPlayer != nil)
    {
        [self.avPlayerItem addObserver:self forKeyPath:@"status" options:0 context:&ItemStatusContext];

    }
    AVPlayerItemVideoOutput* playerItemVideoOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:pixelBufferAttributes];
    NSArray* assetKeysRequiredToPlay = @[@"playable",
                                         @"hasProtectedContent",
                                         @"exportable",
                                         @"readable",
                                         @"composable",
                                         @"tracks"];
    
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    
    [asset loadValuesAsynchronouslyForKeys:assetKeysRequiredToPlay completionHandler:^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /*
             This method is called when the `AVAsset` for our URL has
             completed the loading of the values of the specified array
             of keys.
             */
            
            /*
             Test whether the values of each of the keys we need have been
             successfully loaded.
             */
            for (NSString *key in assetKeysRequiredToPlay)
            {
                
                NSError *error = nil;
                AVKeyValueStatus status  = [asset statusOfValueForKey:key error:&error];
                switch(status)
                {
                    case AVKeyValueStatusUnknown :
                    {
                        NSLog(@"AVKeyValueStatusUnknown %@", key);
                        break;
                    };
                        
                    case AVKeyValueStatusLoading :
                    {
                        NSLog(@"AVKeyValueStatusLoading %@", key);
                        break;
                        
                    };
                    case AVKeyValueStatusLoaded :
                    {
                        NSLog(@"AVKeyValueStatusLoaded %@", key);
                        if([key isEqualToString:@"tracks"])
                        {
                            /*
                            NSLog(@"AVMediaCharacteristicVisual count %ld", (unsigned long)[[asset tracksWithMediaCharacteristic:AVMediaCharacteristicVisual] count]);
                            NSLog(@"AVMediaCharacteristicAudible count %ld", (unsigned long)[[asset tracksWithMediaCharacteristic:AVMediaCharacteristicAudible] count]);
                            NSLog(@"AVMediaCharacteristicLegible count %ld", (unsigned long)[[asset tracksWithMediaCharacteristic:AVMediaCharacteristicLegible] count]);
                            NSLog(@"AVMediaCharacteristicFrameBased count %ld", (unsigned long)[[asset tracksWithMediaCharacteristic:AVMediaCharacteristicFrameBased] count]);
                             */
                            [self createAssets:asset];

                        }
                        break;
                        
                    };
                    case AVKeyValueStatusFailed :
                    {
                        NSLog(@"AVKeyValueStatusFailed %@", key);
                        break;
                        
                    };
                    case AVKeyValueStatusCancelled  :
                    {
                        NSLog(@"AVKeyValueStatusCancelled %@", key);
                        break;
                        
                    };
                    default:
                    {
                        NSLog(@"default");
                        break;
                    }
                }
                
                if ([asset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed)
                {
                    NSString *stringFormat = NSLocalizedString(@"error.asset_%@_key_%@_failed.description", @"Can't use this AVAsset because one of it's keys failed to load");
                                        
                    NSLog(@"error %@", [error localizedDescription]);
                    
                    return;
                }
            }
            
            // We can't play this asset.
            if (!asset.playable || asset.hasProtectedContent) {
                NSString *stringFormat = NSLocalizedString(@"error.asset_%@_not_playable.description", @"Can't use this AVAsset because it isn't playable or has protected content");
                
                
                NSLog(@"error %@", stringFormat);

                
                return;
            }
            
            NSMutableDictionary* loadedAssets = [NSMutableDictionary dictionary];
            
            NSLog(@"loadedAssets %@", loadedAssets);
            //loadedAssets[title] = asset;

        });
#if 0
        if (status == AVKeyValueStatusLoaded)
        {
            NSDictionary* settings = @{ (id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_32BGRA] };
            AVPlayerItemVideoOutput* output = [[[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:settings] autorelease];
            self.avPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
            [self.avPlayerItem addOutput:output];
            self.avPlayer = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
            
            NSArray<AVPlayerItemTrack *>* tracks = self.avPlayerItem.tracks;
            CGSize presentationSize = self.avPlayerItem.presentationSize;
            CMTime duration = self.avPlayerItem.asset.duration;
            float preferredRate = self.avPlayerItem.asset.preferredRate;
            float preferredVolume = self.avPlayerItem.asset.preferredVolume;
            CGAffineTransform preferredTransform = self.avPlayerItem.asset.preferredTransform;
            NSArray<AVMetadataItem *>* timedMetadata = self.avPlayerItem.timedMetadata;
            
         
            
            [self.avPlayer replaceCurrentItemWithPlayerItem:self.avPlayerItem];
            //[playerItemVideoOutput setSuppressesPlayerRendering:YES];
            [self.avPlayer.currentItem addOutput:playerItemVideoOutput];

            [self.avPlayerItem seekToTime:CMTimeMake(5000, 1000)];
            
            CMTime currentTime = self.avPlayerItem.currentTime;

            CVPixelBufferRef buffer = [playerItemVideoOutput copyPixelBufferForItemTime:[self.avPlayerItem currentTime] itemTimeForDisplay:nil];
            
            AVPlayerItemAccessLog* accessLog = self.avPlayerItem.accessLog;
            NSString* accessLogOutput = [[NSString alloc]
                                         initWithData:[accessLog extendedLogData]
                                         encoding:[accessLog extendedLogDataStringEncoding]];
            
            AVPlayerItemErrorLog* errorLog = self.avPlayerItem.errorLog;
            NSString* errorLogOutput = [[NSString alloc]
                                        initWithData:[errorLog extendedLogData]
                                        encoding:[errorLog extendedLogDataStringEncoding]];
            
            NSLog(@"accessLogOutput %@", accessLogOutput);
            NSLog(@"errorLogOutput %@", errorLogOutput);

            //[self.avPlayerItem removeObserver:self forKeyPath:@"status"];
        }
        else
        {
            NSLog(@"%@ Failed to load the tracks.", self);
        }
#endif
    }];
    
    // Now at any later point in time, you can get a pixel buffer
    // that corresponds to the current AVPlayer state like this:
    
    

}

-(void) createAssets:(AVURLAsset*)asset
{
    NSLog(@"createAssets");
    NSDictionary* settings = @{ (id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_32BGRA] };
    AVPlayerItemVideoOutput* output = [[[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:settings] autorelease];
    self.avPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self.avPlayerItem addOutput:output];
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.avPlayerItem ];
    [self.avPlayer addObserver:self forKeyPath:@"currentItem.presentationSize" options:NSKeyValueObservingOptionNew context:NULL];
   
    NSArray<AVPlayerItemTrack *>* tracks = self.avPlayerItem.tracks;
    CGSize presentationSize = self.avPlayerItem.presentationSize;
    CMTime duration = self.avPlayerItem.asset.duration;
    float preferredRate = self.avPlayerItem.asset.preferredRate;
    float preferredVolume = self.avPlayerItem.asset.preferredVolume;
    CGAffineTransform preferredTransform = self.avPlayerItem.asset.preferredTransform;
    NSArray<AVMetadataItem *>* timedMetadata = self.avPlayerItem.timedMetadata;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (context != &ItemStatusContext) {
        // KVO isn't for us.
        //[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        //return;
    }
    NSLog(@"keyPath: %@", keyPath);
    NSLog(@"object: %@", object);
    NSLog(@"change: %@", change);
    if ([keyPath isEqualToString:@"currentItem.presentationSize"]) {
    
        NSLog(@"currentItem.presentationSize");
        CGSize presentationSize = self.avPlayerItem.presentationSize;
        // NSLog(@"presentationSize: %@", presentationSize);
        
    }
    //NSLog(@"context: %@", (NSString *)context);
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSLog(@"keyPathsForValuesAffectingValueForKey key: %@", key);

}

@end