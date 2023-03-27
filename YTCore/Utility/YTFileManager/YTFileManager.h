//
//  YTFileManager.h
//  YTCore
//
//  Created by kaoji on 3/12/20.
//
#import <Foundation/Foundation.h>

// Documents 目录路径
#define DOC_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

// Library 目录路径
#define LIB_PATH [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]

// Caches 目录路径
#define CACHE_PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

// tmp 目录路径
#define TEMP_PATH NSTemporaryDirectory()

NS_ASSUME_NONNULL_BEGIN

/// YTFileManager 类负责文件和目录的创建、移动、删除和检查等操作
@interface YTFileManager : NSObject

// 创建目录
+ (BOOL)createDirectoryAtPath:(NSString *)path;

// 创建文件
+ (BOOL)createFileAtPath:(NSString *)path content:(NSData *)content;

// 检查文件是否存在
+ (BOOL)fileExistsAtPath:(NSString *)path;

// 文件移动
+ (void)moveFileFrom:(NSString *)sourcePath to:(NSString *)destinationPath completion:(void (^)(BOOL success, NSError *error))completion;

// 文件夹移动
+ (BOOL)moveFolderAtPath:(NSString *)sourcePath toPath:(NSString *)destinationPath;

// 检查目录是否存在
+ (BOOL)directoryExistsAtPath:(NSString *)path;

// 读取目录内容
+ (NSArray *)contentsOfDirectoryAtPath:(NSString *)path;

// 删除文件
+ (BOOL)deleteFileAtPath:(NSString *)path;

// 删除目录
+ (BOOL)deleteDirectoryAtPath:(NSString *)path;

// 从当前 framework 中读取资源文件
+ (nullable NSString *)getYTCoreBundleFile:(NSString *)fullName;

@end

NS_ASSUME_NONNULL_END

