//
//  SelectTableViewCell.m
//  testFunction
//
//  Created by admin on 2020/11/30.
//

#import "SelectTableViewCell.h"
@interface SelectTableViewCell()
@property(nonatomic, assign)CGRect currentFrame;
@property(nonatomic, strong)AWHGHALLButton *deleteBtn;
@end

@implementation SelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = RGBA(236, 239, 246, 1);
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    [self.contentView addSubview:self.lab];
    [self.contentView addSubview:self.deleteBtn];
    [self.contentView addSubview:self.iconImageV];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGRect deleteBtnFrame = self.deleteBtn.frame;
    CGFloat deleteHeight = deleteBtnFrame.size.height;
    CGFloat deleteWidth = deleteBtnFrame.size.width;
    deleteBtnFrame.origin.x = frame.size.width - deleteWidth -10;
    deleteBtnFrame.origin.y = (frame.size.height-deleteHeight)/2.0;
    self.deleteBtn.frame = deleteBtnFrame;
    
    
}

-(void)deleteClick:(AWHGHALLButton *)sender
{
    AWLog(@"click delete");
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

-(UILabel *)lab
{
    if (!_lab) {
        _lab = [[UILabel alloc]initWithFrame:CGRectMake(38, 5, 150, 30)];
        _lab.textColor = [UIColor blackColor];
    }
    return _lab;
}

-(AWHGHALLButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(360, 5, 20, 20)];
//        _deleteBtn.backgroundColor = [UIColor redColor];
        [_deleteBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/delete.png"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

-(UIImageView *)iconImageV
{
    if (!_iconImageV) {
        _iconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 10, 18, 18)];
        _iconImageV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageV;
}

@end
