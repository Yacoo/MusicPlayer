//
//  SFRankCell.m
//  SFMusicPlayer
//
//  Created by yake on 15-3-24.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFRankCell.h"
#import "SFRankItemModel.h"
#import "SFContentItemModel.h"
#import <UIImageView+WebCache.h>

@implementation SFRankCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setContentItemModel:(SFContentItemModel *)contentItemModel
{
    _contentItemModel = contentItemModel;
    [self.rankOrderImage sd_setImageWithURL:[NSURL URLWithString:contentItemModel.pic_s192] placeholderImage:[UIImage imageNamed:@"img_default_playlist546"]];
    NSArray * contentArray = contentItemModel.content;
    
    [self.firstLabel setAttributedText:[self rankListWithModel:[contentArray objectAtIndex:0] index:1]];
    [self.secondLabel setAttributedText:[self rankListWithModel:[contentArray objectAtIndex:1] index:2]];
    [self.thirdLabel setAttributedText:[self rankListWithModel:[contentArray objectAtIndex:2] index:3]];

    
}
- (NSMutableAttributedString *)rankListWithModel:(SFRankItemModel *)model index:(NSInteger)index
{
    NSString * str = [NSString stringWithFormat:@"%ld %@ - %@",index,model.title,model.author];
    NSMutableAttributedString * labelString = [[NSMutableAttributedString alloc] initWithString:str];
    //排名
    NSRange rankNumRange = NSMakeRange(0, 2);
    NSRange  range = [str rangeOfString:@" - "];
    NSInteger location = range.location;
    //标题
    NSRange titleRange = NSMakeRange(2, location+1-rankNumRange.length);
    NSRange singerRange = NSMakeRange(location, str.length-titleRange.length-rankNumRange.length+1);
    [labelString addAttribute:NSForegroundColorAttributeName value:YKColor(195, 33, 54) range:rankNumRange];
    [labelString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:rankNumRange];
   [labelString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:titleRange];
    [labelString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:titleRange];
    [labelString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:singerRange];
    [labelString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:singerRange];
    
    return labelString;
}
- (IBAction)discButtonAction:(id)sender {
}

@end
