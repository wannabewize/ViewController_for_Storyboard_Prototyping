//
//  MKMapView+Prototype.m
//  MapView
//
//  Created by wannabewize on 2014. 11. 7..
//  Copyright (c) 2014년 VanillaStep. All rights reserved.
//

#import "MKMapView+Prototype.h"
#import <objc/runtime.h>

@implementation MKMapView (StoryboardPrototype)

-(void)setSpotListFile:(NSString *)spotListFile {
  NSString *filePath = [[NSBundle mainBundle] pathForResource:spotListFile ofType:@"plist"];
  NSArray *spotList = [NSArray arrayWithContentsOfFile:filePath];
  
  for (NSDictionary *spot in spotList) {
    NSString *latStr = [spot[@"latitude"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lngStr = [spot[@"longitude"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    float latitude = [latStr floatValue];
    float longitude	 = [lngStr floatValue];
    NSString *title = spot[@"title"];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    annotation.title = title;
    
    [self addAnnotation:annotation];
  }
}

-(NSString *)spotListFile {
  return nil;
}

@end
