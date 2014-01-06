//
//  GPSNavigateViewController.m
//  fishFind
//
//  Created by ioschen on 13-11-5.
//  Copyright (c) 2013年 ioschen. All rights reserved.
//

#import "GPSNavigateViewController.h"
#import "NewPositionViewController.h"
#import "FindPositionViewController.h"
#import "NewPathViewController.h"
#import "FindPathViewController.h"
#import "MenuViewController.h"
@interface GPSNavigateViewController ()

@end

@implementation GPSNavigateViewController
//=======
@synthesize points = _points;
@synthesize routeLine = _routeLine;
@synthesize routeLineView = _routeLineView;
//-----
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
	// Do any additional setup after loading the view.
    
    map=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    map.delegate=self;
    map.showsUserLocation=YES;
    map.userInteractionEnabled=YES;
    map.userTrackingMode = MKUserTrackingModeFollowWithHeading;//big
    [self.view addSubview:map];
    
    locationManager=[[CLLocationManager alloc]init];
    [locationManager setDelegate:self];
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;//默认
    //locationManager.distanceFilter=1000.0f;//当前精确度级别
    
    //-----------------
//    [locationManager startUpdatingLocation];
//    MKCoordinateSpan theSpan;
//    theSpan.latitudeDelta=0.03;
//    theSpan.longitudeDelta=0.03;
//    MKCoordinateRegion theRegion={ {0.0, 0.0 }, { 0.0, 0.0 } };
//    theRegion.center=locationManager.location.coordinate;
//    theRegion.span=theSpan; //设置扩展区域，利用精度调整范围
//    [map setRegion:theRegion animated:YES];
//    //5个点初始化
//    CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
//    CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude+0.01, locationManager.location.coordinate.longitude);
//    CLLocationCoordinate2D coord3 = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude+0.01, locationManager.location.coordinate.longitude+0.01);
//    CLLocationCoordinate2D coord4 = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude+0.01);
//    CLLocationCoordinate2D coord5 = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
//    //这里很重要，points[5]是一个C数组，NSArray是不能把CLLocationCoordinate2D存储在其中的
//    CLLocationCoordinate2D points[5];
//    //把点传入数组
//    points[0] = coord1;
//    points[1] = coord2;
//    points[2] = coord3;
//    points[3] = coord4;
//    points[4] = coord5;
//    //根据点的数组创建一个MKPolyline，并添加这个line作为overlay（可以添加很多overlay，堆栈形式）
//    MKPolyline *line2 = [MKPolyline polylineWithCoordinates:points count:5];
//    [map addOverlay: line2];
    CLLocationCoordinate2D coord1=CLLocationCoordinate2DMake(37.33446146,-122.04380955);
    CLLocationCoordinate2D coord2=CLLocationCoordinate2DMake(27.33446146,-122.04380955);
     
    MKMapPoint points[2];
    points[0] = MKMapPointForCoordinate(coord1);
    points[1] = MKMapPointForCoordinate(coord2);
    MKPolyline *line2 = [MKPolyline polylineWithPoints:points count:2];
    [map addOverlay: line2];
    //----------------
    
    //[locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    //[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];//最精确，最耗电
    
    timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    //如果是NO则timer在触发了回调函数调用完成之后会释放timer，如果是YES，则会重复调用函数
    
