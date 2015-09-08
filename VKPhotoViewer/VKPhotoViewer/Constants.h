//
//  Constants.h
//  VKPhotoViewer
//
//  Created by Admin on 07.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#ifndef VKPhotoViewer_Constants_h
#define VKPhotoViewer_Constants_h

#define APP_ID @"4980008"
#define SCOPE @"friends,photos,wall"
#define REDIRECT_URI @"https://oauth.vk.com/blank.html"
#define DISPLAY @"mobile"
#define API_VERSION @"5.34"

#define USER_ID_KEY @"user_id"
#define TOKEN_LIFE_TIME_KEY @"expires_in"
#define ACCESS_TOKEN_KEY @"access_token"
#define AUTH_COMPLITED_KEY @"authComplited"
#define BASE_URL @"https://api.vk.com/method/"

#define ORDER @"name"
#define FIELDS @"nickname,photo_100,photo_200_orig,bdate"
#define NAME_CASE @"nom"

#define FIELDS_FOR_USER @"sex,bdate,city,country,photo_50,photo_100,photo_200_orig,photo_200,photo_400_orig,photo_max,photo_max_orig,photo_id,online,online_mobile,domain,has_mobile,contacts,connections,site,education,universities,schools,can_post,can_see_all_posts,can_see_audio,can_write_private_message,status,last_seen,relation,relatives,counters,screen_name,maiden_name,timezone,occupation,activities,interests,music,movies,tv,books,games,about,quotes,personal,friend_status,military,career"


#define safeModulo(x,y) ((y + x % y) % y)

#ifdef DEBUG
#define DLog(s, ...) NSLog(s, ##__VA_ARGS__)
#else
#define DLog(s, ...)
#endif

#endif
