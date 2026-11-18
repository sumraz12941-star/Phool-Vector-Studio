# Phool Vector Studio (Starter)

An Android-first Flutter starter for a botanical / flower design editor.

## Included in this starter
- Gallery image import
- Image preview with pinch zoom
- Starter editor layout and layer visibility switches
- Save a copy of the imported image inside app documents
- Share the imported image
- GitHub Actions workflow to build a release APK

## Not implemented yet
- AI background removal
- Automatic flower / leaf / vine segmentation
- True editable vector tracing and SVG path export
- Independent editable object layers
- BMP / PDF export
- Jacquard / NedGraph conversion

The visible layer switches are UI placeholders; they do not yet isolate or hide objects in the source image.

## Build on a computer
1. Install Flutter SDK and Android Studio.
2. Extract this project.
3. Open a terminal in this folder.
4. Run:
   ```bash
   flutter pub get
   flutter run
   ```
5. To build an APK:
   ```bash
   flutter build apk --release
   ```

## Build using GitHub from a phone
1. Upload all files and folders in this ZIP to the root of your `Phool-Vector-Studio` repository.
2. Make sure `.github/workflows/build-apk.yml` is included.
3. Open the repository's **Actions** tab.
4. Select **Build Android APK** and tap **Run workflow** (or push to `main` to trigger it).
5. When the workflow finishes, open the run and download the `phool-vector-studio-apk` artifact.

This is source code, not an already-built APK. A successful GitHub Actions run is needed to produce the installable APK.
