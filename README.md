# Flutter WASM Bugs

Not working well with WASM
```
flutter run -d chrome --wasm
```

Working well without WASM
```
flutter run -d chrome
```

Also tested on Android and working well. 

Note, the UI web JS build doesn't look very similar to the same code on android, which is an issue as well.