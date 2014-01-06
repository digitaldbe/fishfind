//
//  GPSNavigateViewController.h
//  fishFind
//
//  Created by ioschen on 13-11-5.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
@interface GPSNavigateViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>

{
    CLLocationManager *locationManager;
    
    NSString *lon;
    NSString *lat;
    NSString *alt;
    
    NSString *touchLon;
    NSString *touchLat;
    NSString *touchAlt;
    
    CLLocationCoordinate2D loc;//当前点，定位的
    
    MKMapView* map;
    
    NSTimer *timer;
    
    CGPoint touchPoint;//长时间触摸点,
    MKPointAnnotation *pointAnnotation;//添加的长按点
    MKPolylineView* polylineView;//画线
    
    //--------
    // routes points
    NSMutableArray* _points;
    
	// the data representing the route points.
	MKPolyline* _routeLine;
	
	// the view we create for the line on the map
	MKPolylineView* _routeLineView;
	
	// the rect that bounds the loaded points
	MKMapRect _routeRect;
    // current location
    CLLocation* _currentLocation;
    
    
    UITableView *positionTable;//这四个是路径和钓点的
    NSArray *positionArray;
    
    UITableView *pathTable;
    NSArray *pathArray;
    
    
    UILabel *showLabel;//经度
    UILabel *showLabelHeight;//纬度
    
    UIButton *saveButton;
}
@property (nonatomic, retain) NSMutableArray* points;
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;

@end
