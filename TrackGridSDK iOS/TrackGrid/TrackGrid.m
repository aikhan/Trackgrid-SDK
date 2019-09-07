//
//  TrackGrid.m
//  TestJson
//
//  Created by shantanu on 25/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrackGrid.h"
#import "NSObject+SBJSON.h"
#import "Reachability.h"
#import "TrackGridSupportClass.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

@implementation TrackGrid
@synthesize mobileAppId;
@synthesize mobileEventId;
@synthesize lat;
@synthesize lon;
@synthesize amount;
@synthesize subid1;
@synthesize subid2; 
@synthesize subid3;


-(void)dealloc{
    [mobileAppId release];
    [mobileEventId release];
    [subid1 release];
    [subid2 release];
    [subid3 release];
    [super dealloc];
}

static TrackGrid *singletonInstance = nil;
static NSString* st=nil;
static NSString* en=nil;

/**
 shareTrackGridInstance returns singletone instance of TrackGridClass
 */

+(TrackGrid*) shareTrackGridInstance{
    
    @synchronized(self) {
        if(!singletonInstance) {
            singletonInstance = [[TrackGrid alloc] init];
        }
    }
    
    return singletonInstance;
}

-(NSString*) getUserAgent{
    TrackGridSupportClass* supportClass=[[TrackGridSupportClass alloc] init];
    return [supportClass getUserAgentString];
}

-(NSString*) getLanguage{
    TrackGridSupportClass* supportClass=[[TrackGridSupportClass alloc] init];
    return [supportClass getDefaultLanguage];
}

-(void) Initialize:(NSString*) appID: (NSString*) eventID{
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    [userPreferences setObject:appID forKey:@"appID"];
    [userPreferences synchronize];

    self.mobileAppId=appID;
    self.mobileEventId=eventID;
    if(self.subid1==NULL){
        self.subid1=@"";
    }
    if(self.subid2==NULL){
        self.subid2=@"";
    }
    if(self.subid3==NULL){
        self.subid3=@"";
    }
    
    [self checkInstalltrackEventStatus];
}

/**************** For Install Track ********************/

-(void)checkInstalltrackEventStatus
{
    if ([self isReachable]) {
        [self trackInstallService];
    }else
    {
        [self saveTrackInstallInfo];
    }
    
}


-(NSString*) createTrackInstallJson{
    TrackGridSupportClass* supportClass=[[TrackGridSupportClass alloc] init];
    NSString* mStr=[NSString stringWithFormat:@"0"];
    NSString* lStr=[NSString stringWithFormat:@"%f",self.lat];
    NSString* loStr=[NSString stringWithFormat:@"%f",self.lon];
    NSString* amStr=[NSString stringWithFormat:@"%0.2f",self.amount];
    NSString* osStr=[NSString stringWithFormat:@"1"];
    NSString* dmStr=@"Apple";
    NSString* edStr=[[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]] stringValue];
    NSString *appID=[[NSUserDefaults standardUserDefaults] objectForKey:@"appID"];
    
    NSDictionary *inspectionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:mStr, @"m", appID,@"a", self.mobileEventId, @"e", [supportClass getAppVersion], @"av",amStr,@"am",osStr,@"os",[supportClass getOSVersion],@"osv",dmStr, @"dm",[supportClass getDeviceModel],@"mod",[supportClass getDefaultCountry],@"dc",[supportClass getOpenUDID],@"od",[supportClass getDeviceODIN],@"di",[supportClass getPhoneCarrier],@"c",lStr,@"l",loStr,@"lo",self.subid1,@"s1",self.subid2,@"s2",self.subid3, @"s3",edStr,@"ed",[supportClass getDefaultLanguage],@"dl", nil];
    
    return [inspectionDictionary JSONRepresentation];
}

/**
 trackInstallService sends all required installation info to server
 */
