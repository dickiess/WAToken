//
//  MyDevice.m
//  DSEM
//
//  Created by dizhihao on 16/2/23.
//  Copyright © 2016年 dizhihao. All rights reserved.
//

#import "MyDevice.h"
#import <sys/utsname.h>
#import <sys/sysctl.h>

#import <arpa/inet.h>
#import <ifaddrs.h>

#import <net/if.h>
#import <net/if_dl.h>

@implementation MyDevice

// 设备名称
+ (NSString *)getCurrentDeviceModel {

    struct utsname systemInfo;
    uname(&systemInfo);
    NSStringEncoding sEncoding = NSUTF8StringEncoding;
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:sEncoding];
    
    // iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (移动,联通)";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (联通)";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (电信)";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (移动,联通)";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (移动,电信,联通)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString hasPrefix:@"iPhone6"])            return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6S Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"国行(A1863)、日行(A1906)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"美版(Global/A1905)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"国行(A1864)、日行(A1898)iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"美版(Global/A1897)iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"国行(A1865)、日行(A1902)iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"美版(Global/A1901)iPhone X";

    
    // iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad 1";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3 (4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini2";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini2";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini4";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini4";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    if ([deviceString isEqualToString:@"iPad6,11"])     return @"iPad 5 (WiFi)";
    if ([deviceString isEqualToString:@"iPad6,12"])     return @"iPad 5 (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,3"])      return @"iPad Pro 10.5 inch (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5 inch (Cellular)";
    
    
    // iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1Gen";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2Gen";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3Gen";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4Gen";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5Gen";
    if ([deviceString isEqualToString:@"iPod7,1"])      return @"iPod Touch 6Gen";
    
    
    // TV
    if ([deviceString isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])   return @"Apple TV 4";
    
    
    // Simulator
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";

    
    return deviceString;
}

/********************************************************************************************/

#pragma mark - IP Address

// Get IP Address
+ (NSString *)deviceIPAdress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            //            NSLog(@"ifa_name===%@", [NSString stringWithUTF8String:temp_addr->ifa_name]);
            // Check if interface is en0 which is the wifi connection on the iPhone
            if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"] ||
                [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"pdp_ip0"]) {
                if (temp_addr->ifa_addr->sa_family == AF_INET) {            // 如果是IPV4地址，直接转化
#if DEBUG
//                    NSLog(@"Ipv4");
#endif
                    // Get NSString from C String
                    address = [self formatIPV4Address:((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr];
                } else if (temp_addr->ifa_addr->sa_family == AF_INET6) {    // 如果是IPV6地址
                    address = [self formatIPV6Address:((struct sockaddr_in6 *)temp_addr->ifa_addr)->sin6_addr];
                    if (address && ![address isEqualToString:@""] &&
                        ![address.uppercaseString hasPrefix:@"FE80"]) {
#if DEBUG
//                        NSLog(@"Ipv6");
#endif
                        break;
                    }
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

// for IPV6
+ (NSString *)formatIPV6Address:(struct in6_addr)ipv6Addr {
    
    NSString *address = nil;
    char dstStr[INET6_ADDRSTRLEN];
    char srcStr[INET6_ADDRSTRLEN];
    memcpy(srcStr, &ipv6Addr, sizeof(struct in6_addr));
    if (inet_ntop(AF_INET6, srcStr, dstStr, INET6_ADDRSTRLEN) != NULL) {
        address = [NSString stringWithUTF8String:dstStr];
    }
    
    return address;
}

// for IPV4
+ (NSString *)formatIPV4Address:(struct in_addr)ipv4Addr {
    
    NSString *address = nil;
    char dstStr[INET_ADDRSTRLEN];
    char srcStr[INET_ADDRSTRLEN];
    memcpy(srcStr, &ipv4Addr, sizeof(struct in_addr));
    if(inet_ntop(AF_INET, srcStr, dstStr, INET_ADDRSTRLEN) != NULL){
        address = [NSString stringWithUTF8String:dstStr];
    }
    
    return address;
}

/********************************************************************************************/

#pragma mark - Mac Address

// Get Mac Address
+ (NSString *)deviceMacAdress {
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
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL) {
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *strmacAdress
    = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
       *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    
    return [strmacAdress uppercaseString];
}

/********************************************************************************************/




@end
