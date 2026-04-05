# Gallery Feature na GUEST Role - Implementation Plan

## 1. Add Dependencies (pubspec.yaml) ✅
- video_player, chewie, google_sign_in
- `flutter pub get` ✅

## 2. Update Models ✅ (guest role added)
- user_model.dart: Add `guest` ✅
- user_model.dart: Add `guest` to UserRole enum
- product_model.dart: Add optional `mediaTypes: List<String>` (image/video) - optional

## 3. Create GalleryScreen
- lib/screens/gallery/gallery_screen.dart
- DefaultTabController(2 tabs: "Photos", "Short Videos")
- StreamBuilder approved products → flatten mediaUrls
- Photos Tab: GridView Image.network
- Videos Tab: GridView Chewie thumbnails (filter ≤5s client-side)

## 4. Update HomeScreen
- Tabs: "Products" | "Gallery"
- Gallery tab → GalleryScreen
- FAB upload for local/guest? No, guest view-only

## 5. Update UploadScreen
- Add pickVideo(ImagePicker)
- Client-side duration check ≤5s for short videos
- Upload videos to Storage, add to mediaUrls

## 6. Update Auth/Register
- Add GUEST role option in register_screen.dart
- Add Google Sign-In button in login_screen.dart
- Label GUEST in English uppercase

## 7. Update Services
- FirestoreService: Ensure streams work for all roles (guest sees approved)
- StorageService: Handle video upload

## 8. Test
- Register GUEST (manual/Google)
- Local upload photo/video (duration check)
- Admin approve
- All roles view Gallery tabs (photos/videos)

**Status: Pending**
