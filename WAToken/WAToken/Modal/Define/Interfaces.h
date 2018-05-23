//
//  Interfaces.h
//  KingOfUnrar
//
//  Created by dizhihao on 15/10/22.
//  Copyright © 2015年 dizhihao. All rights reserved.
//

/********************************************************************************************************/

// 接口主地址
#define HOST_URL     @"http://121.41.72.130"
#define IMAGE_URL    @"http://121.41.72.130"

/********************************************************************************************************/

#pragma mark - 接口
/**
 *  开屏广告
 */
//#define OPENNING_ADV @"/SL.php/Ad/start"



/**
 开屏广告
 ad_type        广告类型        1.横幅 2.开屏 3.全屏 4.插屏 5.积分墙 6.文字链接 7.图片链接
 ad_type_name   广告类型名称
 device_id      设备ID
 width          屏幕宽
 height         屏幕高
 loc_x          x坐标
 loc_y          y坐标
 app_name       App名称
 app_version    App版本
 package_name   包名           iOS为bundle ident
 os             系统平台        1.iOS 2.安卓 3.WinPhone 4.其他
 os_version     系统版本
 
 @return    result              统计行为结果
            st_id               统计添加行ID
            advertisement       广告对象
 */
#define OPENNING_ADV    @"/SL.php/AdStatistic/add"



/**
 开屏广告跳转
 st_id          统计行ID
 ad_id          调用的广告ID
 
 @return
 */
#define OPENNING_JUMP   @"/SL.php/AdStatistic/jump"

