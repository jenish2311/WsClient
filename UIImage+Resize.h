//
//  UIImage+Resize.h
//  BaseCode
//
//  Created by Mac33 on 30/09/15.
//  Copyright © 2015 E2logy. All rights reserved.

/*!
 @header        UIImage+Resize.h
 
 @brief         UIImage+Resize.h extends UIImage and Provides methods for resizing of UIImage
 
 @author        iPlus by Fermax
 
 @copyright     Fermax Asia Pacific Pte Ltd
 
 @version       1.01
 */


#import <UIKit/UIKit.h>

@interface UIImage (Resize)
-(UIImage *) E_resizeImage:(CGSize)size;
-(UIImage *) E_resizeImage;

@end
