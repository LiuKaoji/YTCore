//
//  YTFileManager.m
//  YTCore
//
//  Created by kaoji on 3/12/20.
//

#import "YTFileManager.h"

@implementation YTFileManager
+ (BOOL)createDirectoryAtPath:(NSString *)path {
    
    if([YTFileManager fileExistsAtPath: path]){
        return  YES;
    }

    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!success) {
        NSLog(@"Error creating directory: %@", error.localizedDescription);
    }
    
    return success;
}

+ (BOOL)createFileAtPath:(NSString *)path content:(NSData *)content {
    BOOL success = [content writeToFile:path atomically:YES];
    
    if (!success) {
        NSLog(@"Error creating file at path: %@", path);
    }
    
    return success;
}

+ (BOOL)fileExistsAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    return exists && !isDirectory;
}

+ (BOOL)directoryExistsAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    return exists && isDirectory;
}

+ (NSArray *)contentsOfDirectoryAtPath:(NSString *)path {
    NSError *error;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    
    if (error) {
        NSLog(@"Error getting contents of directory: %@", error.localizedDescription);
    }
    
    return contents;
}

+ (BOOL)deleteFileAtPath:(NSString *)path {
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    
    if (!success) {
        NSLog(@"Error deleting file at path: %@", path);
    }
    
    return success;
}

+ (BOOL)deleteDirectoryAtPath:(NSString *)path {
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    
    if (!success) {
        NSLog(@"Error deleting directory at path: %@", path);
    }
    
    return success;
}

+ (void)moveFileFrom:(NSString *)sourcePath to:(NSString *)destinationPath completion:(void (^)(BOOL success, NSError *error))completion {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    if ([fileManager fileExistsAtPath: destinationPath]) {
        [YTFileManager deleteFileAtPath: destinationPath];
    }

    if ([fileManager moveItemAtPath:sourcePath toPath:destinationPath error:&error]) {
        completion(YES, nil);
    } else {
        completion(NO, error);
    }
}

+ (BOOL)moveFolderAtPath:(NSString *)sourcePath toPath:(NSString *)destinationPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL success = [fileManager moveItemAtPath:sourcePath toPath:destinationPath error:&error];
    if (!success) {
        NSLog(@"Error moving folder: %@", error.localizedDescription);
    }
    return success;
}

+ (nullable NSString *)getYTCoreBundleFile:(NSString *)fullName{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    //NSString *frameworkPath = [bundle pathForResource:@"YTCore" ofType:@"framework"];
    return  [bundle pathForResource:fullName ofType:@""];
}
@end
