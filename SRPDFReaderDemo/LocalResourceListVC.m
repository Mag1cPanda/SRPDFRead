//
//  LocalResourceListVC.m
//  SRPDFReaderDemo
//
//  Created by longrise on 2018/11/22.
//  Copyright © 2018 longrise. All rights reserved.
//

#import "LocalResourceListVC.h"
#import "SRDirectoryWatcher.h"
#import "ReaderViewController.h"

#define DocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

static NSString *cellID = @"cellID";

@interface LocalResourceListVC ()
<ReaderViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation LocalResourceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
    //获取document路径
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
    
    // 监听Document目录的文件改动
    [[SRDirectoryWatcher defaultWatcher] startMonitoringDocumentAsynchronous];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileChanageAction:) name:ZFileChangedNotification object:nil];
    
    [self getFiles];
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)dealloc
{
    // 取消监听Document目录的文件改动
    [[SRDirectoryWatcher defaultWatcher] stopMonitoringDocument];
    [[NSNotificationCenter defaultCenter] removeObserver:ZFileChangedNotification];
}


- (void)fileChanageAction:(NSNotification *)notification
{
    // ZFileChangedNotification 通知是在子线程中发出的, 因此通知关联的方法会在子线程中执行
    NSLog(@"文件发生了改变, %@", [NSThread currentThread]);
    
    [self getFiles];
}

-(void)getFiles
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSError *error;
    // 获取指定路径对应文件夹下的所有文件
    NSArray <NSString *> *fileArray = [fileManager contentsOfDirectoryAtPath:filePath error:&error];
    NSLog(@"%@", fileArray);
    
    [self.dataArr addObjectsFromArray:fileArray];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",DocumentPath,self.dataArr[indexPath.row]];
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:nil];
    if (document) {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self;
//        [self.navigationController pushViewController:readerViewController animated:YES];
        [self presentViewController:readerViewController animated:YES completion:nil];
    }
}

#pragma mark - ReaderViewControllerDelegate methods
- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
