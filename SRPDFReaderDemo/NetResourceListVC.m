//
//  NetResourceListVC.m
//  SRPDFReaderDemo
//
//  Created by longrise on 2018/11/22.
//  Copyright © 2018 longrise. All rights reserved.
//

#import "NetResourceListVC.h"
#import "ReaderViewController.h"

static NSString *cellID = @"cellID";

@interface NetResourceListVC ()
<NSURLSessionDownloadDelegate,
ReaderViewControllerDelegate>
@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

//下载相关
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumData;
@end

@implementation NetResourceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = @[@"http://zhimei.hntv.tv/bbvideo/2018/10/15/dx-2.pdf",
                     @"http://zhimei.hntv.tv/bbvideo/2018/10/16/bbwAPP.pdf",
                     @"http://zhimei.hntv.tv/bbvideo/2018/10/12/2.1jsjzdsyzfdbsfs.pdf",
                     @"http://zhimei.hntv.tv/bbvideo/2018/10/11/1-dy.pdf",
                     @"http://zhimei.hntv.tv/bbvideo/2018/10/12/2.1jsjzdsyzfdbsfs.pdf"];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    self.activityIndicator.center = self.view.center;
    [self.view addSubview:self.activityIndicator];

    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *URLString = self.dataArr[indexPath.row];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:request];
    [downloadTask resume];
    self.downloadTask = downloadTask;
    
    [self.activityIndicator startAnimating];
}

#pragma mark - NSURLSessionDownloadDelegate
/**
 *  写数据
 *
 *  @param session                   会话对象
 *  @param downloadTask              下载任务
 *  @param bytesWritten              本次写入的数据大小
 *  @param totalBytesWritten         下载的数据总大小
 *  @param totalBytesExpectedToWrite  文件的总大小
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //1. 获得文件的下载进度
    NSLog(@"%f",1.0 * totalBytesWritten/totalBytesExpectedToWrite);
}

/**
 *  当恢复下载的时候调用该方法
 *
 *  @param fileOffset         从什么地方下载
 *  @param expectedTotalBytes 文件的总大小
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"%s",__func__);
}

/**
 *  当下载完成的时候调用
 *
 *  @param location     文件的临时存储路径
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    [self.activityIndicator stopAnimating];
    
    NSLog(@"location ~ %@",location);
    
    //1 拼接文件全路径
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    //2 剪切文件
    [[NSFileManager defaultManager]moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
    NSLog(@"fullPath ~ %@",fullPath);
    
    ReaderDocument *doc = [[ReaderDocument alloc] initWithFilePath:fullPath password:nil];
    ReaderViewController *rederVC = [[ReaderViewController alloc] initWithReaderDocument:doc];
    rederVC.delegate = self;
    
//    NSArray *tmpArr1 = [fullPath componentsSeparatedByString:@"/"];
//    NSString *truename = [tmpArr1 lastObject];
//    NSArray *tmpArr2 = [truename componentsSeparatedByString:@"."];
//    NSString *title = [tmpArr2 firstObject];
    
//    [self.navigationController pushViewController:rederVC animated:YES];
    [self presentViewController:rederVC animated:YES completion:nil];
}

/**
 *  请求结束
 */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError");
    [self.activityIndicator stopAnimating];
}

#pragma mark - ReaderViewControllerDelegate methods
-(void)readerViewController:(ReaderViewController *)viewController didScrollToPage:(NSInteger)page
{
    NSLog(@"%zi",page);
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
