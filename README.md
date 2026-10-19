# Property Finder - Tech Interview

Congratulations! 🥳 
This is a **take‑home coding exercise** for the Property Finder iOS team. 
You have **up to 3 days** to work through the tasks below at your own pace.

---

Our idea is to evaluate your working style:
* **How you structure your code**
* **How you are tackling specific tasks**

We put together a very lite version of our beloved Property Finder application, with a simple backend functionality, tracking, logging, and all the other stuff... just basic UI of two out of many screens of the actual application.

---

## Table of Contents
- [Task 1 - Rebuild the following UI in SwiftUI](#task-1---rebuild-the-following-ui-in-swiftui)
- [Task 2 - Fetch listings and populate the Search screen](#task-2---fetch-listings-and-populate-the-search-screen)
- [Task 3 - Favourites and filtering](#task-3---favourites-and-filtering)
- [Bonus Task - Refactor the Settings screen](#bonus-task---refactor-the-settings-screen)
- [Sending the project file back in](#sending-the-project-file-back-in)
- [Implementation notes](#implementation-notes)

---

## Task 1 - Rebuild the following UI in SwiftUI

![Search Screen](Screenshots/SearchScreen.png)

### Notes

* The list should scroll beneath the search bar
* Each button should only print a short statement to the console
* The carousel images are in Assets.xcassets

### Design Remarks
* Corner Radius: `Multiples of 4`
* Paddings: `Multiples of 4`
* Spacings: `Multiples of 4`

### Font Remarks
* Tags: `.caption2`
* "2,575,000 AED": `.headline`
* Everything else: `.caption`

---

## Task 2 - Fetch listings and populate the Search screen

In Task 1 you rebuilt the UI of the search screen. In this task, you will **back it with real data**.

We host a JSON payload that represents the list of properties shown in the screenshot at:

`https://simplejsoncms.com/api/m6nfoc4jlw`

Your job is to:

- **Fetch the data** from the hosted endpoint using `URLSession`
- **Populate the Search screen** with the decoded listings, including tags, meta information, and carousel images

### JSON shape

<details>
<summary>Click to view JSON contract</summary>

```json
{
  "listings": [
    {
      "id": "prop_001",
      "type": "Apartment",
      "deliveryYear": 2022,
      "price": 2575000,
      "currency": "AED",
      "priceInclusive": true,
      "location": "Laguna Tower, Lake Almas West, Jumeirah Lake Tower",
      "bedrooms": null,
      "bathrooms": 1,
      "areaSqft": 1356,
      "publishedAt": "2024-11-28T00:00:00Z",
      "lastContactedAt": "2021-07-28T00:00:00Z",
      "tags": ["verified", "new_construction", "live_viewing"],
      "images": ["FirstImage", "SecondImage"],
      "contactOptions": ["phone", "email", "whatsapp"]
    },
    {
      "id": "prop_002",
      "type": "Apartment",
      "deliveryYear": 2023,
      "price": 1850000,
      "currency": "AED",
      "priceInclusive": false,
      "location": "Marina Heights, Dubai Marina",
      "bedrooms": 1,
      "bathrooms": 2,
      "areaSqft": 980,
      "publishedAt": "2024-11-30T00:00:00Z",
      "lastContactedAt": null,
      "tags": ["verified"],
      "images": ["SecondImage", "FirstImage"],
      "contactOptions": ["phone", "whatsapp"]
    }
  ]
}
```

</details>

### Notes

- **Studio vs bedrooms**: `bedrooms: null` represents a Studio. Any integer value should be rendered as `"N Beds"`.
- **Carousel images**: `images` contains asset names from `Tahudu/Assets/Assets.xcassets/Carousel Images` (`FirstImage`, `SecondImage`). Use these to drive the image carousel.
- **Tags**: `tags` drives the badges on top of the image (`VERIFIED`, `NEW CONSTRUCTION`, `LIVE VIEWING`). Feel free to introduce an enum to map from the raw values to UI.
- **Relative dates**: `publishedAt` is an ISO‑8601 timestamp; compute a relative label such as “Published 3 days ago”.
- **Last contacted**: `lastContactedAt` is nullable. Only show the yellow “Last contacted …” banner when a value is present.
- **Contact options**: `contactOptions` indicates which contact buttons to show for each listing (phone, email, WhatsApp).
- **cURL Example**: You may use this `cURL` example to fetch the response to fill-up the data

`curl -X GET "https://simplejsoncms.com/api/m6nfoc4jlw"`

> [!IMPORTANT]
> Please refrain from using 3rd party libraries


---

## Task 3 - Favourites and filtering

Add **local favouriting** to the Search screen and a way to filter by favourites.

### Requirements

1. Tapping the heart icon on a listing card **toggles** it as a favourite.
2. Favourites are persisted **locally**.
3. Add a filter control on the first screen (the Search screen) that, when active, shows **only favourited listings**.
4. The filter state should be clearly visible so the user knows when they are viewing only favourites.

### Notes

- **Architecture**: Decide where the favouriting logic should live (view, view model, data layer, etc.) and structure your code accordingly.
- **Heart icon state**: The heart should visually reflect the current favourite state (e.g. filled vs outline).
- **User experience**: Feel free to add small UX touches (animations, empty‑state messaging) as long as the core behaviour is clear.

---

## Bonus Task - Refactor the Settings screen

The code within Screens/Settings could be written much nicer. Your task is to clean it up. 🧹

We will evaluate:

* **How you are tackling the refactor**
* **Outcome of the refactor**


> [!NOTE]
> Even if you didn't finish it, just writing comments over what you would've intended here and how should be enough

---

## Sending the project file back in

Once you are done with the exercises (within the **3-days** window), please share with us back the GitHub Repo you implemented the task on

---

## Implementation notes

The decisions worth calling out, and the trade-offs behind them.

### Favourites: where the logic lives

Each layer owns one part of the feature:

| Layer | Type | Responsibility |
|---|---|---|
| Data | [`FavouritesRepository`](Tahudu/Data/Repository/FavouritesRepository.swift) | Reads and writes the set of favourite listing IDs in `UserDefaults` |
| Domain | [`FavouritesUseCase`](Tahudu/Domain/UseCases/FavouritesUseCase.swift) | The toggle rule: add the ID if it's missing, remove it if it's there, then save |
| Presentation | [`SearchViewModel`](Tahudu/Presentation/Screens/Search/SearchViewModel.swift) | Holds the current IDs, answers `isFavourite`, and applies the "favourites only" filter |
| View | [`PropertyCardView`](Tahudu/Presentation/Screens/Search/SubViews/PropertyCardView.swift) | Only displays: takes `isFavourite: Bool` and an `onFavouriteTapped` closure |

- **Why this split:** saving is data work, the toggle is a business rule, and the filter is screen state, so the card stays a plain view that's easy to preview.
- **Wiring:** both new types sit behind protocols and are registered in the DI container, the same way search is wired.
- **Tests:** each part is unit-tested with in-memory fakes in [`FavouritesTests.swift`](TahuduTests/FavouritesTests.swift).
- **Storage:** `UserDefaults` is enough because only a small set of IDs is stored; Core Data or SwiftData would be overkill.
- **Trade-off:** the view model keeps its own copy of the IDs. That's fine while only one screen shows favourites. If a second screen (say, a Favourites tab) needed live updates, I'd switch to a single shared observable store injected into both.
- **Filter state:** "favourites only" isn't saved and resets on launch, by design.

### Tags: fallback for unknown values

The spec lists three tags, but the live endpoint sends ten. The extra seven are `furnished`, `price_reduced`, `sea_view`, `exclusive`, `corner_unit`, `high_floor` and `low_floor`. Rather than drop them silently, `PropertyTag` has an `.other(String)` case:

- The three tags from the spec keep their own colours.
- Any other value shows as a neutral badge with a readable title (`sea_view` becomes `SEA VIEW`), so new backend tags appear without an app release.
- The enum lives in the Domain layer ([`Properties.swift`](Tahudu/Domain/Entity/Properties.swift)), and titles and colours live in a Presentation extension ([`PropertyTag.swift`](Tahudu/Presentation/Models/PropertyTag.swift)), so Domain doesn't import SwiftUI.

### Settings refactor

I kept the screen in UIKit, since the task asks for a refactor rather than a rewrite, and made it data-driven ([`SettingsViewController.swift`](Tahudu/Presentation/Screens/Settings/SettingsViewController.swift)):

- **Rows as data:** a `SettingsRow` enum holds each row's title, icon and accessibility identifier, and a `sections` array sets the order. Adding a row means one new case plus one array entry.
- **No nested `if`/`else`:** `cellForRowAt` looks the row up, and `didSelectRowAt` switches over it. The switch covers every case, so the compiler flags a row that has no action.
- **Cell handling:** cells are reused (`dequeueReusableCell`) and configured with `UIListContentConfiguration`.
- **Removed:** the force-unwrap of `preferredLocalizations.first`, setup code in `loadView`, and lines that only re-set UIKit defaults.
- **Unchanged:** the navigation methods marked "no need to touch".

Two behaviour changes are deliberate:
- Cells no longer force `.systemBackground`, so in dark mode they use the standard grouped-cell colour instead of black on black.
- The accessibility identifier `SettnigsCell_feedback` is now `SettingsCell_feedback`, fixing the typo. Any UI test that uses the old ID needs updating.

An alternative is a SwiftUI `List` inside a `NavigationStack`. I'd consider that if the rest of the app were moving to SwiftUI.

### Carousel image names

The JSON contract in Task 2 uses `FirstImage` and `SecondImage`, but the live endpoint returns `first_image` and `second_image`. I renamed the asset sets in `Assets.xcassets/Carousel Images` to match the live API, since that's what the app actually receives. If the documented contract is the source of truth instead, either rename the assets back or map the names in the data layer.

### Minimum iOS version: 17.6

I raised the deployment target from iOS 14.0 to 17.6. The test target moved too, because tests can't import an app that targets a newer iOS version than they do. The code uses iOS 17 APIs:

- `@Observable` and `@Bindable` from the Observation framework
- `ContentUnavailableView` for empty states
- SF Symbol content transitions on the favourite heart

Supporting older versions would mean going back to `ObservableObject` and `@Published`, and replacing those views.
