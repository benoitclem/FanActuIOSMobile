//
//  HotView.m
//  FanActuV2
//
//  Created by Clément BENOIT on 07/03/16.
//  Copyright © 2016 cbenoitp. All rights reserved.
//

#import "HotView.h"

@implementation HotView

- (void) setPublicationId:(NSString*) pubId {
    publicationId = [NSString stringWithString:pubId];
}

- (void) setCallBack:(ArticleListViewController*) lvc{
    vc = lvc;
}

- (IBAction)SelectedView:(id)sender {
    NSLog(@"Touched up inside: %@",publicationId);
    [vc HotTapped:publicationId];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
