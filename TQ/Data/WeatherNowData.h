//
//  WeatherNowData.h
//  TQ
//
//  Created by 杨宗维 on 2018/5/26.
//  Copyright © 2018年 Icecooll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherNowData : NSObject

    @property(nonatomic,retain) NSString*locationName;
    @property(nonatomic,retain) NSString*temperature;
    @property(nonatomic,retain) NSString*picCode;
    @property(nonatomic,retain) NSString*updateTime;
    @property(nonatomic,retain) NSString*weatherDesc;
    
@end
