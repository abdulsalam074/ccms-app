import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController();
  late VideoPlayerController _videoController;

  int currentIndex = 0;

  final List<String> images = [
    "images/electricity_issue.png",
    "assets/images/electricity_issue2.png",
    "assets/images/road_issue.png",
  ];

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset("assets/videos/Vid 1.3.mp4")
      ..initialize().then((_) {
        setState(() {}); // Update the first frame
        _videoController.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff2193b0), Color(0xff6dd5ed)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: OrientationBuilder(
            builder: (context, orientation) {
              bool isLandscape = orientation == Orientation.landscape;

              if (isLandscape) {
                return _buildLandscapeLayout(context);
              } else {
                return _buildPortraitLayout(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isTablet = size.width > 600;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          children: [
            /// TITLE
            Text(
              "Digital Complaint System",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 28.sp : 32.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25.h),

            /// MEDIA SECTION (Image + Video)
            _buildMediaSection(isTablet: isTablet, isLandscape: false),

            SizedBox(height: 30.h),

            /// WELCOME & STATS
            _buildWelcomeAndStats(isTablet: isTablet),

            SizedBox(height: 35.h),

            /// BUTTONS
            _buildActionButtons(isTablet: isTablet),
            
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT SIDE: MEDIA
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Text(
                    "Digital Complaint System",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 20.sp : 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildMediaSection(isTablet: isTablet, isLandscape: true),
                ],
              ),
            ),
          ),
          
          SizedBox(width: 30.w),

          /// RIGHT SIDE: TEXT & ACTIONS
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  _buildWelcomeAndStats(isTablet: isTablet),
                  SizedBox(height: 30.h),
                  _buildActionButtons(isTablet: isTablet),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection({required bool isTablet, required bool isLandscape}) {
    final size = MediaQuery.of(context).size;
    
    // Dynamically adjust height based on orientation to prevent overflow
    double sliderHeight = isLandscape 
        ? size.height * 0.45 
        : (isTablet ? size.height * 0.35 : size.height * 0.25);
        
    double videoHeight = isLandscape 
        ? size.height * 0.45 
        : (isTablet ? size.height * 0.3 : size.height * 0.22);

    return Column(
      children: [
        /// IMAGE SLIDER
        SizedBox(
          height: sliderHeight,
          child: PageView.builder(
            controller: _controller,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.white24,
                      child: const Icon(Icons.image, color: Colors.white, size: 50),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10.h),

        /// DOT INDICATOR
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            images.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: currentIndex == index ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentIndex == index ? Colors.white : Colors.white54,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),

        /// VIDEO PLAYER
        GestureDetector(
          onTap: () {
            setState(() {
              _videoController.value.isPlaying
                  ? _videoController.pause()
                  : _videoController.play();
            });
          },
          child: Container(
            width: double.infinity,
            height: videoHeight,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: _videoController.value.isInitialized
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        ),
                        if (!_videoController.value.isPlaying)
                          const Icon(Icons.play_circle_fill, size: 60, color: Colors.white70),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeAndStats({required bool isTablet}) {
    return Column(
      children: [
        /// WELCOME
        Text(
          "Welcome to Digital Complaint Management System",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isTablet ? 22.sp : 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          "Report your complaints quickly and track their status online.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: isTablet ? 14.sp : 16.sp,
            height: 1.3,
          ),
        ),
        SizedBox(height: 25.h),

        /// APPLICATION STATISTICS
        Container(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem("1.2K+", "Resolved"),
              Container(width: 1, height: 40.h, color: Colors.white30),
              _buildStatItem("24h", "Avg. Time"),
              Container(width: 1, height: 40.h, color: Colors.white30),
              _buildStatItem("98%", "Satisfaction"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons({required bool isTablet}) {
    double btnHeight = isTablet ? 60.h : 55.h;
    
    return Column(
      children: [
        /// LOGIN BUTTON
        SizedBox(
          width: double.infinity,
          height: btnHeight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xff2193b0),
              elevation: 5,
              shadowColor: Colors.black.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/login");
            },
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: isTablet ? 18.sp : 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 15.h),

        /// REGISTER BUTTON
        SizedBox(
          width: double.infinity,
          height: btnHeight,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/register");
            },
            child: Text(
              "Register",
              style: TextStyle(
                fontSize: isTablet ? 18.sp : 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
