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
#import "ReaderViewController.h"

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
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
        readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
        //        [self.navigationController pushViewController:readerViewController animated:YES];
        
//        UIModalTransitionStyleCoverVertical = 0,
//        UIModalTransitionStyleFlipHorizontal,
//        UIModalTransitionStyleCrossDissolve,
//        UIModalTransitionStylePartialCurl
        readerViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
//        UIModalPresentationFullScreen = 0,
//        UIModalPresentationPageSheet NS_ENUM_AVAILABLE_IOS(3_2) __TVOS_PROHIBITED,
//        UIModalPresentationFormSheet NS_ENUM_AVAILABLE_IOS(3_2) __TVOS_PROHIBITED,
//        UIModalPresentationCurrentContext NS_ENUM_AVAILABLE_IOS(3_2),
//        UIModalPresentationCustom NS_ENUM_AVAILABLE_IOS(7_0),
//        UIModalPresentationOverFullScreen NS_ENUM_AVAILABLE_IOS(8_0),
//        UIModalPresentationOverCurrentContext NS_ENUM_AVAILABLE_IOS(8_0),
//        UIModalPresentationPopover NS_ENUM_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED,
//        UIModalPresentationBlurOverFullScreen __TVOS_AVAILABLE(11_0) __IOS_PROHIBITED __WATCHOS_PROHIBITED,
//        UIModalPresentationNone NS_ENUM_AVAILABLE_IOS(7_0) = -1,
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:readerViewController animated:YES completion:NULL];
        
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

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