-(void)trackInstallService{
    @try{
        NSString* jsonString=[self createTrackInstallJson];    
        NSString *url=[NSString stringWithFormat:@"https://mobile.tk2.net/m/install"];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [request setTimeOutSeconds:20];
        [request setDelegate:self];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"User-Agent" value:[self getUserAgent]];
        [request addRequestHeader:@"Accept-Language" value:[self getLanguage]];
        [request addRequestHeader:@"Host" value:@"mobile.tk2.net"];
        [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [jsonString length]]];
        [request appendPostData:[jsonString  dataUsingEncoding:NSUTF8StringEncoding]];   
        [request setDidFailSelector:@selector(trackInstallFailResult:)];
        [request setDidFinishSelector:@selector(trackInstallSuccessResult:)];
        [request startAsynchronous]; 
    }@catch(NSException *exception){
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
    
}

- (void)trackInstallFailResult:(ASIHTTPRequest *)theRequest
{
    NSLog(@"Request Fail");
}

-(void)trackInstallSuccessResult:(ASIHTTPRequest *)theRequest
{
    NSString *jsonResponse =[theRequest responseString];
    NSLog(@"Response : %@",jsonResponse);
    NSDictionary *json = [jsonResponse JSONValue];
    
    @try{
        int mValue=[[json valueForKey:@"m"] intValue];
        if(mValue!=-1 && mValue!=0 && mValue>0){
            NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
            [userPreferences setObject:[NSString stringWithFormat:@"%d",mValue] forKey:@"installID"];
            [userPreferences synchronize];
        }
        else if(mValue==0){
            [self saveTrackInstallInfo];
        }
    }
    @catch(NSException *exception){
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
    
}
/**
    save track Install Info
 */
-(void)saveTrackInstallInfo
{
    TrackGridSupportClass* supportClass=[[TrackGridSupportClass alloc] init];
    [supportClass saveInstallJsonToFile:[self createTrackInstallJson]];
}


/**************** For Create Track Event   ********************/

-(void) trackEvent:(NSString*) eventID
{
    self.mobileEventId=eventID;
    if(self.subid1==NULL){
        self.subid1=@"";
    }
    if(self.subid2==NULL){
        self.subid2=@"";
    }
    if(self.subid3!=NULL){
        self.subid3=@"";
    }
    
    @try{
        if ([self isReachable]) {
            [self trackEventService];
        }else
        {
            [self saveTrackEventInfo];
        }
    }
    @catch(NSException *exception){
            NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
        }
}

-(NSString*) createTrackEventJson{
    TrackGridSupportClass* supportClass=[[TrackGridSupportClass alloc] init];
    NSString *installID=[[NSUserDefaults standardUserDefaults] objectForKey:@"installID"];
    NSString* mStr;
    if(installID==NULL){
        mStr=@"0";
    }else {
        mStr=installID;
    }
    NSString* lStr=[NSString stringWithFormat:@"%f",self.lat];
    NSString* loStr=[NSString stringWithFormat:@"%f",self.lon];
    NSString* amStr=[NSString stringWithFormat:@"%0.2f",self.amount];
    NSString* edStr=[[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]] stringValue];
    NSString *appID=[[NSUserDefaults standardUserDefaults] objectForKey:@"appID"];
    
    NSDictionary *inspectionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:mStr, @"m", appID,@"a",self.mobileEventId, @"e", amStr,@"am",[supportClass getOpenUDID],@"od",[supportClass getDeviceODIN],@"di",lStr,@"l",loStr,@"lo",self.subid1,@"s1",self.subid2,@"s2",self.subid3, @"s3",edStr,@"ed", nil];
    
    return [inspectionDictionary JSONRepresentation];
}
/**
 trackEventOffline sends tracked events info to server
 */
-(void) trackEventService{
    @try{
        NSString* jsonString=[self createTrackEventJson];
        NSString *url=[NSString stringWithFormat:@"https://mobile.tk2.net/m/event"];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [request setTimeOutSeconds:20];
        [request setDelegate:self];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"User-Agent" value:[self getUserAgent]];
        [request addRequestHeader:@"Accept-Language" value:[self getLanguage]];
        [request addRequestHeader:@"Host" value:@"mobile.tk2.net"];
        [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [jsonString length]]];
        [request appendPostData:[jsonString  dataUsingEncoding:NSUTF8StringEncoding]]; 
        [request setDidFailSelector:@selector(trackEventFailResult:)];
        [request setDidFinishSelector:@selector(trackEventSuccessResult:)];
        [request startAsynchronous]; 
    }@catch(NSException *exception){
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
    
}

