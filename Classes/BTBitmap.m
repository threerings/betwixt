//
// Betwixt - Copyright 2012 Three Rings Design

// Adapted from https://github.com/PaulSolt/UIImage-Conversion

/*
 * The MIT License
 *
 * Copyright (c) 2011 Paul Solt, PaulSolt@gmail.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "BTBitmap.h"

static const CGImageAlphaInfo ALPHA_INFO = kCGImageAlphaPremultipliedFirst;
static const uint32_t IMG_BYTE_ORDER = kCGBitmapByteOrder32Big;

static NSData* convertUIImageToBitmapRGBA8(UIImage* image) {
	CGImageRef imageRef = image.CGImage;

	// Create a bitmap context to draw the uiimage into
	static const size_t bitsPerPixel = 32;
	static const size_t bitsPerComponent = 8;
	static const size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;

	size_t width = CGImageGetWidth(imageRef);
	size_t height = CGImageGetHeight(imageRef);

	size_t bytesPerRow = width * bytesPerPixel;

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

	if(!colorSpace) {
		NSLog(@"Error allocating color space RGB\n");
		return NULL;
	}

	// Create bitmap context
	CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 IMG_BYTE_ORDER | ALPHA_INFO);	// ARGB

	if(!context) {
		NSLog(@"Bitmap context not created");
	}

	CGColorSpaceRelease(colorSpace);

	// Draw image into the context to get the raw image data
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);

	// Get a pointer to the data
	unsigned char* bitmapData = (unsigned char*)CGBitmapContextGetData(context);

	// Copy the data
    size_t totalBytes = sizeof(unsigned char) * bytesPerRow * height;
    NSData* data = [NSData dataWithBytes:bitmapData length:totalBytes];
	CGContextRelease(context);

	return data;
}

@implementation BTBitmap

@synthesize width = _width;
@synthesize height = _height;

- (id)initWithData:(NSData*)data width:(NSUInteger)width height:(NSUInteger)height {
    if ((self = [super init])) {
        NSAssert(data.length == width * height * 4, @"bad data length (expected=%d, actual=%d)", width * height * 4, data.length);
        _data = data;
        _width = width;
        _height = height;
    }
    return self;
}

- (id)initWithUIImage:(UIImage*)image {
    return [self initWithData:convertUIImageToBitmapRGBA8(image)
                        width:ceilf(image.size.width * image.scale)
                       height:ceilf(image.size.height * image.scale)];
}

- (uint32_t*)pixels {
    return (uint32_t*)_data.bytes;
}

- (uint32_t)pixelAtX:(NSUInteger)x y:(NSUInteger)y {
    NSAssert(x < _width && y < _height, @"Pixel location out of bounds (%d,%d)", x, y);
    return ((uint32_t*)_data.bytes)[(y * _width) + x];
}

- (UIImage*)createUIImage {
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, _data.bytes, _data.length, NULL);
	size_t bitsPerComponent = 8;
	size_t bitsPerPixel = 32;
	size_t bytesPerRow = 4 * _width;

	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	if(colorSpaceRef == NULL) {
		NSLog(@"Error allocating color space");
		CGDataProviderRelease(provider);
		return nil;
	}
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | ALPHA_INFO;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;

	CGImageRef iref = CGImageCreate(_width,
									_height,
									bitsPerComponent,
									bitsPerPixel,
									bytesPerRow,
									colorSpaceRef,
									bitmapInfo,
									provider,	// data provider
									NULL,		// decode
									YES,			// should interpolate
									renderingIntent);

	CGContextRef context = CGBitmapContextCreate(NULL,
												 _width,
												 _height,
												 bitsPerComponent,
												 bytesPerRow,
												 colorSpaceRef,
                                                 bitmapInfo);

	UIImage* image = nil;
	if(context) {
		CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, _width, _height), iref);

		CGImageRef imageRef = CGBitmapContextCreateImage(context);

		// Support both iPad 3.2 and iPhone 4 Retina displays with the correct scale
		if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
			float scale = [[UIScreen mainScreen] scale];
			image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
		} else {
			image = [UIImage imageWithCGImage:imageRef];
		}

		CGImageRelease(imageRef);
		CGContextRelease(context);
	}

	CGColorSpaceRelease(colorSpaceRef);
	CGImageRelease(iref);
	CGDataProviderRelease(provider);
    
	return image;
}

@end
