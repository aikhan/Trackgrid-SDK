//
//  TrackGrid.h
//  TestJson
//
//  Created by shantanu on 25/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TrackGrid : NSObject{

    NSString* mobileAppId;
    NSString* mobileEventId;
    float lat;
    float lon;
    float amount;
    NSString* subid1;
    NSString* subid2; 
    NSString* subid3;
}

@property(nonatomic, retain) NSString* mobileAppId;
@property(nonatomic, retain) NSString* mobileEventId;
@property(nonatomic, assign) float lat;
@property(nonatomic, assign) float lon;
@property(nonatomic, assign) float amount;
@property(nonatomic, retain) NSString* subid1;
@property(nonatomic, retain) NSString* subid2; 
@property(nonatomic, retain) NSString* subid3; 


+(TrackGrid*) shareTrackGridInstance;
-(void) Initialize:(NSString*) appID: (NSString*) eventID;
-(void) trackEvent:(NSString*) eventID;
-(void)sessionStart;
-(void)sessionEnd;



@end