- (void)trackEventFailResult:(ASIHTTPRequest *)theRequest
{
    NSLog(@"Request fails.");
}
-(void)trackEventSuccessResult:(ASIHTTPRequest *)theRequest
{
    NSString *jsonResponse =[theRequest responseString];
    NSLog(@"Response : %@",jsonResponse);
    if(![[self getEventOfflineJson] isEqualToString:@"[]"] && ![[self getEventOfflineJson] isEqualToString:@"[(null)]"]){
        [self trackEventOffline];
    }
    
    @try{
        NSDictionary *json = [jsonResponse JSONValue];
        int mValue=[[json valueForKey:@"m"] intValue];
        if(mValue!=-1 && mValue!=0 && mValue>0){
            NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
            [userPreferences setObject:[NSString stringWithFormat:@"%d",mValue] forKey:@"installID"];
            [userPreferences synchronize];
        }
        else if(mValue==0){
            [self saveTrackEventInfo];
        }
    }@catch(NSException *exception){
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}
/**
 save track event Info
 */
-(void)saveTrackEventInfo
{
    TrackGridSupportClass* supportClass=[[TrackGridSupportClass alloc] init];
    [supportClass saveEventJsonToFile:[self createTrackEventJson]];
}

-(NSString*) getEventOfflineJson{
    TrackGridSupportClass* supportClass=[[TrackGridSupportClass alloc] init];
    NSString* offlineEvent=[NSString stringWithFormat:@"[%@]",[supportClass FetchSDKJsonFileContents:@"EventJson.txt"]];
    return offlineEvent;
}

/**************** For Track event (Offline) ********************/

/**
 trackEventOffline sends stored tracked events info in offline mode to server
 */
-(void) trackEventOffline{
    @try{
        NSString* jsonString=[self getEventOfflineJson];
        NSString *url=[NSString stringWithFormat:@"https://mobile.tk2.net/m/eventoffline"];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [request setTimeOutSeconds:20];
        [request setDelegate:self];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"User-Agent" value:[self getUserAgent]];
        [request addRequestHeader:@"Accept-Language" value:[self getLanguage]];
        [request addRequestHeader:@"Host" value:@"mobile.tk2.net"];
        [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [jsonString length]]];
        [request appendPostData:[jsonString  dataUsingEncoding:NSUTF8StringEncoding]]; 
        [request setDidFailSelector:@selector(trackEventOfflineFailResult:)];
        [request setDidFinishSelector:@selector(trackEventOfflineSuccessResult:)];
        [request startAsynchronous]; 
    }@catch(NSException *exception){
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
    
}

- (void)trackEventOfflineFailResult:(ASIHTTPRequest *)theRequest
{
    NSLog(@"Request fails.");
}

-(void)trackEventOfflineSuccessResult:(ASIHTTPRequest *)theRequest
{
    NSString *jsonResponse =[theRequest responseString];
    NSLog(@"Response : %@",jsonResponse);
    @try {
        NSDictionary* json=[jsonResponse JSONValue];
        if([[json valueForKey:@"m"] intValue]!=-1){
            TrackGridSupportClass* supportClass=[[TrackGridSupportClass alloc] init];
            [supportClass clearContentsOfFile:@"EventJson.txt"];
        }
    }
    @catch(NSException *exception){
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
    
}

/**************** For Session  Start ********************/


-(void)sessionStart
{
    @try{
        st=[[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]] stringValue]; 
        if ([self isReachable]) {
            [self sessionStartEvt];
        }
    }@catch(NSException *exception){
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
    
}

-(NSString*) createSessionStartJson{
    TrackGridSupportClass* supportClass=[[TrackGridSupportClass alloc] init];
    NSString *installID=[[NSUserDefaults standardUserDefaults] objectForKey:@"installID"];
    NSString *appID=[[NSUserDefaults standardUserDefaults] objectForKey:@"appID"];
    NSString* mStr;
    if(installID==NULL){
        mStr =[NSString stringWithFormat:@"0"];
    }else {
        mStr=installID;
    }
    NSDictionary *inspectionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:mStr, @"m", appID,@"a",[supportClass getOpenUDID],@"od",st,@"st", nil];
    
    return [inspectionDictionary JSONRepresentation];
}

