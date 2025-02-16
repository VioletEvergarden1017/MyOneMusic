
# 开发日志

视图结构说明

## 重要视图

0.全局视图，defaultPlayerView（播放器视图）和musicPillView 悬浮胶囊视图，点击悬浮胶囊可以打开播放器视图，在这个界面可以控制音乐的播放。
1.MainTabView，（负责在各个一级界面跳转）可由 mainTabView跳转至主要功能一级视图LibratyView及资料库，由这里我们可以跳转至各个二级界面。

### 一级视图LibraryView

为navigationStack的根视图，在这个视图可依靠navigationLink跳转至如songsView，playlistView，albumView等二级视图。



#### 二级视图 SongsView

这个界面展示资料库（即存储在数据库中的全部歌曲），没有三级视图。但是有个控件SongCell，点击一下就能过播放被点击的音乐。
这里我所实现的播放逻辑是当点击的时候，将SongVM中songs赋值给PlaylistViewModel当中的CurrentPlaylistsSongs（当前播放的歌曲），
aduioplayer Manger当中有一个控件setupQueue即设置播放队列，这个方法接受的track参数就是playlistVm当中的currentPlaylistSongs。

#### 二级视图playlistView

这个界面展示所有的歌单，没有播放按钮，点击歌单跳转至所选歌单的页（navigationlink方法），三级页面PlaylistDetailedView，这个界面会展示该歌单里所有的歌曲，每一列由
控件AlbumsongRow展示（只展示歌的名字和时长，为什么复用了albumdetailView的组件是因为我将两个detailedView的展示UI设计的一样）。
albumsongRow每列就是一首歌，但是还未实现和songcell点击就播放的功能（即和songCell一样点击就从当前位置播放，冰设置currentPlaylistsong为这个歌单）。

playlistDetailView 每个row实现了从当天歌单删除以及添加到某个歌单。

在playlistviewModel当中实现了增删等操作但是只有增加与视图上的按钮链接了

####
二级视图AlbumsView，展示资料库当中的所有专辑有AlbumCell的Grid组成节点，点击一个cell则进入三级界面

## 有关audioplayerManager

在默认播放器视图当中基本功能去如暂停，控制声音，调整播放进度实现了，也和musicPill做了链接。但是还没写播放上一首和下一首的功能，这个应该实现很快，只要写两个函数再再已有的
按钮上调用。







