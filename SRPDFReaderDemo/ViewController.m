//
//  ViewController.m
//  SRPDFReaderDemo
//
//  Created by longrise on 2018/11/22.
//  Copyright © 2018 longrise. All rights reserved.
//

#import "ViewController.h"
#import "LocalResourceListVC.h"
#import "NetResourceListVC.h"
#import "SRPDFReaderVC.h"

@interface ViewController ()
<ReaderViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"PDF Demo";
}

#pragma mark - Action

- (IBAction)bundleResourse:(id)sender {
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
    NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    
    NSString *filePath = [pdfs firstObject]; assert(filePath != nil); // Path to first PDF file
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
    NSLog(@"pageCount ~ %@",document.pageCount);
    
    if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
    {
        SRPDFReaderVC *readerVC = [[SRPDFReaderVC alloc] initWithReaderDocument:document];
        
        readerVC.delegate = self; // Set the ReaderViewController delegate to self
        
//        [self.navigationController pushViewController:readerVC animated:YES];
        

        readerVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        readerVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:readerVC animated:YES completion:NULL];
        
    }
    else // Log an error so that we know that something went wrong
    {
        NSLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, filePath, phrase);
    }
}

- (IBAction)localResourse:(id)sender {
    LocalResourceListVC *vc = [LocalResourceListVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)netResourse:(id)sender {
    NetResourceListVC *vc = [NetResourceListVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ReaderViewControllerDelegate methods
-(void)readerViewController:(ReaderViewController *)viewController didScrollToPage:(NSInteger)page
{
    NSLog(@"%zi",page);
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
