# Citation Rex Website

A web app to recommend scientific papers based on a user given context. Depending on branch, the recommendations are displayed with different levels of explainability.

Current link to the master version of the website is: http://km.aifb.kit.edu/services/citerex/#/



# Requirements

- Flutter
- Web browser (ideally Chrome for development)

The whole system is built using flutter. In order to build the system locally, you need to have a full installation of the Flutter SDK and it's requirements. Full instructions on the installation can be found on their website: https://flutter.dev/docs/get-started/install

Since flutter web is currently still in beta, you need to enable it via the following commands
```
flutter channel beta
flutter upgrade
flutter config --enable-web
```

# Building the website

Flutter allows building for multiple platforms, but we currently only recommend building the web based version. Android and iOS support is theoretically possible, but probably requires fitting the web format to vertical compatibility (as phones have considerably smaller screen sizes, especially width).

In order to build the release version with flutter use the following command from the root of the project folder:

```
flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true
```

# Running the flask server

TODO
