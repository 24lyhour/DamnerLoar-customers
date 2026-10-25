# DamnerLoar Customers — Project Rules

Flutter customer app for booking transport tickets and hotels.
State management, routing and DI: **GetX** (`get`), scaffolded with **get_cli**.

The reference module is `lib/app/modules/transport/`. Every new module copies its shape.

---

## 1. Project layout

```
lib/
├── main.dart                     # app bootstrap only (theme, routes, initial route)
└── app/
    ├── config/                   # flavor / environment config (dev, staging, prod)
    ├── core/                     # app-wide, feature-agnostic code
    │   ├── app_policy/           # terms, privacy, policy text/helpers
    │   ├── constants/            # app_string, app_spacing, api_endpoints
    │   ├── helpers/              # pure helper functions (formatters, validators)
    │   ├── services/             # long-lived GetxServices (storage, auth session)
    │   ├── theme/                # app_color, app_text_style, app_theme
    │   └── widgets/              # shared widgets used by 2+ modules
    ├── data/                     # data shared by 2+ modules
    │   ├── domain/
    │   ├── enums/
    │   ├── models/               # shared models (user, booking, payment...)
    │   ├── providers/            # base_provider.dart (GetConnect base) + shared providers
    │   └── repositories/
    ├── middleware/               # GetMiddleware (auth, onboarding)
    ├── modules/                  # one folder per feature  ← see section 2
    └── routes/                   # app_pages.dart + app_routes.dart (get_cli managed)
```

**Rule:** if something is used by only one module, it lives inside that module.
Move it to `core/` or `data/` only when a second module needs it.

---

## 2. Module structure (follow `modules/transport/`)

```
modules/<feature>/
├── bindings/
│   └── <feature>_binding.dart
├── controllers/
│   └── <feature>_controller.dart
├── views/
│   └── <feature>_view.dart
├── widgets/                      # optional: widgets used only by this feature
│   └── <feature>_<name>_card.dart
├── data/                         # optional: data used only by this feature
│   ├── models/
│   │   └── <name>_model.dart
│   └── providers/
│       └── <feature>_provider.dart
└── <sub_screen>/                 # one folder per screen inside the feature flow
    ├── bindings/
    │   └── <sub_screen>_binding.dart
    ├── controllers/
    │   └── <sub_screen>_controller.dart
    ├── views/
    │   └── <sub_screen>_view.dart
    └── widgets/                  # optional
```

Real example:

```
modules/transport/
├── bindings/transport_binding.dart
├── controllers/transport_controller.dart
├── views/transport_view.dart
├── data/
│   ├── models/transport_model.dart
│   └── providers/transport_provider.dart
├── trip_list/        (bindings/ controllers/ views/)
├── seat_selection/   (bindings/ controllers/ views/)
└── passenger_info/   (bindings/ controllers/ views/)
```

### Rules
1. **One screen = one `bindings/controllers/views` trio.** Never put two screens' controllers in one folder.
2. **Sub-screens of a flow are nested** inside their parent feature (`transport/seat_selection`, `hotel/room_selection`), not added as new top-level modules.
3. **Sub-screens share the parent's `data/`.** `seat_selection` imports from `transport/data/`; it does not get its own `data/` folder.
4. **Modules never import from another module.** If `hotel` needs something from `transport`, move it to `core/` or `data/`.
5. Only create `widgets/` and `data/` when they have files in them.

---

## 3. Layer responsibilities

```
View  ──>  Controller  ──>  Provider  ──>  BaseProvider (GetConnect)  ──>  API
                              │
                              └── returns Model
```

| Layer | Extends | Does | Never does |
|---|---|---|---|
| **View** | `GetView<XController>` | Builds UI, reads `controller.*`, wraps reactive parts in `Obx` | API calls, business logic, `Get.find` of other controllers |
| **Controller** | `GetxController` | Holds `.obs` state, loading/error flags, calls providers, navigates | Build widgets, parse raw JSON |
| **Binding** | `Bindings` | Registers the controller (and its provider) with `Get.lazyPut` | Anything else |
| **Provider** | `BaseProvider` | One method per endpoint, returns `Response` or a model | Hold UI state |
| **Model** | — | Fields + `fromJson` / `toJson` | Call APIs, contain UI logic |

