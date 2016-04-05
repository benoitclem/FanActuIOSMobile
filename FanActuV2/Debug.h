//
//  Debug.h
//  FanActuV2
//
//  Created by Clément BENOIT on 30/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#ifndef Debug_h
#define Debug_h

//#define DEBUG_NETWORK

#if defined(DEBUG_NETWORK)
#define NETLOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NETLOG(...) do { } while (0)
#endif 

#endif /* Debug_h */
