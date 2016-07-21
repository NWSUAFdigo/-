//
//  WDSettingTableViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/20.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDSettingTableViewController.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>

@interface WDSettingTableViewController ()

/** 图片缓存总字节 */
@property (nonatomic,assign) NSUInteger totalSize;
/** 图片缓存路径 */
@property (nonatomic,copy) NSString *imageCachesPath;
/** cell的文字内容 */
@property (nonatomic,copy) NSString *cellText;

@end


@implementation WDSettingTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNaviBar];
    
    // 设置cell的文本内容
    self.cellText = @"清除缓存";
    
    // 获取图片缓存大小
    [self imageCacheSize];
}


- (void)setupNaviBar{
    
    self.title = @"设置";
}


- (void)imageCacheSize{
    
    // 获取缓存路径
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    // 拼接图片缓存文件夹
    self.imageCachesPath = [cachesPath stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    
    // 创建一个block任务
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
      
        WDLog(@"计算缓存大小线程 %@", [NSThread currentThread]);
       
        // 获取文件管理对象
        NSFileManager *manager = [NSFileManager defaultManager];
        
        // 使用directoryEnumerator来对文件进行管理  Directroy:文件夹
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:self.imageCachesPath];
        
        // 使用下面两个方法也可以获得某个文件夹内的所有文件名
        // 使用该方法可以获得某个文件夹里面的文件夹内的内容
//        NSLog(@"%@", [manager subpathsAtPath:self.imageCachesPath]);
        // 使用该方法无法获得某个文件夹里面的文件夹内的内容,只能获得某个文件夹根目录下面的内容
//        NSLog(@"%@", [manager contentsOfDirectoryAtPath:self.imageCachesPath error:nil]);
        
        // 遍历文件夹,查找所有文件名和文件夹名
        for (NSString *fileName in enumerator) {
            
            // 拼接路径
            NSString *filePath = [self.imageCachesPath stringByAppendingPathComponent:fileName];
            
            // 获得每个文件或文件夹的属性
            NSDictionary *attr = [manager attributesOfItemAtPath:filePath error:nil];
            
            // 根据路径判断是否是文件夹
            // 方式1:判断是否是文件夹
//            BOOL isDirectory = [self isDirectoryAtPath:filePath];
//            if (isDirectory) continue;
            
            // 方式2:判断是否是文件
            BOOL isRegular = [self isRegularAtPath:filePath];
            if (!isRegular) continue;
            
            // 取出文件字节大小
            NSUInteger fileSize = [attr[NSFileSize] unsignedIntegerValue];
            
            self.totalSize += fileSize;
        }
    }];
    
    // 设置任务执行完毕后的操作
    [operation setCompletionBlock:^{
        
        // 设置cell的文字内容
        self.cellText = [NSString stringWithFormat:@"清除缓存(已使用%.2fMB)", self.totalSize / 1000 / 1000.0];
        
        // 回到主线程进行表格刷新
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            WDLog(@"缓存计算完毕线程 %@", [NSThread currentThread]);
            
            // 刷新表格
            [self.tableView reloadData];
        }];
    }];
    
    // 开启线程进行图片缓存计算
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}


/** 判断是否是文件夹 */
- (BOOL)isDirectoryAtPath:(NSString *)path{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 给定一个BOOL值
    BOOL isDirectory = NO;
    
    [manager fileExistsAtPath:path isDirectory:&isDirectory];
    
    return isDirectory;
}


/** 判断是否是文件 */
- (BOOL)isRegularAtPath:(NSString *)path{

    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 获得文件或文件夹的属性
    NSDictionary *attr = [manager attributesOfItemAtPath:path error:nil];
    
    // 判断是否是文件
    BOOL isRegular = (attr[NSFileType] == NSFileTypeRegular);
    
    return isRegular;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"settingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];

        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        indicatorView.hidesWhenStopped = YES;
        
        cell.accessoryView = indicatorView;
        
        [indicatorView startAnimating];
    }

    cell.textLabel.text = self.cellText;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    selectedCell.selected = NO;
    
    // 显示HUD
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
    
    [SVProgressHUD showWithStatus:@"正在清理..."];
    
    // 清除缓存
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:self.imageCachesPath];
    
    // 开启线程来删除图片缓存
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
       
        for (NSString *fileName in enumerator) {
            
            NSString *filePath = [self.imageCachesPath stringByAppendingPathComponent:fileName];
            
            [manager removeItemAtPath:filePath error:nil];
        }
    }];
    
    [operation setCompletionBlock:^{
       
        self.cellText = @"清理缓存";
        
        [SVProgressHUD showSuccessWithStatus:@"清理完成"];
        
        // 回到主线程进行表格刷新
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            WDLog(@"缓存清理完毕线程 %@", [NSThread currentThread]);
            
            [self.tableView reloadData];
        }];
    }];
    
    // 添加任务并执行
    [[NSOperationQueue mainQueue] addOperation:operation];
}



@end
