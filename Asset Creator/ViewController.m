//
//  ViewController.m
//  Asset Creator
//
//  Created by Anthony Agatiello on 12/30/16.
//  Copyright © 2016 Anthony Agatiello. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (IBAction)browseForFile:(NSButton *)button {
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    
    if ([openDlg runModal] == NSModalResponseOK) {
        for(NSURL *URL in [openDlg URLs]) {
            [self.filePathTextField setStringValue:[URL path]];
        }
    }
}

- (IBAction)exportButtonPushed:(NSButton *)button {
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    
    NSAlert *deviceAlert = [[NSAlert alloc] init];
    [deviceAlert setMessageText:@"Please Select a Device..."];
    [deviceAlert setInformativeText:@"In order to properly export your assets, please select which platform you would like your assets for."];
    [deviceAlert addButtonWithTitle:@"Mac"];
    [deviceAlert addButtonWithTitle:@"iPhone"];
    
    NSModalResponse buttonReturn = [deviceAlert runModal];
    
    if ([openDlg runModal] == NSModalResponseOK) {
        for (NSURL *URL in [openDlg URLs]) {
            if (buttonReturn == NSAlertFirstButtonReturn) {
                NSAlert *macConfirmAlert = [[NSAlert alloc] init];
                [macConfirmAlert setMessageText:@"Confirmation"];
                [macConfirmAlert setInformativeText:@"The icon sizes for Cocoa applications are: 1024, 512, 256, 128, 64, 32, and 16 pixels. Press \"Continue\" to proceed or \"Cancel\" to go back."];
                [macConfirmAlert addButtonWithTitle:@"Continue"];
                [macConfirmAlert addButtonWithTitle:@"Cancel"];
                
                NSModalResponse macButtonReturn = [macConfirmAlert runModal];
                
                if (macButtonReturn == NSAlertFirstButtonReturn) {
                    [self saveImageWithSize:1024 atURL:URL];
                    [self saveImageWithSize:512 atURL:URL];
                    [self saveImageWithSize:256 atURL:URL];
                    [self saveImageWithSize:128 atURL:URL];
                    [self saveImageWithSize:64 atURL:URL];
                    [self saveImageWithSize:32 atURL:URL];
                    [self saveImageWithSize:16 atURL:URL];
                }
            }
            
            else {
                NSAlert *iOSConfirmAlert = [[NSAlert alloc] init];
                [iOSConfirmAlert setMessageText:@"Confirmation"];
                [iOSConfirmAlert setInformativeText:@"The icon sizes for iOS applications are: 180, 167, 152, 120, 87, 80, 76, 60, 58, 40, 29, and 20 pixels. Press \"Continue\" to proceed or \"Cancel\" to go back."];
                [iOSConfirmAlert addButtonWithTitle:@"Continue"];
                [iOSConfirmAlert addButtonWithTitle:@"Cancel"];
                
                NSModalResponse iOSButtonReturn = [iOSConfirmAlert runModal];
                
                if (iOSButtonReturn == NSAlertFirstButtonReturn) {
                    [self saveImageWithSize:180 atURL:URL];
                    [self saveImageWithSize:167 atURL:URL];
                    [self saveImageWithSize:152 atURL:URL];
                    [self saveImageWithSize:120 atURL:URL];
                    [self saveImageWithSize:87 atURL:URL];
                    [self saveImageWithSize:80 atURL:URL];
                    [self saveImageWithSize:76 atURL:URL];
                    [self saveImageWithSize:60 atURL:URL];
                    [self saveImageWithSize:58 atURL:URL];
                    [self saveImageWithSize:40 atURL:URL];
                    [self saveImageWithSize:29 atURL:URL];
                    [self saveImageWithSize:20 atURL:URL];
                }
            }
        }
    }
}

- (void)saveImageWithSize:(CGFloat)size atURL:(NSURL *)url {
    NSImage *oldImage = [[NSImage alloc] initWithContentsOfFile:self.filePathTextField.stringValue];
    NSImage *newImage = [self resizeImage:oldImage size:NSMakeSize(size / 2, size / 2)];
    CGImageRef cgRef = [newImage CGImageForProposedRect:NULL context:nil hints:nil];
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:@{}];
    [pngData writeToFile:[NSString stringWithFormat:@"%@/AssetCreatorImage-%zux%zu.png", [url path], CGImageGetWidth(cgRef), CGImageGetHeight(cgRef)] atomically:YES];
}

- (NSImage *)resizeImage:(NSImage *)sourceImage size:(NSSize)size {
    NSRect targetFrame = NSMakeRect(0, 0, size.width, size.height);
    NSImage *targetImage = nil;
    NSImageRep *sourceImageRep = [sourceImage bestRepresentationForRect:targetFrame context:nil hints:nil];
    
    targetImage = [[NSImage alloc] initWithSize:size];
    
    [targetImage lockFocus];
    [sourceImageRep drawInRect: targetFrame];
    [targetImage unlockFocus];
    
    return targetImage;
}

@end
