//
//  ViewController.m
//  musicLibrariesDemo
//
//  Created by LDY on 17/3/30.
//  Copyright © 2017年 LDY. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *controlSlider;
@property (weak, nonatomic) IBOutlet UIButton *preSongBtn;
@property (weak, nonatomic) IBOutlet UIButton *palyBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextSongBtn;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@property(nonatomic,strong)NSTimer *timer;

@end

@implementation ViewController{
    MPMusicPlayerController *musicPlayerVC;
    MPVolumeView *volumeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(100, 60, 100, 2)];
     volumeView = [[MPVolumeView alloc]initWithFrame:backView.frame];
    backView.backgroundColor = [UIColor grayColor];
    [volumeView addSubview:backView];
//    [self.volumeSlider removeFromSuperview];
//    [volumeView addSubview:self.volumeSlider];
//    [self.view addSubview:volumeView];
    
    musicPlayerVC = [[MPMusicPlayerController alloc]init];
    [self registerNotification];//注册播放状态改变的通知
}
-(void)registerNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playbackStateDidChangeAction:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nowPlayingItemDidChangeAction:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(volumeDidChangeAction:) name:MPMusicPlayerControllerVolumeDidChangeNotification object:nil];

}
#pragma notification actions
-(void)playbackStateDidChangeAction:(NSNotification *)notification{
    
}
-(void)nowPlayingItemDidChangeAction:(NSNotification *)notification{
    
}
-(void)volumeDidChangeAction:(NSNotification *)notification{
    
}
#pragma controls
- (IBAction)controlSliderAction:(UISlider *)sender {
    
    
    
    
}
- (IBAction)volumeControlAction:(UISlider *)sender {
}

- (IBAction)preSongBtnAction:(UIButton *)sender {
    [musicPlayerVC skipToPreviousItem];
}
- (IBAction)playBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [musicPlayerVC play];
    }else if ([musicPlayerVC playbackState] == MPMusicPlaybackStatePlaying){
        [musicPlayerVC pause];
    }
}
- (IBAction)nextSongBtnAction:(UIButton *)sender {
    [musicPlayerVC skipToNextItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
