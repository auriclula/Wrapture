//
// Util.m
//
// Copyright (c) 2019 Taner Sener
//
// This file is part of MobileFFmpeg.
//
// MobileFFmpeg is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// MobileFFmpeg is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with MobileFFmpeg.  If not, see <http://www.gnu.org/licenses/>.
//

#import "Util.h"

@implementation Util

+ (void)applyButtonStyle: (UIButton*) button {
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithDisplayP3Red:10.0/256 green:138.0/256 blue:65.0/256 alpha:1.0] forState:UIControlStateFocused];
    [button setTitleColor:[UIColor colorWithDisplayP3Red:10.0/256 green:138.0/256 blue:65.0/256 alpha:1.0] forState:UIControlStateHighlighted];
    button.layer.backgroundColor = [UIColor colorWithDisplayP3Red:46.0/256 green:204.0/256 blue:113.0/256 alpha:1.0].CGColor;
    button.layer.borderWidth = 0.0f;
    button.layer.borderColor = [UIColor clearColor].CGColor;
    button.layer.cornerRadius = 5.0f;
}

+ (void)applyEditTextStyle: (UITextField*) textField {
    textField.layer.backgroundColor = [UIColor colorWithDisplayP3Red:236.0/256 green:240.0/256 blue:241.0/256 alpha:1.0].CGColor;
    textField.layer.borderWidth = 0.0f;
    textField.layer.borderColor = [UIColor clearColor].CGColor;
    textField.layer.cornerRadius = 5.0f;
}

+ (void)applyHeaderStyle: (UILabel*) label {
    label.layer.borderWidth = 1.0f;
    label.layer.borderColor = [UIColor colorWithDisplayP3Red:231.0/256 green:76.0/256 blue:60.0/256 alpha:1.0].CGColor;
    label.layer.cornerRadius = 5.0f;
}

+ (void)applyOutputTextStyle: (UITextView*) textView {
    textView.layer.backgroundColor = [UIColor colorWithDisplayP3Red:241.0/256 green:196.0/256 blue:15.0/256 alpha:1.0].CGColor;
    textView.layer.borderWidth = 1.0f;
    textView.layer.borderColor = [UIColor colorWithDisplayP3Red:243.0/256 green:156.0/256 blue:18.0/256 alpha:1.0].CGColor;
    textView.layer.cornerRadius = 5.0f;
}

+ (void)applyVideoPlayerFrameStyle: (UILabel*) playerFrame {
    playerFrame.layer.backgroundColor = [UIColor colorWithDisplayP3Red:236.0/256 green:240.0/256 blue:241.0/256 alpha:1.0].CGColor;
    playerFrame.layer.borderWidth = 1.0f;
    playerFrame.layer.borderColor = [UIColor colorWithDisplayP3Red:185.0/256 green:195.0/256 blue:199.0/256 alpha:1.0].CGColor;
    playerFrame.layer.cornerRadius = 5.0f;
}

+ (void)alert: (UIViewController*)controller withTitle:(NSString*)title message:(NSString*)message andButtonText:(NSString*)buttonText {
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction
                                    actionWithTitle:buttonText style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage*)resizedImageToSize:(UIImage *)image size:(CGSize)dstSize
{
    CGImageRef imgRef = image.CGImage;
    // the below values are regardless of orientation : for UIImages from Camera, width>height (landscape)
    CGSize  srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which is dependant on the imageOrientation)!
    
    /* Don't resize if we already meet the required destination size. */
    if (CGSizeEqualToSize(srcSize, dstSize)) {
        return image;
    }
    
    CGFloat scaleRatio = dstSize.width / srcSize.width;
    
    // Handle orientation problem of UIImage
    UIImageOrientation orient = image.imageOrientation;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(srcSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(srcSize.width, srcSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, srcSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeTranslation(srcSize.height, srcSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeTranslation(0.0, srcSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeTranslation(srcSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    /////////////////////////////////////////////////////////////////////////////
    // The actual resize: draw the image on a new context, applying a transform matrix
    UIGraphicsBeginImageContextWithOptions(dstSize, NO, image.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!context) {
        return nil;
    }
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -srcSize.height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -srcSize.height);
    }
    
    CGContextConcatCTM(context, transform);
    
    // we use srcSize (and not dstSize) as the size to specify is in user space (and we use the CTM to apply a scaleRatio)
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, srcSize.width, srcSize.height), imgRef);
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end

/*
 
ffmpeg -i https://mediastream.its.txstate.edu/streaming/_definst_/mp4:TexasStateUniversity/SRS/MarkErickson-me02/TL-Ks5uQakq1kindRzCBfj8kA-TL.mp4/playlist.m3u8 -ss 00:00:04.000 -f image2 -vframes 1 yosemite.png
 
 other linker flags:
    -Wl,-no_compact_unwind  // disables @try @catch blocks
 
 */
