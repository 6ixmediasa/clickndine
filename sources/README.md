# ClicKnDine Source

These Flutter source trees are generated from the versioned payloads and the same
patch steps used by the APK and Flutter web build workflows.

- customer-flutter-android: Android customer app.
- customer-flutter-web: browser customer app (latest location and consent changes).
- driver-flutter-android: Android driver app with visible startup handling.

Live secrets, signing material, and Firebase project files are intentionally excluded.
Restore google-services.json for local Firebase builds and configure your own web
Firebase/Google Maps browser API details.

**Laravel admin backend:** not published in this public repository because the
V8.7n backend may include commercially licensed source. Keep the sanitized complete
backend archive in a private repository or secure backup. The separate full source
bundle was supplied in the ClicKnDine conversation.

The exact deployed cPanel version may differ from the latest source snapshots.
