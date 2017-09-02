//
//  UIImage+Resize.h
//  BaseCode
//
//  Created by jenish on 02/09/17.
//  Copyright © 2012 jenish. All rights reserved.

/*!
 @header        UIImage+Resize.h
 
 @brief         UIImage+Resize.h extends UIImage and Provides methods for resizing of UIImage
 
 @author        jenish
 
 @copyright     jenish
 
 @version       1.01
 */


#import <UIKit/UIKit.h>

@interface UIImage (Resize)
-(UIImage *) E_resizeImage:(CGSize)size;
-(UIImage *) E_resizeImage;

@end
