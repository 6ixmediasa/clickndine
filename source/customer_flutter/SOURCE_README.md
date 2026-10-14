# ClicKnDine Customer Flutter Source
This is the browsable Flutter customer app source used to build
the Android client and browser customer frontend.
API: https://click.6ixmediasa.com
Browser: https://app.6ixmediasa.com
Android package: com.sixmediasa.clickndine

Run flutter pub get, then flutter build web --release --base-href /
for the web frontend. Configure Firebase Web app values via
FIREBASE_WEB_APP_ID / FIREBASE_WEB_API_KEY and the browser key
in web/maps-config.js. Android production builds need release signing.
