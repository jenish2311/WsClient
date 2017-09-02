//
//  UIImage+Resize.m
//  BaseCode
//
//  Created by jenish on 02/09/17.
//  Copyright © 2017 jenish. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)
-(UIImage *) E_resizeImage:(CGSize)size;
{
    UIImage *orginalImage = self;
	CGFloat actualHeight = orginalImage.size.height;
	CGFloat actualWidth = orginalImage.size.width;
	if(actualWidth <= size.width && actualHeight<=size.height)
	{
		return orginalImage;
	}
	float oldRatio = actualWidth/actualHeight;
	float newRatio = size.width/size.height;
	if(oldRatio < newRatio)
	{
		oldRatio = size.height/actualHeight;
		actualWidth = oldRatio * actualWidth;
		actualHeight = size.height;
	}
	else
	{
		oldRatio = size.width/actualWidth;
		actualHeight = oldRatio * actualHeight;
		actualWidth = size.width;
	}
	CGRect rect = CGRectMake(0.0,0.0,actualWidth,actualHeight);
	
    //UIGraphicsBeginImageContext(rect.size);
    
    
    
    //--------------------------- ## UIGraphicsBeginImageContextWithOptions ## --------------------
    
    /*
    size -    The size (measured in points) of the new bitmap context. This represents the size of the image returned by the UIGraphicsGetImageFromCurrentImageContext function. To get the size of the bitmap in pixels, you must multiply the width and height values by the value in the scale parameter.
    opaque -    A Boolean flag indicating whether the bitmap is opaque. If you know the bitmap is fully opaque, specify YES to ignore the alpha channel and optimize the bitmap’s storage. Specifying NO means that the bitmap must include an alpha channel to handle any partially transparent pixels.
    scale -    The scale factor to apply to the bitmap. If you specify a value of 0.0, the scale factor is set to the scale factor of the device’s main screen.
     */
    
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,0.0);
    
	[orginalImage drawInRect:rect];
	orginalImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return orginalImage;
}

-(UIImage *) E_resizeImage
{
    //New
    CGFloat maxSize = 1280.0f;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGFloat newWidth = width;
    CGFloat newHeight = height;
    //    CGFloat compression = 0.5f;
    // If any side exceeds the maximun size, reduce the greater side to 1200px and proportionately the other one
    
    if (width > maxSize || height > maxSize) {
        if (width > height) {
            newWidth = maxSize;
            newHeight = (height*maxSize)/width;
        } else {
            newHeight = maxSize;
            newWidth = (width*maxSize)/height;
        }
    }
    
    // Resize the image
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