//    [self CGRectShow];
    
    
    //------------------
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 0.5;//按0.5秒响应longPress方法
    //lpress.allowableMovement = 10.0;//允许10秒中运动
    lpress.allowableMovement=NO;
    //不需要代理
    //lpress.numberOfTouchesRequired=1;//所需触摸1次
    [map addGestureRecognizer:lpress];//self.mapView是MKMapView的实例
    
    //pointAnnotation放在这边可以只创建一次,放下边初始化可以多个
    pointAnnotation=nil;
    pointAnnotation=[[MKPointAnnotation alloc]init];
    
    
    [self configureRoutes];////////////////
    ///////////////
    [self CGRectShow];
    [self CGRectButton];
    
    [self makeSaveButton];//这个到底应该在什么时候执行呢啊
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [locationManager startUpdatingLocation];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [locationManager stopUpdatingLocation];
}
//--------------------tableview显示--------------
#pragma mark 画Button
-(void)CGRectButton
{
    
    UIButton *position=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [position setTitle:@"position" forState:UIControlStateNormal];
    position.backgroundColor=[UIColor redColor];
    position.frame=CGRectMake(0, self.view.frame.size.height-48, 80, 48);
    [position addTarget:self action:@selector(showpositionTable) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:position];
    
    UIButton *path=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [path setTitle:@"path" forState:UIControlStateNormal];
    path.backgroundColor=[UIColor redColor];
    path.frame=CGRectMake(80, self.view.frame.size.height-48, 80, 48);
    [path addTarget:self action:@selector(showpathTable) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:path];
    
    UIButton *menu=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [menu setTitle:@"menu" forState:UIControlStateNormal];
    menu.backgroundColor=[UIColor redColor];
    menu.frame=CGRectMake(160, self.view.frame.size.height-48, 80, 48);
    [menu addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menu];
    
    UIButton *back=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [back setTitle:@"back" forState:UIControlStateNormal];
    back.backgroundColor=[UIColor redColor];
    back.frame=CGRectMake(240, self.view.frame.size.height-48, 80, 48);
    [back addTarget:self action:@selector(backMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    [self makepathTable];
    [self makepositionTable];
}

#pragma mark 返回上一个页面
-(void)backMenu
{
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)showMenu
{
    MenuViewController *menu=[[MenuViewController alloc]init];
    [self presentViewController:menu animated:YES completion:nil];
}
-(void)makepositionTable
{
    positionTable=[[UITableView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-266, 135, 210) style:UITableViewStylePlain];
    //[self.view addSubview:positionTable];
    positionTable.delegate=self;
    positionTable.dataSource=self;
    positionArray=[[NSArray alloc]initWithObjects:@"创建新钓点",@"  快速保存", @"  当前位置",@"  游标位置",@"  手工输入",@"钓点查询",@"  按名字查找",@"  按距离查找",@"  按时间查找",nil];
    
    
    /*
     保存当前位置为钓点，名称为已有钓点个数加1（如Mark001,Mark002），属性为标记1；直接保存，加快保存速度
     
     
     */
}
-(void)showpositionTable
{
    [self.view addSubview:positionTable];
    
    //判断放在下面可以不需要判断有没有创建呢(这个肯定对，反之就不一定对)
    //不对，还是需要判断第一次
    if ([positionTable isHidden]) {
        [positionTable setHidden:NO];
    }else{
        [positionTable setHidden:YES];
    }
}
-(void)makepathTable
{
    pathTable=[[UITableView alloc]initWithFrame:CGRectMake(70, self.view.frame.size.height-266, 135, 210) style:UITableViewStylePlain];
    //[self.view addSubview:pathTable];
    pathTable.delegate=self;
    pathTable.dataSource=self;
    pathArray=[[NSArray alloc]initWithObjects:@"创建新路径",@"  当前路线", @"  按距离保存",@"  按时间保存",@"  按方位保存",@"路径查询",@"  按名字查询",@"  按距离查询",@"  按时间查询",nil];
}
-(void)showpathTable
{
    [self.view addSubview:pathTable];
    //可以判断，如果显示点击就是隐藏，反之。。。。但是点击其他地方怎么做需要客户
    if ([pathTable isHidden]) {
        [pathTable setHidden:NO];
    }else{
        [pathTable setHidden:YES];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==positionTable) {
        return [positionArray count];
    }else //if (tableView==pathTable)
    {
        return [pathArray count];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    if (indexPath.row==0||indexPath.row==5) {
        cell.textLabel.textColor=[UIColor redColor];
    }
    
    if (tableView==positionTable) {
        cell.textLabel.text=[positionArray objectAtIndex:indexPath.row];
    }else if (tableView==pathTable){
        cell.textLabel.text=[pathArray objectAtIndex:indexPath.row];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 23;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //这个也可以用group类型的，第一个标题设置header。但是现在要设置点击没有高亮效果
    if (tableView==positionTable) {
        NewPositionViewController *newposition=[[NewPositionViewController alloc]init];
        FindPositionViewController *findposition=[[FindPositionViewController alloc]init];
        if (indexPath.row==0||indexPath.row==5) {
            NSLog(@"点击了标题");
        }else{
            [positionTable setHidden:YES];
        }
        switch (indexPath.row) {
                //        case 0:
                //            NSLog(@"no");
                //            break;
            case 1:
                NSLog(@"将保存当前位置为钓点，名称为已有钓点个数加1（如Mark001,Mark002），属性为标记1不进入钓点详情页面，直接保存，加快保存速度");
                //快速保存
                break;
            case 2:
                
                [self presentModalViewController:newposition animated:YES];
                //还要判断有没有读取到经纬度，其实就是下面的GPS定位
                newposition.fwText.text=@"1";//真他妈尿性，必须写在Modal下面
                newposition.bwText.text=lon;
                newposition.djText.text=lat;
                newposition.hbText.text=alt;
                
                NSLog(@"将当前位置经纬度存为钓点，并进入钓点详情页面图-5操作");
                break;
            case 3:
                if (touchLat==nil ||touchLon==nil) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"你还没有取点，，不是没有GPS定位哦" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
                    [alert show];
                }else{
                    [self presentModalViewController:newposition animated:YES];
                    //触点位置，就是长按的位置
                    newposition.bwText.text=touchLat;
                    newposition.djText.text=touchLon;
                    NSLog(@"将游标位置经纬度存为钓点，并进入钓点详情页面图-5操作");
                }
                break;
            case 4:
                [self presentModalViewController:newposition animated:YES];
                //手工输入
                NSLog(@"直接进入钓点详情页面图-5操作，位置信息也要手工输入");
                break;
                //        case 5:
                //            NSLog(@"no");
                //            break;
            case 6:
                [self presentModalViewController:findposition animated:YES];
                findposition.sqlQueryTypetext.text=@"typeName";//按名字
                break;
            case 7:
                [self presentModalViewController:findposition animated:YES];
                findposition.sqlQueryTypetext.text=@"typeJuli";//按距离
                break;
            case 8:
                [self presentModalViewController:findposition animated:NO];
                findposition.sqlQueryTypetext.text=@"typeTime";//按时间
                break;
                
            default:
                break;
        }
    }else if (tableView==pathTable){
        NewPathViewController *newPath=[[NewPathViewController alloc]init];
        FindPathViewController *findPath=[[FindPathViewController alloc]init];
        if (indexPath.row==0||indexPath.row==5) {
            NSLog(@"点击了标题");
        }else{
            [pathTable setHidden:YES];
        }
        switch (indexPath.row) {
                //        case 0:
                //            NSLog(@"no");
                //            break;
            case 1:
                [self.view addSubview:saveButton];
                break;
            case 2:
                [self.view addSubview:saveButton];
                [self presentModalViewController:newPath animated:YES];
                newPath.danweiLable.text=@"米";//米以及下面的秒和速度都根据船员的需求设置
                break;
            case 3:
                [self.view addSubview:saveButton];
                [self presentModalViewController:newPath animated:YES];
                newPath.danweiLable.text=@"秒";
                break;
            case 4:
                [self.view addSubview:saveButton];
                [self presentModalViewController:newPath animated:YES];
                newPath.danweiLable.text=@"弧度";
                break;
                //        case 5:
                //            NSLog(@"no");
                //            break;
            case 6:
                [self presentModalViewController:findPath animated:YES];
                break;
            case 7:
                [self presentModalViewController:findPath animated:YES];
                break;
            case 8:
                [self presentModalViewController:findPath animated:YES];
                break;
                
            default:
                break;
        }
    }
}

-(void)makeSaveButton
{
    saveButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.frame=CGRectMake(80, self.view.frame.size.height-48, 80, 48);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(savePath) forControlEvents:UIControlEventTouchUpInside];
}
-(void)savePath
{
    NSLog(@"此方法需要修改，暂且这样");
    [saveButton removeFromSuperview];
}

//---------------下面的弹出tableview-------------



//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations//ios6方法
//{
//    CLLocation *currLocation=[locations lastObject];
//    lat =[NSString stringWithFormat:@"%3.5f",currLocation.coordinate.latitude];
//    lon =[NSString stringWithFormat:@"%3.5f",currLocation.coordinate.longitude];
//    alt =[NSString stringWithFormat:@"%3.5f",currLocation.altitude];
//    NSLog(@"经度%@ 纬度%@ 海拔%@",lat,lon,alt);
//    [self CGRectShow];
//}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    /*
     NSTimeInterval howRecent=[newLocation.timestamp timeIntervalSinceNow];
     if (newLocation.horizontalAccuracy>100) return;//精度>100米
     if (howRecent < -10)return;//离上次的更新时间少于10秒
     好像没用啊
     */
    
    //NSLog(@"%@",newLocation);
    loc = [newLocation coordinate];
    lat =[NSString stringWithFormat:@"%f",loc.latitude];//get latitude
    lon =[NSString stringWithFormat:@"%f",loc.longitude];//get longitude
    alt =[NSString stringWithFormat:@"%f",newLocation.altitude];
    //NSLog(@"经度%@ 纬度%@ 海拔%@",lat,lon,alt);//上面的1是1秒
    showLabel.text=[NSString stringWithFormat:@"经度:%@  海拔:%@",lat,alt];
    showLabelHeight.text=[NSString stringWithFormat:@"纬度:%@  方位:",lon];
    //    使用下面代码获取你的位移：
    //    CLLocationDistance distance = [fromLocation distanceFromLocation:toLocation];
}

-(void)saveLLA:(NSString *)latitude andLongitude:(NSString *)longitude andAltitude:(NSString *)altitude
{
    NSUserDefaults * settings=[NSUserDefaults standardUserDefaults];//定义一个对象进行初始化
    //[settings removeObjectForKey:@"UserName"];//移除键值为UseName和Password的对象
    //[settings removeObjectForKey:@"Password"];//防止数据混乱造成干扰
    [settings setObject:latitude forKey:@"UserName"];//重新设置键值信息
    [settings setObject:longitude forKey:@"Password"];
    [settings setObject:altitude forKey:@"Password"];
    NSLog(@"保存成功");
    //[settings synchronize];//将键值信息同步道本地
}

#pragma mark - 标记点,长按事件的实现方法
- (void)longPress:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        //坐标转换
        touchPoint = [gestureRecognizer locationInView:map];
        CLLocationCoordinate2D touchMapCoordinate =
        [map convertPoint:touchPoint toCoordinateFromView:map];//触点转换为经纬度
        
        //CLLocationDistance altitude=[map con];
        //[map convertPoint:touchPoint toCoordinateFromView:map];
        //风速CLLocationDirection course
        //速度CLLocationSpeed speed
        //http://www.daftlogic.com/sandbox-google-maps-find-altitude.htm
        
        
        pointAnnotation.coordinate=touchMapCoordinate;
        pointAnnotation.title=@"名字";
        
        touchLat=[NSString stringWithFormat:@"%f",touchMapCoordinate.latitude];
        touchLon=[NSString stringWithFormat:@"%f",touchMapCoordinate.longitude];
        //touchAlt=[NSString stringWithFormat:@"%f",touchMapCoordinate.latitude];
        
        [map addAnnotation:pointAnnotation];
        
        //判断当前定位没，有无loc。但是如果没有定位，也用不起来了，玩不转china
        CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(pointAnnotation.coordinate.latitude, pointAnnotation.coordinate.longitude);
        CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(loc.latitude, loc.longitude);
        MKMapPoint points[2];
        points[0] = MKMapPointForCoordinate(coord1);
        points[1] = MKMapPointForCoordinate(coord2);
        MKPolyline *line = [MKPolyline polylineWithPoints:points count:2];
        [map addOverlay: line];
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
    MKPinAnnotationView* customPinView = (MKPinAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
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

//-(void)Makeline
//{
//    CLLocationCoordinate2D coords;
//    CLLocationCoordinate2D pointsToUse[2];
//    coords.latitude = 27.334799;
//    coords.longitude = -112.034841;
//    pointsToUse[0] = coords;
//    coords.latitude = 37.335799;
//    coords.longitude = -122.032841;
//    pointsToUse[1] = coords;
//    MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:2];
//    [map addOverlay:lineOne];
//
//    
//    CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(37.349664, -122.104319);
//    CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(27.349664, -102.104319);
//    MKMapPoint points[2];
//    points[0] = MKMapPointForCoordinate(coord1);
//    points[1] = MKMapPointForCoordinate(coord2);
//    MKPolyline *line = [MKPolyline polylineWithPoints:points count:2];
//    [map addOverlay: line];
//}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        if (polylineView) {
            [polylineView removeFromSuperview];//只留一次;先清空上次
        }
        polylineView = [[MKPolylineView alloc]initWithOverlay:overlay];
        polylineView.fillColor=[[UIColor cyanColor]colorWithAlphaComponent:(CGFloat)0.2];
        //lineview.strokeColor=[[UIColor blueColor] colorWithAlphaComponent:0.5];
        polylineView.strokeColor=[[UIColor redColor]colorWithAlphaComponent:(CGFloat)1.0];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
//    return polylineView;
    //编译运行就OK了，但是没有填充色，lineview.fillColor= [UIColor redColor];这句话是没有作用的，看来MKPolylineView的功能还是不够，MKOverlayPathView应该才是我们应该用的
    
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

#pragma mark - 定时
- (void) handleTimer: (NSTimer *) timer // timer的回调函数
{
    //NSLog(@"经度%@ 纬度%@ 海拔%@",lat,lon,alt);//上面的1是1秒
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"no find location:%@",error);
    if ([error code]==kCLErrorDenied) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"no gps" message:@"place open gps" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
        [alert show];
        NSLog(@"alert 请打开gps");
    }
}

