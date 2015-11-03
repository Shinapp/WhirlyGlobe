//
//  MapBoxVectorTestCase.m
//  AutoTester
//
//  Created by jmnavarro on 26/10/15.
//  Copyright © 2015 mousebird consulting. All rights reserved.
//

#import "MapBoxVectorTestCase.h"
#import "MaplyMapnikVectorTiles.h"
#import "MaplyViewController.h"
#import "GeographyClassTestCase.h"
@implementation MapBoxVectorTestCase


- (instancetype)init
{
	if (self = [super init]) {
		self.name = @"MapBox Vector";
		self.captureDelay = 5;
	}

	return self;
}

- (BOOL)setUpWithMap:(MaplyViewController *)mapVC
{
	GeographyClassTestCase *gctc = [[GeographyClassTestCase alloc]init];
	[gctc setUpWithMap:mapVC];
	// For network paging layers, where we'll store temp files
	NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)  objectAtIndex:0];
	NSString *thisCacheDir = nil;
	thisCacheDir = [NSString stringWithFormat:@"%@/mapbox-streets-vectiles",cacheDir];

	NSString *token = @"sk.eyJ1IjoiZG1hcnRpbnciLCJhIjoiY2lnYmViYmhiMDZmbWFha25kbHB3MWlkNyJ9.5VsRqKZvrTQ9ygnyI7fLoA";

	[MaplyMapnikVectorTiles StartRemoteVectorTilesWithTileSpec:@"http://a.tiles.mapbox.com/v4/mapbox.mapbox-streets-v4.json"
		accessToken:token
		style:[[NSBundle mainBundle] pathForResource:@"osm-bright" ofType:@"xml"]
		styleType:MapnikMapboxGLStyle
		cacheDir:thisCacheDir
		viewC:(MaplyBaseViewController*)mapVC
		success:^(MaplyMapnikVectorTiles * _Nonnull vecTiles) {
			// Now for the paging layer itself
			MaplyQuadPagingLayer *pageLayer = [[MaplyQuadPagingLayer alloc] initWithCoordSystem:[[MaplySphericalMercator alloc] initWebStandard] delegate:vecTiles];
			pageLayer.numSimultaneousFetches = 6;
			pageLayer.flipY = false;
			pageLayer.importance = 1024*1024*2;
			pageLayer.useTargetZoomLevel = true;
			pageLayer.singleLevelLoading = true;
			[mapVC addLayer:pageLayer];
			[mapVC animateToPosition:MaplyCoordinateMakeWithDegrees(-3.6704803, 40.50230) height:0.07 time:1.0];
		} failure:^(NSError * _Nonnull error) {
			NSLog(@"Failed to load Mapnik vector tiles because: %@",error);

		}];

	return true;
}

@end