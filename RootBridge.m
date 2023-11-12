#import <RootBridge.h>
#import "vendor/apple/dyld_priv.h"

#ifndef THEOS_PACKAGE_SCHEME_ROOTHIDE
#import <rootless.h>
#else
#import <roothide.h>
#define ROOT_PATH_NS_VAR jbroot
#endif


@implementation RootBridge
+ (NSString *)getCallerPath {
    const void* ret_addr = __builtin_extract_return_addr(__builtin_return_address(0));

    if(ret_addr) {
        const char* ret_image_name = dyld_image_path_containing_address(ret_addr);

        if(ret_image_name) {
            return @(ret_image_name);
        }
    }

    return nil;
}

+ (BOOL)isJBRootless {
    static BOOL rootless = NO;
    static dispatch_once_t onceToken = 0;

    dispatch_once(&onceToken, ^{
        NSString* caller_path = [self getCallerPath];
        rootless = !([caller_path hasPrefix:@"/Library"] || [caller_path hasPrefix:@"/usr"]);
    });

    return rootless;
}

+ (NSString *)getJBPath:(NSString *)path {
    if(![self isJBRootless] || !path || ![path isAbsolutePath]) { // || [path hasPrefix:@"/var/jb"] this check should be done in rootless header
        return path;
    }

    return ROOT_PATH_NS_VAR(path);
}
@end
