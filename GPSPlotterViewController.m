//
//  GPSPlotterViewController.m
//  fishFind
//
//  Created by ioschen on 13-11-1.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import "GPSPlotterViewController.h"
@interface GPSPlotterViewController ()

@end

@implementation GPSPlotterViewController
@synthesize points = _points;
@synthesize mapView = _mapView;
@synthesize routeLine = _routeLine;
@synthesize routeLineView = _routeLineView;
@synthesize locationManager = _locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // setup map view
    //self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-88)];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userInteractionEnabled = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    [self.view addSubview:self.mapView];
    
    // configure location manager
    // [self configureLocationManager];
    [self configureRoutes];
    
    [self CGRectShow];
    //比例尺
    levelLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height-138, 80, 20)];
    levelLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:levelLabel];
    
    //------------------
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 0.5;//按0.5秒响应longPress方法
    //lpress.allowableMovement = 10.0;//允许10秒中运动
    lpress.allowableMovement=NO;
    //不需要代理
    //lpress.numberOfTouchesRequired=1;//所需触摸1次
    [self.mapView addGestureRecognizer:lpress];//self.mapView是MKMapView的实例
    
    //----------
//    CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(21.484137685, 120.371875243);
//    CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(31.484044745, 110.371879653);
//    MKMapPoint points[2];
//    points[0] = MKMapPointForCoordinate(coord1);
//    points[1] = MKMapPointForCoordinate(coord2);
//    MKPolyline *line = [MKPolyline polylineWithPoints:points count:2];
//    [self.mapView addOverlay: line];
    //-----------
    
    //pointAnnotation放在这边可以只创建一次,放下边初始化可以多个
    pointAnnotation=nil;
    pointAnnotation=[[MKPointAnnotation alloc]init];
}
//长按事件的实现方法
- (void)longPress:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        //坐标转换
        touchPoint = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate =
        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        pointAnnotation.coordinate=touchMapCoordinate;
        pointAnnotation.title=@"名字";
        
        //    NSString* latt =[NSString stringWithFormat:@"%f",touchMapCoordinate.latitude];//get latitude
        //    NSString *lonn =[NSString stringWithFormat:@"%f",touchMapCoordinate.longitude];
        //    //pointAnnotation.coordinate.latitude
        //    NSLog(@"%@坐标转换%@",latt,lonn);
        
        [self.mapView addAnnotation:pointAnnotation];
        
        
        //-----------
        //判断当前定位没，有无loc。但是如果没有定位，也用不起来了，玩不转china
        CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(pointAnnotation.coordinate.latitude, pointAnnotation.coordinate.longitude);
        CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(27.33446146,-122.04380955);
        MKMapPoint points[2];
        points[0] = MKMapPointForCoordinate(coord1);
        points[1] = MKMapPointForCoordinate(coord2);
        MKPolyline *line = [MKPolyline polylineWithPoints:points count:2];
        [self.mapView addOverlay: line];
        //----------
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        //NSLog(@"UIGestureRecognizerStateChanged");
    }
    /////////
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        return;
        //NSLog(@"UIGestureRecognizerStateEnded");
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];//导航栏右边回到当前位置的按钮可用
        return nil;
        
//        MKPolylineView *lineview=[[MKPolylineView alloc] initWithOverlay:overlay];
//        lineview.strokeColor=[[UIColor blueColor] colorWithAlphaComponent:0.5];
//        lineview.lineWidth=2.0;
//        return lineview;
    }
    
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKPinAnnotationView* customPinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (!customPinView) {
        customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        
        customPinView.pinColor=MKPinAnnotationColorRed;//设置大头针的颜色
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        customPinView.draggable = YES;//可以拖动
        
        //添加tips上的按钮
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
    }else{
        customPinView.annotation = annotation;
    }
    return customPinView;
    
}
- (void)showDetails:(UIButton*)sender
{
    NSLog(@"f");//点击选定的地址显示详细信息
}

#pragma mark - 获得比例尺级别
#define MERCATOR_RADIUS 85445659.44705395

- (int)getZoomLevel:(MKMapView*)YumapView
{
    return 21-round(log2(YumapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * YumapView.bounds.size.width)));
}
//我们可以写一个MKMapView的委托方法打印出zoom level
- (void)mapView:(MKMapView *)YumapView regionDidChangeAnimated:(BOOL)animated
{
    //NSLog(@"zoom level %d", [self getZoomLevel:_mapView]);
    levelLabel.text=[NSString stringWithFormat:@"比例:%d",[self getZoomLevel:YumapView]];
}

#pragma mark 画显示
-(void)CGRectShow
{
    CGRect rect=CGRectMake(0, self.view.frame.size.height-88, 320, 20);
    UILabel *showLabel=[[UILabel alloc]initWithFrame:rect];
    showLabel.text=@"经度:  方位:";
    [self.view addSubview:showLabel];

    CGRect rectHeight=CGRectMake(0, self.view.frame.size.height-68, 320, 20);
    UILabel *showLabelHeight=[[UILabel alloc]initWithFrame:rectHeight];
    showLabelHeight.text=@"经度:  行程:";
    [self.view addSubview:showLabelHeight];
    
    /*
     当前经度纬度
     偏离 --  表示当前点与最短直线间的距离
     速度 --  指当前运动的速度
     最大 --  指记录的最大速度
     距离 --  指当前点与目的地的直线距离
     时间 --  指已经运动的时间记录
     到达 --  指根据《距离/速度》得出的时间
     轨迹 --  指当前轨迹的角度
     方位 --  指目的地与当前点的角度 

     */
}

