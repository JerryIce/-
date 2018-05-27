//
//  ViewController.m
//  TQ
//
//  Created by 杨宗维 on 2018/5/26.
//  Copyright © 2018年 Icecooll. All rights reserved.
//

#import "WeatherNowViewController.h"
#import "HmacSha1Tool.h"
#import "WeatherNowData.h"
#import "SetLocationVC.h"

@interface WeatherNowViewController ()
    //@property(nonatomic,retain) WeatherNowData*data;
    @property (weak, nonatomic) IBOutlet UILabel *lab_location;
    @property (weak, nonatomic) IBOutlet UILabel *lab_weatherDesc;
    @property (weak, nonatomic) IBOutlet UIImageView *imgV_pic;
    @property (weak, nonatomic) IBOutlet UILabel *lab_temp;
    @property (weak, nonatomic) IBOutlet UIProgressView *progress_tem;
    @property (weak, nonatomic) IBOutlet UILabel *lab_updateTime;
    @property (weak, nonatomic) IBOutlet UIButton *btn_change;
    
@end

@implementation WeatherNowViewController

    static NSString *TIANQI_NOW_WEATHER_URL = @"https://api.seniverse.com/v3/weather/now.json";         //天气实况 URL
    
    static NSString *TIANQI_API_SECRET_KEY = @"xkojmyi74gj0kjgi";   // YOUR API KEY
    static NSString *TIANQI_API_USER_ID = @"U0E4A68FBD";            // YOUR USER ID
    WeatherNowData*data;
    NSString*changedlocation;
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    changedlocation = [NSString stringWithFormat:@"上海"];
    [self refreshWeather];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    
    
    
-(void)setUp{
    
}
- (IBAction)changeLocation:(id)sender {
    
}
    -(IBAction)backFromSetLocation:(UIStoryboardSegue*)segue{
        if ([segue.identifier  isEqual: @"backFromSetLocationSegue"]){
            SetLocationVC *vc = segue.sourceViewController;
            changedlocation = vc.locationName;
            [self refreshWeather];
        }
    }
-(void)refreshWeather{
    [self getWeather];
}
- (void)getWeather{
    
    NSString *timestamp = [NSString stringWithFormat:@"%.0ld",time(NULL)];
    NSString *params = [NSString stringWithFormat:@"ts=%@&ttl=%@&uid=%@", timestamp, @30, TIANQI_API_USER_ID];
    NSString *signature =  [self getSigntureWithParams:params];
    NSString *placeName = changedlocation;
    NSString *placeNameUT = [placeName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *urlStr = [self fetchWeatherWithURL:TIANQI_NOW_WEATHER_URL //TIANQI_NOW_WEATHER_URL
                                             ttl:@30
                                        Location:placeNameUT//查询位置需要对汉字进行转码，不然会有地名重复
                                        language:@"zh-Hans"//zh-Hans 简体中文
                                            unit:@"c"//单位 当参数为c时，温度c、风速km/h、能见度km、气压mb;当参数为f时，温度f、风速mph、能见度mile、气压inch
                                           start:@"1"
                                            days:@"1"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSDictionary *dict = @{@"ts":timestamp,
//                           @"ttl":@30,
//                           @"uid":TIANQI_API_USER_ID,
//                           @"sig":signature,
//                           @"location":placeNameUT,
//                           @"language":@"zh-Hans",
//                           @"unit":@"c",
//                           @"start":@"1",
//                           @"days":@"1"
//                           };
    
    NSLog(@"%@", urlStr);
    //NSString* qianurl = [NSString stringWithFormat:@"%@",TIANQI_NOW_WEATHER_URL];
    //NSLog(qianurl);
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //progress
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //success
        //NSLog(task);
        NSLog(@"%@", responseObject);
        NSDictionary *dataResult = responseObject;
        NSArray *results = [dataResult objectForKey:@"results"];
        NSDictionary *array1= results[0];
        NSDictionary *locationInfo = [array1 objectForKey:@"location"];
        NSDictionary *nowInfo = [array1 objectForKey:@"now"];
        NSString *updateInfo = [array1 objectForKey:@"last_update"];
        
        NSString *locName = [locationInfo objectForKey:@"name"];
        NSString *locTem = [nowInfo objectForKey:@"temperature"];
        NSString *locPicCode = [nowInfo objectForKey:@"code"];
        NSString *locWeather = [nowInfo objectForKey:@"text"];
        
        data = [[WeatherNowData alloc]init];
        
        data.locationName = locName;
        data.temperature = locTem;
        data.picCode = locPicCode;
        data.weatherDesc = locWeather;
        data.updateTime = updateInfo;
        
        NSLog(@"%@", data);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateWeatherView];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //failure
        NSLog(@"%@", error.localizedDescription);
    }];
    
}
    -(void)updateWeatherView{
        _lab_location.text = data.locationName;
        _lab_temp.text = data.temperature;
        _lab_updateTime.text = data.updateTime;
        _lab_weatherDesc.text = data.weatherDesc;
        NSString *imageCode = data.picCode;
        _imgV_pic.image = [UIImage imageNamed:imageCode];
        float i = [data.temperature floatValue]/100;
        NSNumber *tem2 = [NSNumber numberWithFloat:i];
        NSLog(@"%@", tem2);
        [_progress_tem setProgress:[tem2 floatValue] animated:YES];
        
//        CABasicAnimation *moveProgress = [CABasicAnimation animationWithKeyPath:@"progress"];
//
//        moveProgress.fromValue = 0;
//        moveProgress.toValue = tem2;
//        moveProgress.duration = 3.0;
//
//        [_progress_tem.layer addAnimation:moveProgress forKey:nil];
//
    }
    
- (NSString *)getSigntureWithParams:(NSString *)params{
    NSString *signature = [HmacSha1Tool HmacSha1Key:TIANQI_API_SECRET_KEY data:params];
    return signature;
}
- (NSString *)fetchWeatherWithURL:(NSString *)url ttl:(NSNumber *)ttl Location:(NSString *)location
                         language:(NSString *)language unit:(NSString *)unit
                            start:(NSString *)start days:(NSString *)days{
    NSString *timestamp = [NSString stringWithFormat:@"%.0ld",time(NULL)];
    NSString *params = [NSString stringWithFormat:@"ts=%@&ttl=%@&uid=%@", timestamp, ttl, TIANQI_API_USER_ID];
    NSString *signature =  [self getSigntureWithParams:params];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@&sig=%@&location=%@&language=%@&unit=%@&start=%@&days=%@",
                        url, params, signature, location, language, unit, start, days];
    return urlStr;
}


@end
