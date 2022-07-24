//
//  SelectTableViewCell.h
//  testFunction
//
//  Created by admin on 2020/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface SelectTableViewCell : UITableViewCell
@property(nonatomic, strong)UILabel *lab;
@property(nonatomic, strong)UIImageView *iconImageV;
@property(nonatomic, copy)void(^deleteBlock)(void);
@end

NS_ASSUME_NONNULL_END