/**
 sessionStartEvt sends session start info to server
 */
-(void) sessionStartEvt{
    @try{
        NSString* jsonString=[self createSessionStartJson];
        NSString *url=[NSString stringWithFormat:@"https://mobile.tk2.net/m/sessionstart"];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [request setTimeOutSeconds:20];
        [request setDelegate:self];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"User-Agent" value:[self getUserAgent]];
        [request addRequestHeader:@"Accept-Language" value:[self getLanguage]];
        [request addRequestHeader:@"Host" value:@"mobile.tk2.net"];
        [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [jsonString length]]];
        [request appendPostData:[jsonString  dataUsingEncoding:NSUTF8StringEncoding]]; 
        [request setDidFailSelector:@selector(sessionStartEvtFailResult:)];
        [request setDidFinishSelector:@selector(sessionStartEvtSuccessResult:)];
        [request startAsynchronous]; 
    }@catch(NSException *exception){
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
    
}

- (void)sessionStartEvtFailResult:(ASIHTTPRequest *)theRequest
{
    NSLog(@"Request fails.");
}

-(void)sessionStartEvtSuccessResult:(ASIHTTPRequest *)theRequest
{
    NSString *jsonResponse =[theRequest responseString];    
    NSLog(@"Response : %@",jsonResponse);
    
    @try{
        if(![[self getSessionOfflineJSon] isEqualToString:@"[]"] && ![[self getSessionOfflineJSon] isEqualToString:@"[(null)]"]){
            [self sessionOffline];
        }
    }@catch(NSException *exception){
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}
/**************** For Session  End ********************/
-(void)sessionEnd
{
    @try{
        en=[[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]] stringValue];
        if ([self isReachable]) {
            [self sessionEndEvt];
        }else
        {
            [self saveTrackSessionInfo];
        }
    }@catch(NSException *exception){
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

-(NSString*) createSessionEndJson{
    NSString *installID=[[NSUserDefaults standardUserDefaults] objectForKey:@"installID"];
    NSString *appID=[[NSUserDefaults standardUserDefaults] objectForKey:@"appID"];
    NSString* mStr;
    if(installID==NULL){
        mStr =[NSString stringWithFormat:@"0"];
    }else {
        mStr=installID;
    }
    TrackGridSupportClass* supportClass=[[TrackGridSupportClass alloc] init];
    NSDictionary *inspectionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:mStr, @"m", appID,@"a",[supportClass getOpenUDID],@"od",en,@"en", nil];
    
    return [inspectionDictionary JSONRepresentation];
}


/**
 sessionEndEvt sends session end info to server
 */
-(void) sessionEndEvt{
    @try{
        NSString* jsonString=[self createSessionEndJson];
        NSString *url=[NSString stringWithFormat:@"https://mobile.tk2.net/m/sessionend"];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [request setTimeOutSeconds:20];
        [request setDelegate:self];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"User-Agent" value:[self getUserAgent]];
        [request addRequestHeader:@"Accept-Language" value:[self getLanguage]];
        [request addRequestHeader:@"Host" value:@"mobile.tk2.net"];
        [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [jsonString length]]];
        [request appendPostData:[jsonString  dataUsingEncoding:NSUTF8StringEncoding]]; 
        [request setDidFailSelector:@selector(sessionEndEvtFailResult:)];
        [request setDidFinishSelector:@selector(sessionEndEvtSuccessResult:)];
        [request startAsynchronous]; 
    }@catch(NSException *exception){
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
    
}

- (void)sessionEndEvtFailResult:(ASIHTTPRequest *)theRequest
{
    
    NSLog(@"Request fails.");
}

