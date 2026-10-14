# ClicKnDine — Source Repository

ClicKnDine food-ordering customer website and Android applications.

## Readable Flutter Source

- [Customer Flutter app (Android + Web)](source/customer_flutter/) — built against `https://click.6ixmediasa.com`; website deployment at `https://app.6ixmediasa.com`.
- [Driver Flutter app](source/driver_flutter/) — Android driver client.
- [.github/workflows/build-web.yml](.github/workflows/build-web.yml) — build browser app for the separate subdomain, including mobile terms consent and location fixes.
- [.github/workflows/build-apk.yml](.github/workflows/build-apk.yml) — customer APK.
- [.github/workflows/build-driver-apk.yml](.github/workflows/build-driver-apk.yml) — driver APK.

The legacy `payload/`, `driver_payload/` and `assets_payload/` directories are compressed source snapshots used by the CI workflows. The `source/` directories are readable checkouts of the latest successful builds and are kept updated automatically.

## Backend

The Laravel V8.7n administrator/backend is **not** published here. This is a public repository, and the commercial backend needs a license/privacy review before publication. The owner has a separately supplied sanitized source archive, with the current Yoco and CAPTCHA overlays.

Do not commit server `.env` credentials, live payment/webhook secrets, service account keys, database exports with customer information, or signing keystores.

## Deployment targets

- Backend/API: https://click.6ixmediasa.com
- Customer Flutter web: https://app.6ixmediasa.com/
- Android customer package: `com.sixmediasa.clickndine`
- Android driver package: `com.sixmediasa.clickndine.driver`
