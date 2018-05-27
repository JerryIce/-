//
//  WeatherNowData.m
//  TQ
//
//  Created by 杨宗维 on 2018/5/26.
//  Copyright © 2018年 Icecooll. All rights reserved.
//

#import "WeatherNowData.h"

@implementation WeatherNowData

-(NSString *)description{
    return [NSString stringWithFormat:@"地点：%@,温度：%@,图片码：%@,天气：%@,更新时间：%@",_locationName,_temperature,_picCode,_weatherDesc,_updateTime];
}
@end