- Endpoint paths live in `core/constants/api_endpoints.dart`, never hard-coded in providers.
- Add a repository (`data/repositories/`) only when a controller would otherwise combine several providers or add caching.

---

## 4. Naming

| Thing | File | Class |
|---|---|---|
| Binding | `trip_list_binding.dart` | `TripListBinding` |
| Controller | `trip_list_controller.dart` | `TripListController` |
| View | `trip_list_view.dart` | `TripListView` |
| Model | `trip_model.dart` | `TripModel` |
| Provider | `transport_provider.dart` | `TransportProvider` |
| Widget | `trip_card.dart` | `TripCard` |

- Files and folders: `snake_case`. Classes: `PascalCase`.
- The file name must match the class name, spelled correctly.

---

## 5. Routes

- Routes are registered in `routes/app_pages.dart` and named in `routes/app_routes.dart`.
- Sub-screens are `children:` of their parent `GetPage`. Their route is `Routes.<PARENT> + _Paths.<CHILD>` (for example, `/transport/seat-selection`).
- Navigate with the constants only: `Get.toNamed(Routes.SEAT_SELECTION)`, never a raw string.
- Protected pages add `middlewares: [AuthMiddleware()]` on their `GetPage`.

---

## 6. Creating things (get_cli)

```bash
# New feature module (top-level)
get create page:<feature>

# New sub-screen inside a feature
get create page:<sub_screen> on <feature>

# Model from a sample JSON (put the JSON in assets/models/)
get generate model on <feature> with assets/models/<name>.json --skipProvider   # feature-only model
get generate model with assets/models/<name>.json --skipProvider                # shared model
```

- Use `get create` for pages, controllers and views. Use `get generate model ... with <json>` for models.
- After get_cli runs, move the generated model to `<feature>/data/models/` if it landed somewhere else.
- Delete get_cli's template code (`count`, `increment`, empty `onInit/onReady/onClose` overrides) when you start working on the controller.

---

## 7. Flavors

| Flavor | Entry point | App ID (Android & iOS) | App name | Banner |
|---|---|---|---|---|
| dev | `lib/main_dev.dart` | `com.damnerloar.customers.dev` | DamnerLoar Dev | red DEV |
| staging | `lib/main_staging.dart` | `com.damnerloar.customers.staging` | DamnerLoar Staging | orange STAGING |
| prod | `lib/main_prod.dart` | `com.damnerloar.customers` | DamnerLoar | none |

```bash
flutter run --flavor dev -t lib/main_dev.dart
flutter build apk --release --flavor prod -t lib/main_prod.dart
flutter build ipa --flavor prod -t lib/main_prod.dart
```

- Always pass both `--flavor` and `-t`. VS Code launch configs are in `.vscode/launch.json`.
- Startup lives in `lib/bootstrap.dart`. The `main_*.dart` files only call `bootstrap(AppFlavor.x)`.
- Per-flavor values (API base URL...) live in `lib/app/config/flavor_config.dart` and are read through `AppConfig` (`AppConfig.baseUrl`, `AppConfig.isProd`). Never hard-code an environment URL anywhere else.
- Android: `productFlavors` in `android/app/build.gradle.kts`; app name comes from `resValue("string", "app_name", ...)`.
- iOS: build configurations are `Debug-<flavor>`, `Release-<flavor>`, `Profile-<flavor>`, with one scheme per flavor. The bundle ID and `APP_DISPLAY_NAME` are set per configuration in Xcode build settings.
- When a native plugin makes Flutter generate `ios/Podfile`, map the flavor configurations in it:
  ```ruby
  project 'Runner', {
    'Debug-dev' => :debug, 'Profile-dev' => :release, 'Release-dev' => :release,
    'Debug-staging' => :debug, 'Profile-staging' => :release, 'Release-staging' => :release,
    'Debug-prod' => :debug, 'Profile-prod' => :release, 'Release-prod' => :release,
  }
  ```

---

## 8. New module checklist

- [ ] Created with `get create page:` so the route and binding are registered
- [ ] Folder shape matches section 2
- [ ] Binding registers the controller (and its provider) with `Get.lazyPut`
- [ ] View extends `GetView<...>` and uses `AppColor` / `AppTextStyle` / `AppSpacing`, not hard-coded values
- [ ] Strings come from `core/constants/app_string.dart`
- [ ] No imports from other modules
- [ ] `flutter analyze` has no errors or warnings
