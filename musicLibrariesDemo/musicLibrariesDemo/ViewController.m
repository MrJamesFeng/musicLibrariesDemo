//
//  ViewController.m
//  musicLibrariesDemo
//
//  Created by LDY on 17/3/30.
//  Copyright © 2017年 LDY. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<MPMediaPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UISlider *controlSlider;
@property (weak, nonatomic) IBOutlet UIButton *preSongBtn;
@property (weak, nonatomic) IBOutlet UIButton *palyBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextSongBtn;
@property (weak, nonatomic) IBOutlet UIView *volumeBackgroundView;


@property(nonatomic,strong)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artworkView;

@end

@implementation ViewController{
    MPMusicPlayerController *musicPlayerVC;//音乐播放
    MPMediaPickerController *mediaPickerController;//资源选择
    MPVolumeView *volumeView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   
     volumeView = [[MPVolumeView alloc]initWithFrame:self.volumeBackgroundView.bounds];
    [self.volumeBackgroundView addSubview:volumeView];
//    [volumeView setVolumeThumbImage:[UIImage imageNamed:@"timg-5"] forState:UIControlStateNormal];
//    [volumeView setVolumeThumbImage:[UIImage imageNamed:@"timg-6"] forState:UIControlStateHighlighted];
   
    
    musicPlayerVC = [[MPMusicPlayerController alloc]init];
//    musicPlayerVC.repeatMode =  MPMusicRepeatModeAll;//循环播放
    musicPlayerVC.repeatMode =  MPMusicRepeatModeOne;//单曲播放
    [self registerNotification];//注册播放状态改变的通知
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pickeMusic)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(customPickeMusic)];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    
}
-(void)pickeMusic{
    @try {
        MPMediaPickerController *mediaPicker= [[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeAny];//Privacy - Media Library Usage Description 否则没有反应
        mediaPickerController = mediaPicker;
        mediaPicker.delegate = self;
        mediaPicker.allowsPickingMultipleItems = YES;
        mediaPicker.prompt = @"select song";
        [self presentViewController:mediaPicker animated:YES completion:nil];
//        [self.navigationController pushViewController:mediaPicker animated:YES];
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
}
-(void)customPickeMusic{
    //谓词匹配
    MPMediaPropertyPredicate *mediaPropertyPredicate = [MPMediaPropertyPredicate predicateWithValue:@"Jmaes" forProperty:MPMediaItemPropertyArtist];
    
    MPMediaItem *mediaItem = nil;//Privacy - Media Library Usage Description 否则崩溃
    MPMediaQuery *allSongQuery = [MPMediaQuery songsQuery];
    [allSongQuery addFilterPredicate:mediaPropertyPredicate];
    NSArray *allTracks = [allSongQuery items];
    if (allTracks.count==0) {
        return ;
    }else if (allTracks.count ==1){
        mediaItem = [allTracks lastObject];
        
    }
    int trackNum = arc4random()%[allTracks count];
    mediaItem = allTracks[trackNum];
    MPMediaItemCollection *mediaItemCollection = [[MPMediaItemCollection alloc]initWithItems:@[mediaItem]];
    [musicPlayerVC setQueueWithItemCollection:mediaItemCollection];
    [musicPlayerVC play];
   
    

//    @try {
//        
//    } @catch (NSException *exception) {
//        NSLog(@"%@",exception);
//    } @finally {
//        
//    }
   
    
}
-(void)timerAction:(NSTimer *)timer{
    
}
-(void)registerNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playbackStateDidChangeAction:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nowPlayingItemDidChangeAction:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];//更新演唱者图片，更新标题、作者、歌词
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(volumeDidChangeAction:) name:MPMusicPlayerControllerVolumeDidChangeNotification object:nil];

}
#pragma notification actions
-(void)playbackStateDidChangeAction:(NSNotification *)notification{
    MPMusicPlaybackState musicPlaybackState = [musicPlayerVC playbackState];
    switch (musicPlaybackState) {
        case MPMusicPlaybackStatePlaying:
            [self.timer fire];
            break;
        case MPMusicPlaybackStatePaused:
            if ([self.timer isValid]) {
                [self.timer invalidate];
            }
            break;
        case MPMusicPlaybackStateStopped:
            
            break;
        case MPMusicPlaybackStateInterrupted:
            
            break;
        case MPMusicPlaybackStateSeekingForward:
            
            break;
        case MPMusicPlaybackStateSeekingBackward:
            
            break;
        default:
            break;
    }

}
-(void)nowPlayingItemDidChangeAction:(NSNotification *)notification{
    //正在播放的MPMediaItem对象
    MPMediaItem *nowPlayingMediaItem = [musicPlayerVC nowPlayingItem];
    MPMediaItemArtwork *mediaItemArtwork = [nowPlayingMediaItem valueForKey:MPMediaItemPropertyArtwork];
    //专辑图片
    if (mediaItemArtwork) {
        UIImage *artworkImage = [mediaItemArtwork imageWithSize:CGSizeMake(240, 240)];
        self.artworkView.image = artworkImage?artworkImage:[UIImage imageNamed:@"timg-2"];
    }
    //歌名
    NSString *songTitle = [nowPlayingMediaItem valueForKey:MPMediaItemPropertyTitle];
    self.songTitleLabel.text = songTitle?songTitle:@"unknown";
    //作者
    NSString *artist = [nowPlayingMediaItem valueForKey:MPMediaItemPropertyArtist];
    self.artistLabel.text = artist?artist:@"unknown";
    //专辑
    NSString *albumString = [nowPlayingMediaItem valueForKey:MPMediaItemPropertyAlbumTitle];
    self.recordLabel.text = albumString?albumString:@"unknown";
}
-(void)volumeDidChangeAction:(NSNotification *)notification{
  
}

#pragma MPMediaPickerControllerDelegate
-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    
    if (mediaItemCollection) {
        [musicPlayerVC setQueueWithItemCollection:mediaItemCollection];
        [musicPlayerVC play];
    }
}
-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}
#pragma controls
- (IBAction)controlSliderAction:(UISlider *)sender {
    
    
    
    
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