#pragma mark 画显示
-(void)CGRectShow
{
    CGRect rect=CGRectMake(0, self.view.frame.size.height-88, 320, 20);
    showLabel=[[UILabel alloc]initWithFrame:rect];
    [self.view addSubview:showLabel];
    
    CGRect rectHeight=CGRectMake(0, self.view.frame.size.height-68, 320, 20);
    showLabelHeight=[[UILabel alloc]initWithFrame:rectHeight];
    [self.view addSubview:showLabelHeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//画线
//glx
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//    MKMapView *mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-88)];
//    mapView.delegate = self;
//    mapView.showsUserLocation = YES;
//    mapView.userInteractionEnabled = YES;
//    mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
//    [self.view addSubview:mapView];
//    
//    CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(21.484137685, 120.371875243);
//    CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(31.484044745, 110.371879653);
//    MKMapPoint points[2];
//    points[0] = MKMapPointForCoordinate(coord1);
//    points[1] = MKMapPointForCoordinate(coord2);
//    MKPolyline *line = [MKPolyline polylineWithPoints:points count:2];
//    [mapView addOverlay: line];
//}
//
//
//- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
//{
//    if ([overlay isKindOfClass:[MKPolyline class]])
//    {
//        MKPolylineView *lineview=[[MKPolylineView alloc] initWithOverlay:overlay];
//        lineview.strokeColor=[[UIColor blueColor] colorWithAlphaComponent:0.5];
//        lineview.lineWidth=2.0;
//        return lineview;
//    }
//    MKPolylineView *lineview=[[MKPolylineView alloc] initWithOverlay:overlay];
//    lineview.strokeColor=[[UIColor blueColor] colorWithAlphaComponent:0.5];
//    lineview.lineWidth=2.0;
//    return lineview;
//}

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
        [map removeOverlay:self.routeLine];
    }
    self.routeLine = [MKPolyline polylineWithPoints:pointArray count:_points.count];
	if (nil != self.routeLine) {
		[map addOverlay:self.routeLine];
	}
	free(pointArray);
}
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
    [map setCenterCoordinate:coordinate animated:YES];
}

@end
