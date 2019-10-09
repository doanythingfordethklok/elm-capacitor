# elm-capacitor

Demo showing how Elm can be used for native apps using capacitor.

### Get Started

- [Install Elm](https://guide.elm-lang.org/install.html)
- Install [ParcelJS](https://parceljs.org/getting_started.html) and dev deps - `yarn install`
- Run the web app, open a browser - `yarn run dev`. goto http://localhost:8085

### Running Tests

Install test runner globally from npm - `yarn global add elm-test`

Run the tests with default settings - `elm-test`

- Randomly chooses a seed
- Sets fuzz count to 100

Run the tests with a specific fuzzer seed - `elm-test --fuzz 60 --seed 12345`

- fuzz is the number of iterations of fuzz to run
- seed is used to run a fuzzer so it generates the same values every time

# Native Apps

Build the Elm app as normal, then use capacitor to push to native.

The following commands are from the [capacitor docs for ios](https://capacitor.ionicframework.com/docs/ios)

```
npm run build
npx cap add ios
npx cap sync OR npx cap copy ios
npx cap open ios
```

The following commands are from the [capacitor docs for android](https://capacitor.ionicframework.com/docs/android)

```
npm run build
npx cap add android
npx cap sync OR npx cap copy android
npx cap open android
```

Once in Android Studio or XCode, the app can be built, run in emulator, pushed to device, or published to the app stores.