//地图自动缩放。用于在设置过MapAnnotation地标后，执行次函数，就会自动的缩放地图到合适的大小。
//- (void)zoomToFitMapAnnotations:(MKMapView*)inMapView
//{
//    NSLog(@"自动调节大小，假的");
//}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.mapView = nil;
	self.routeLine = nil;
	self.routeLineView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark
#pragma mark Map View

- (void)configureRoutes
{
    // define minimum, maximum points
	MKMapPoint northEastPoint = MKMapPointMake(0.f, 0.f);
	MKMapPoint southWestPoint = MKMapPointMake(0.f, 0.f);
	
	// create a c array of points.
	MKMapPoint* pointArray = malloc(sizeof(CLLocationCoordinate2D) * _points.count);
    
	// for(int idx = 0; idx < pointStrings.count; idx++)
    for(int idx = 0; idx < _points.count; idx++)
	{
        CLLocation *location = [_points objectAtIndex:idx];
        CLLocationDegrees latitude  = location.coordinate.latitude;
		CLLocationDegrees longitude = location.coordinate.longitude;
        
		// create our coordinate and add it to the correct spot in the array
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
		MKMapPoint point = MKMapPointForCoordinate(coordinate);
		
		// if it is the first point, just use them, since we have nothing to compare to yet.
		if (idx == 0) {
			northEastPoint = point;
			southWestPoint = point;
		} else {
			if (point.x > northEastPoint.x)
				northEastPoint.x = point.x;
			if(point.y > northEastPoint.y)
				northEastPoint.y = point.y;
			if (point.x < southWestPoint.x)
				southWestPoint.x = point.x;
			if (point.y < southWestPoint.y)
				southWestPoint.y = point.y;
		}
        
		pointArray[idx] = point;
	}
	
    if (self.routeLine) {
        [self.mapView removeOverlay:self.routeLine];
    }
    
    self.routeLine = [MKPolyline polylineWithPoints:pointArray count:_points.count];
    
    // add the overlay to the map
	if (nil != self.routeLine) {
		[self.mapView addOverlay:self.routeLine];
	}
    
    // clear the memory allocated earlier for the points
	free(pointArray);
    
    /*
     double width = northEastPoint.x - southWestPoint.x;
     double height = northEastPoint.y - southWestPoint.y;
     
     _routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, width, height);
     
     // zoom in on the route.
     [self.mapView setVisibleMapRect:_routeRect];
     */
}

/*
 #pragma mark
 #pragma mark Location Manager
 
 - (void)configureLocationManager
 {
 // Create the location manager if this object does not already have one.
 if (nil == _locationManager)
 _locationManager = [[CLLocationManager alloc] init];
 
 _locationManager.delegate = self;
 _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
 _locationManager.distanceFilter = 50;
 [_locationManager startUpdatingLocation];
 // [_locationManager startMonitoringSignificantLocationChanges];
 }
 
 #pragma mark
 #pragma mark CLLocationManager delegate methods
 - (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
 {
 NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
 
 // If it's a relatively recent event, turn off updates to save power
 NSDate* eventDate = newLocation.timestamp;
 NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
 
 if (abs(howRecent) < 2.0)
 {
 NSLog(@"recent: %g", abs(howRecent));
 NSLog(@"latitude %+.6f, longitude %+.6f\n", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
 }
 
 // else skip the event and process the next one
 }
 
 - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
 {
 NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
 NSLog(@"error: %@",error);
 }
 */

#pragma mark
#pragma mark MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    NSLog(@"overlayViews: %@", overlayViews);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    
	MKOverlayView* overlayView = nil;
	
	if(overlay == self.routeLine)
	{
		//if we have not yet created an overlay view for this overlay, create it now.
        if (self.routeLineView) {
            [self.routeLineView removeFromSuperview];
        }
        
        self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
        self.routeLineView.fillColor = [UIColor redColor];
        self.routeLineView.strokeColor = [UIColor redColor];
        self.routeLineView.lineWidth = 10;
        
		overlayView = self.routeLineView;
	}
	
	return overlayView;
}

/*
 - (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
 {
 NSLog(@"mapViewWillStartLoadingMap:(MKMapView *)mapView");
 }
 
 - (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
 {
 NSLog(@"mapViewDidFinishLoadingMap:(MKMapView *)mapView");
 }
 
 - (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
 {
 NSLog(@"mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error");
 }
 
 - (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
 {
 NSLog(@"mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated");
 NSLog(@"%f, %f", mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
 }
 
 - (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
 {
 NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
 NSLog(@"centerCoordinate: %f, %f", mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
 }
 */

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    NSLog(@"annotation views: %@", views);
}

/*
 - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
 {
 NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
 }
 
 - (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
 {
 NSLog(@"mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated");
 }
 
 - (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
 {
 NSLog(@"mapViewWillStartLocatingUser:(MKMapView *)mapView");
 }
 
 - (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
 {
 NSLog(@"mapViewDidStopLocatingUser:(MKMapView *)mapView");
 }
 */


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //NSLog(@"当前经度%f   %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude
                                                      longitude:userLocation.coordinate.longitude];
    
    // check the zero point
    if  (userLocation.coordinate.latitude == 0.0f ||
         userLocation.coordinate.longitude == 0.0f)
        return;
    
    // check the move distance
    if (_points.count > 0) {
        CLLocationDistance distance = [location distanceFromLocation:_currentLocation];
        if (distance < 5)
            return;
    }
    
    if (nil == _points) {
        _points = [[NSMutableArray alloc] init];
    }
    
    [_points addObject:location];
    _currentLocation = location;
    
    NSLog(@"points: %@", _points);
    
    [self configureRoutes];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    [self.mapView setCenterCoordinate:coordinate animated:YES];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code]==kCLErrorDenied) {
        NSLog(@"alert 请打开gps");
    }
}
    
@end