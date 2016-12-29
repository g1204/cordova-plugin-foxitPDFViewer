/********* FoxitPDFViewer.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <UIKit/UIKit.h>
#import <FoxitRDK/FSPDFObjC.h>
#import <FoxitRDK/FSPDFViewControl.h>
#import "UIExtensionsManager.h"

@interface FoxitPDFViewer : CDVPlugin
@property (nonatomic, assign) BOOL RDKInitialized;
@property (nonatomic, strong) UINavigationBar* navBar;
@property (nonatomic, strong) FSPDFViewCtrl* pdfView;
@property (nonatomic, strong) UIExtensionsManager* extensionsManager;
@end

@implementation FoxitPDFViewer

#pragma mark JS invocations

- (void)initLibrary:(CDVInvokedUrlCommand*)command
{
    if ([command.arguments count] < 2) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Not enough parameters"] callbackId:command.callbackId];
        return;
    }
    self.RDKInitialized = [self initLibraryWithSN:command.arguments[0] key:command.arguments[1]];
    if (self.RDKInitialized) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
    } else {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid license"] callbackId:command.callbackId];
    }
}

- (void)openSamplePDF:(CDVInvokedUrlCommand*)command
{
    if (self.RDKInitialized) {
        CGSize screenSize = self.webView.bounds.size;
        if (!self.pdfView) {
            CGRect frame = {screenSize.width, 0, screenSize};
            self.pdfView = [[FSPDFViewCtrl alloc] initWithFrame:frame];
        }
        if (self.extensionsManager) {
            self.pdfView.extensionsManager = self.extensionsManager;
        }
        NSString* pdfPath = [[NSBundle mainBundle] pathForResource:@"Sample" ofType:@"pdf"];
        FSPDFDoc* doc = [FSPDFDoc createFromFilePath:pdfPath];
        if(e_errSuccess == [doc load:nil]) {
            [self.pdfView setDoc:doc];
        }
        if (!self.navBar) {
            CGRect frame = {screenSize.width, 0, screenSize.width, 64};
            self.navBar = [[UINavigationBar alloc] initWithFrame:frame];
            UINavigationItem* navItem = [UINavigationItem new];
            self.navBar.items = @[navItem];
            navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closePDF)];
        }
        [self.webView addSubview:self.pdfView];
        [self.webView addSubview:self.navBar];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.pdfView.center = CGPointMake(screenSize.width / 2, self.pdfView.center.y);
            self.navBar.center = CGPointMake(screenSize.width / 2, self.navBar.center.y);
        } completion:^(BOOL finished) {
        }];
        
        
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
    } else {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Library not initialized"] callbackId:command.callbackId];
    }
}

- (void)closePDF:(CDVInvokedUrlCommand*)command
{
    [self closePDF];
}

- (void)loadExtensions:(CDVInvokedUrlCommand*)command
{
    if (self.RDKInitialized) {
        self.extensionsManager = [[UIExtensionsManager alloc] initWithPDFViewControl:self.pdfView];
        self.pdfView.extensionsManager = self.extensionsManager;
        
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
    } else {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Library not initialized"] callbackId:command.callbackId];
    }
}

#pragma mark - inner methods

- (BOOL)initLibraryWithSN:(NSString*)sn key:(NSString*)key
{
    enum FS_ERRORCODE eRet = [FSLibrary init:sn key:key];
    if (e_errSuccess != eRet) {
        NSString* errMsg = [NSString stringWithFormat:@"Invalid license"];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Check License" message:errMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    [FSLibrary registerDefaultSignatureHandler];
    return YES;
}

- (void)closePDF
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGFloat w = self.webView.bounds.size.width;
        self.pdfView.center = CGPointMake(self.pdfView.center.x + w, self.pdfView.center.y);
        self.navBar.center = CGPointMake(self.navBar.center.x + w, self.navBar.center.y);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.pdfView removeFromSuperview];
            [self.navBar removeFromSuperview];
        }
    }];
}


@end
