//
//  PaintTypeView.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/26.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "PaintTypeView.h"
#import "Masonry.h"
#import "PaintTypeModel.h"


@interface PaintTypeCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView         *specialImgView;
@property (nonatomic, weak) UILabel             *nameLabel;

@end

@implementation PaintTypeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        self.specialImgView = imageView;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(2);
            make.right.offset(-2);
            make.top.offset(2);
            make.bottom.offset(-2);
        }];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
            make.height.mas_equalTo(22);
        }];
        nameLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.nameLabel = nameLabel;
        nameLabel.font = [UIFont systemFontOfSize:11.0];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.text = @"特效";
        
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor blueColor];
    }
    else{
        self.backgroundColor = [UIColor blackColor];
    }
}

@end





@interface PaintTypeView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView        *collectionView;

@end


@implementation PaintTypeView



- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        
        [self collectionViewConfigure];
        
        self.dataArray = @[@"黑白", @"特效1"];
        
        [self.collectionView reloadData];
        
    }
    return self;
}

- (void)collectionViewConfigure {
    
    UICollectionViewFlowLayout *flowView = [[UICollectionViewFlowLayout alloc] init];
    flowView.itemSize = CGSizeMake(54, 54);
    flowView.minimumInteritemSpacing = 10;
    flowView.minimumLineSpacing = 10;
    flowView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 64) collectionViewLayout:flowView];
    [self addSubview:collectionView];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    [self.collectionView registerClass:[PaintTypeCollectionViewCell class] forCellWithReuseIdentifier:@"PaintTypeCollectionViewCell"];
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}


#pragma mark - 代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!self.dataArray) {
        return 0;
    }
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PaintTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PaintTypeCollectionViewCell" forIndexPath:indexPath];
    
    PaintTypeModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.text = model.name;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectBlock) {
        self.didSelectBlock(indexPath.row);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}






@end