-(void)sessionEndEvtSuccessResult:(ASIHTTPRequest *)theRequest
{
    NSString *jsonResponse =[theRequest responseString];
    NSLog(@"Response : %@",jsonResponse);
    
    @try{
        if(![[self getSessionOfflineJSon] isEqualToString:@"[]"] && ![[self getSessionOfflineJSon] isEqualToString:@"[(null)]"]){
            [self sessionOffline];
        }
    
        NSDictionary *json = [jsonResponse JSONValue];
        int mValue=[[json valueForKey:@"m"] intValue];
        if(mValue!=-1 && mValue!=0 && mValue>0){
            NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
            [userPreferences setObject:[NSString stringWithFormat:@"%d",mValue] forKey:@"installID"];
            [userPreferences synchronize];
        }
        else if(mValue==0){
            [self saveTrackSessionInfo];
        }
        
    }@catch(NSException *exception){
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
    
}

/**************** For Session(OFFLINE)   ********************/

-(NSString*) createSessionJson{
    NSString *installID=[[NSUserDefaults standardUserDefaults] objectForKey:@"installID"];
    NSString *appID=[[NSUserDefaults standardUserDefaults] objectForKey:@"appID"];
    NSString* mStr;
    if(installID==NULL){
        mStr =[NSString stringWithFormat:@"0"];
    }else {
        mStr=installID;
    }
    TrackGridSupportClass* supportClass=[[TrackGridSupportClass alloc] init];
    NSDictionary *inspectionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:mStr, @"m", appID,@"a",[supportClass getOpenUDID],@"od",st,@"st",en,@"en", nil];
    
    return [inspectionDictionary JSONRepresentation];
}

/**
 saveTrackSessionInfo saves tracked session info in offline mode 
 */
-(void)saveTrackSessionInfo
{
    TrackGridSupportClass* supportClass=[[TrackGridSupportClass alloc] init];
    [supportClass saveSessionJsonToFile:[self createSessionJson]];
}

/**
 getSessionOfflineJSon retrievs stored tracked session info 
 */
-(NSString*) getSessionOfflineJSon{
    TrackGridSupportClass* supportClass=[[TrackGridSupportClass alloc] init];
    NSString* offlineSession=[NSString stringWithFormat:@"[%@]",[supportClass FetchSDKJsonFileContents:@"SessionJson.txt"]];
    return offlineSession;
}

/**
 sessionOffline sends stored offline data 
 */
-(void)sessionOffline 
{
    @try{
        NSString* jsonString=[self getSessionOfflineJSon];
        NSString *url=[NSString stringWithFormat:@"https://mobile.tk2.net/m/sessionoffline"];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [request setTimeOutSeconds:20];
        [request setDelegate:self];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"User-Agent" value:[self getUserAgent]];
        [request addRequestHeader:@"Accept-Language" value:[self getLanguage]];
        [request addRequestHeader:@"Host" value:@"mobile.tk2.net"];
        [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [jsonString length]]];
        [request appendPostData:[jsonString  dataUsingEncoding:NSUTF8StringEncoding]]; 
        [request setDidFailSelector:@selector(offlinesessionFailResult:)];
        [request setDidFinishSelector:@selector(offlinesessionSuccessResult:)];
        [request startAsynchronous]; 
    }
    @catch(NSException *exception){
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
    
}

- (void)offlinesessionFailResult:(ASIHTTPRequest *)theRequest
{
    NSLog(@"Request fails.");
}

-(void)offlinesessionSuccessResult:(ASIHTTPRequest *)theRequest
{
    NSString *jsonResponse =[theRequest responseString];
    NSLog(@"Response : %@",jsonResponse);
    @try{
        NSDictionary* json=[jsonResponse JSONValue];
        if([[json valueForKey:@"m"] intValue]!=-1){
            TrackGridSupportClass* supportClass=[[TrackGridSupportClass alloc] init];
            [supportClass clearContentsOfFile:@"SessionJson.txt"];
        }
    }@catch(NSException *exception){
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
    
}
/**************** For Session(OFFLINE) ends  ********************/

/**
 isReachable checks for internet connection 
 */
-(BOOL) isReachable
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        return FALSE;  
    }
    return TRUE;
}

@end
