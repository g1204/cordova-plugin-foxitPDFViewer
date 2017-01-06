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
@property (nonatomic, assign) BOOL shouldLoadExtensions;
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
            self.extensionsManager = [[UIExtensionsManager alloc] initWithPDFViewControl:self.pdfView];
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
            [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            self.navBar.shadowImage = [UIImage new];
            self.navBar.translucent = YES;
            
            UINavigationItem* navItem = [UINavigationItem new];
            self.navBar.items = @[navItem];
            navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close)];
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

- (void)close:(CDVInvokedUrlCommand*)command
{
    [self close];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void)getPageCount:(CDVInvokedUrlCommand*)command
{
    if (self.pdfView && self.pdfView.getDoc) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[self.pdfView getPageCount]] callbackId:command.callbackId];
        ;
    } else {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Not initialized"] callbackId:command.callbackId];
    }
}

- (void)gotoPage:(CDVInvokedUrlCommand*)command
{
    if ([command.arguments count] > 0) {
        int pageIndex = [command.arguments[0] intValue];
        if (0 <= pageIndex && pageIndex < [self.pdfView getPageCount]) {
            [self.pdfView gotoPage:pageIndex animated:YES];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
            return;
        }
    }
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid parameter(s)"] callbackId:command.callbackId];
}

- (void)gotoNextPage:(CDVInvokedUrlCommand*)command
{
    [self.pdfView gotoNextPage:YES];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void)gotoPrevPage:(CDVInvokedUrlCommand*)command
{
    [self.pdfView gotoPrevPage:YES];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void)setPageLayoutMode:(CDVInvokedUrlCommand*)command
{
    if ([command.arguments count] > 0) {
        int viewMode = [command.arguments[0] intValue];
        switch (viewMode) {
            case 0:
                [self.pdfView setPageLayoutMode:PDF_LAYOUT_MODE_SINGLE];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
                return;
            case 1:
                [self.pdfView setPageLayoutMode:PDF_LAYOUT_MODE_CONTINUOUS];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
                return;
            case 2:
                [self.pdfView setPageLayoutMode:PDF_LAYOUT_MODE_MULTIPLE];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
                return;
            default:
                ;
        }
    }
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid parameter(s)"] callbackId:command.callbackId];
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

- (void)close
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
