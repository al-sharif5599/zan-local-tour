import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../../models/product_model.dart';
import '../../services/firestore_service.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<String> photos = [];
  List<String> shortVideos = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.photo_library), text: 'Photos'),
            Tab(icon: Icon(Icons.video_collection), text: 'Short Videos'),
          ],
        ),
      ),
      body: StreamBuilder<List<Product>>(
        stream: FirestoreService().getProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final products = snapshot.data!;
          photos = [];
          shortVideos = [];
          for (var product in products) {
            for (var url in product.mediaUrls) {
              if (url.endsWith('.mp4') ||
                  url.endsWith('.mov') ||
                  url.endsWith('.avi')) {
                // Client-side filter ≤5s would require video_player init, placeholder for now
                shortVideos.add(url);
              } else {
                photos.add(url);
              }
            }
          }
          return TabBarView(
            controller: _tabController,
            children: [
              _buildGrid(photos, isPhoto: true),
              _buildGrid(shortVideos, isPhoto: false),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGrid(List<String> media, {required bool isPhoto}) {
    if (media.isEmpty) return Center(child: Text('No media yet'));
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: media.length,
      itemBuilder: (context, index) {
        final url = media[index];
        if (isPhoto) {
          return Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
          );
        } else {
          return GestureDetector(
            onTap: () => _playVideo(url),
            child: Stack(
              children: [
                Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
                ),
                Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void _playVideo(String url) {
    // Full screen video player dialog
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(child: ChewieDemo.fromUrl(url)),
    );
  }
}

class ChewieDemo extends StatefulWidget {
  final String url;
  const ChewieDemo.fromUrl(this.url);

  @override
  _ChewieDemoState createState() => _ChewieDemoState();
}

class _ChewieDemoState extends State<ChewieDemo> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _chewieController = ChewieController(videoPlayerController: _controller);
    _controller.initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video')),
      body: Chewie(controller: _chewieController!),
    );
  }
}
