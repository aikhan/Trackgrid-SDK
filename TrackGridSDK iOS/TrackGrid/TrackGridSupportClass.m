//
//  TrackGridSupportClass.m
//  TestJson
//
//  Created by shantanu on 25/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrackGridSupportClass.h"
#import "TrackGrid.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation TrackGridSupportClass
@synthesize userAgent;
/*---------------------- File Storage ---------------------------*/
-(BOOL)saveInstallJsonToFile:(NSString*)installJson{
    if ([self filePresent:@"InstallJson.txt"]){
        [self writeContentToFile:@"InstallJson.txt":installJson];
    }
    else {
        NSLog(@"File not present");
    }
    return TRUE;
}
-(BOOL)saveEventJsonToFile:(NSString*)eventJson{
    if ([self filePresent:@"EventJson.txt"]){
        [self writeContentToFile:@"EventJson.txt":eventJson];
    }
    return TRUE;
}
-(BOOL)saveSessionJsonToFile:(NSString*)sessionJson{
    if ([self filePresent:@"SessionJson.txt"]){
        [self writeContentToFile:@"SessionJson.txt":sessionJson];
    }
    return TRUE;
}

-(NSString*)FetchSDKJsonFileContents:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	NSString *documentsDirectory = [documentDirectory stringByAppendingPathComponent:@"SDKDocuments"];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSString *str=[NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:NULL];
    
    return str;
}

-(void) writeContentToFile:(NSString*)fileName :(NSString*)JsonString 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	NSString *documentsDirectory = [documentDirectory stringByAppendingPathComponent:@"SDKDocuments"];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSString* fileContent=[self FetchSDKJsonFileContents:fileName];
	NSMutableString *str1=[[[NSMutableString alloc] initWithString:fileContent] autorelease];
    if([fileContent isEqualToString:@""]){
        
    }else{
        NSString* addComma=[NSString stringWithFormat:@","];
        [str1 appendString:addComma];
    }
    [str1 appendString:JsonString];
	[str1 writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(BOOL)filePresent:(NSString*) filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	NSString *documentsDirectory = [documentDirectory stringByAppendingPathComponent:@"SDKDocuments"];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        [self createFileInDirectory];
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:[@"" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
	return TRUE;
}

-(void) clearContentsOfFile:(NSString*) filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	NSString *documentsDirectory = [documentDirectory stringByAppendingPathComponent:@"SDKDocuments"];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
    NSString* str1=@"";
    [str1 writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}
-(void)createFileInDirectory{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	//make a file name to write the data to the documents directory:
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *folderPath = [NSString stringWithFormat:@"%@/SDKDocuments", documentsDirectory];
	
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:folderPath];
	
	if(!fileExists)
	{
        
		[fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
}

/*---------------------- File Storage ends---------------------------*/

/*---------------------- Get App and Device Parameters---------------------------*/

-(NSString*) getAppVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
} 

-(NSString*) getOSVersion{
    return [[UIDevice currentDevice] systemVersion];
}

-(NSString*)getDeviceModel{
    return [UIDevice currentDevice].model;
}

-(NSString*) getDefaultLanguage{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    return language;
}

-(NSString*) getDefaultCountry{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    return countryCode;
}

-(NSString*) getOpenUDID{
    NSString* _openUDID = nil;
    
    if (_openUDID==nil) {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
        const char *cStr = CFStringGetCStringPtr(cfstring,CFStringGetFastestEncoding(cfstring));
        unsigned char result[16];
        CC_MD5( cStr, strlen(cStr), result );
        CFRelease(uuid);
        
        _openUDID = [NSString stringWithFormat:
                     @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08x",
                     result[0], result[1], result[2], result[3], 
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15],
                     arc4random() % 4294967295];  
    }
    
    return _openUDID;
    
}

-(NSString*) getDeviceODIN{
    // Step 1: Get MAC address
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        //NSLog(@"ODIN-1.1: if_nametoindex error");
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        //NSLog(@"ODIN-1.1: sysctl 1 error");
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL) {
        //NSLog(@"ODIN-1.1: malloc error");
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        //NSLog(@"ODIN-1.1: sysctl 2 error");
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    //NSLog(@"MAC Address: %02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5));
    
    // Step 2: Take the SHA-1 of the MAC address
    
    //NSData *data = [NSData dataWithBytes:ptr length:6];
    
    
    CFDataRef data = CFDataCreate(NULL, (uint8_t*)ptr, 6);
    
    unsigned char messageDigest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(CFDataGetBytePtr((CFDataRef)data), 
            CFDataGetLength((CFDataRef)data), 
            messageDigest);
    
    CFMutableStringRef string = CFStringCreateMutable(NULL, 40);
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        CFStringAppendFormat(string,
                             NULL, 
                             (CFStringRef)@"%02X",
                             messageDigest[i]);
    }
    
    CFStringLowercase(string, CFLocaleGetSystem());
    
    //NSLog(@"ODIN-1: %@", string);
    
    free(buf);
    
    return (NSString*)string;
    
}
-(NSString*) getPhoneCarrier{
    CTTelephonyNetworkInfo *phoneInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *phoneCarrier = [phoneInfo subscriberCellularProvider];
    [phoneInfo release];
    NSString* carrier=[phoneCarrier carrierName];
    return carrier;
    
}


-(NSString*)getUserAgentString
{
	UIWebView* webView = [[UIWebView alloc] init];
	webView.delegate = self;
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com"]]];
    @try{
        // Wait for the web view to load our bogus request and give us the secret user agent.
        while (self.userAgent == nil) 
        {
            // This executes another run loop. 
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }@catch(NSException *exception){
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
    
	return self.userAgent;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	self.userAgent = [request valueForHTTPHeaderField:@"User-Agent"];
	// Return no, we don't care about executing an actual request.
	return NO;
}

-(void) dealloc{
    [userAgent release];
    [super dealloc];
}
/*---------------------- Get App and Device Parameters Ends---------------------------*/

@end
