//
//  TrackGridSupportClass.h
//  TestJson
//
//  Created by shantanu on 25/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackGridSupportClass : NSObject <UIWebViewDelegate>
@property(nonatomic, retain) NSString* userAgent;

-(BOOL)saveInstallJsonToFile:(NSString*)installJson;
-(BOOL)saveEventJsonToFile:(NSString*)eventJson;
-(BOOL)saveSessionJsonToFile:(NSString*)sessionJson;
-(NSString*)FetchSDKJsonFileContents:(NSString*)fileName;
-(void) writeContentToFile:(NSString*)fileName :(NSString*)JsonString;
-(BOOL)filePresent:(NSString*) filename;
-(void) clearContentsOfFile:(NSString*) filename;


-(NSString*) getAppVersion;
-(NSString*) getOSVersion;
-(NSString*)getDeviceModel;
-(NSString*) getDefaultLanguage;
-(NSString*) getDefaultCountry;
-(NSString*) getOpenUDID;
-(NSString*) getDeviceODIN;
-(NSString*) getPhoneCarrier;
-(NSString*)getUserAgentString;
@end
