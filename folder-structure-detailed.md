---

# 📦 Listing Feature – Clean Architecture with Flutter Bloc

This module implements the **Listing** feature using **Clean Architecture** principles with **Flutter Bloc** for state management.
It supports fetching **listings by subcategory** and **listing details by ID**, with a clean separation between presentation, domain, and data layers.

---

## 🏗️ Architecture Overview

```
UI
 └── ListingBloc
      └── UseCases
           └── ListingRepository (abstract)
                └── ListingRepositoryImpl
                     └── ListingRemoteDataSource
                          └── API (Dio)
```

---

## 📁 Feature Structure

```
lib/features/listing/
│
├── presentation/
│   └── bloc/
│       ├── listing_bloc.dart
│       ├── listing_bloc_event.dart
│       └── listing_bloc_state.dart
│
├── domain/
│   ├── entities/
│   │   ├── listing.dart
│   │   └── user.dart
│   ├── repositories/
│   │   └── listing_repository.dart
│   └── usecases/
│       ├── get_listings_usecase.dart
│       ├── get_listing_detail_usecase.dart
│       └── params/
│           └── listing_param.dart
│
├── data/
│   ├── models/
│   │   ├── listing_model.dart
│   │   └── response_model/
│   │       └── listing_response_model.dart
│   ├── repositories/
│   │   └── listing_repository_impl.dart
│   ├── remote_datasources/
│   │   └── listing_remote_datasource.dart
│   └── remote_datasource_impl/
│       └── listing_remote_datasource_impl.dart
│
└── di/
    └── listing_injections.dart
```

---

## 🧠 Presentation Layer (Bloc)

### ListingBloc

Handles all UI-related logic for listings.

### Events

* `LoadListings(GetListingsParams params)`
* `LoadListingDetail(String id)`

### State

`ListingState` contains:

* `isLoading` – loading state for listing list
* `isSelectedListingLoading` – loading state for listing detail
* `listings` – list of listings
* `selectedListing` – selected listing detail
* `totalNumberOfListings` – total count for pagination
* `error` – error message if any

### Responsibilities

* Emit loading, success, and error states
* Call appropriate use cases
* Keep list and detail loading states separate

---

## 🧩 Domain Layer

### Entities

* **Listing** (core entity)
* **Gallery**
* **Include**
* **Faq**
* **User**

Entities are plain Dart objects and use `Equatable` where required.

---

### Repository Contract

```
ListingRepository
 ├── getListingsBySubcategory(GetListingsParams)
 └── getListingDetailById(String id)
```

The domain layer does **not** depend on Flutter or Dio.

---

### Use Cases

| Use Case                | Responsibility                |
| ----------------------- | ----------------------------- |
| GetListingsUseCase      | Fetch listings by subcategory |
| GetListingDetailUseCase | Fetch listing detail by ID    |

Each use case represents **one business action only**.

---

## 💾 Data Layer

### Models

* `ListingModel` extends `Listing`
* Responsible for converting API JSON into domain entities

---

### Remote Data Source

Responsible for making API calls.

**Endpoints used:**

* `GET /api/customer/services`
* `GET /api/customer/service/{id}`

Uses:

* `Dio`
* `NetworkHelper`

---

### Repository Implementation

`ListingRepositoryImpl`:

* Calls remote data source
* Handles exceptions
* Converts errors to `Failure`
* Returns `Either<Failure, Success>`

---

## 🔌 Dependency Injection

Uses **GetIt** for dependency management.

Registered components:

* `ListingBloc`
* `GetListingsUseCase`
* `GetListingDetailUseCase`
* `ListingRepository`
* `ListingRemoteDataSource`
* `Dio`

All registrations are located in:

```
lib/features/listing/di/listing_injections.dart
```

---

## ⚠️ Error Handling

* API errors throw `ServerException`
* Repository converts exceptions into `ServerFailure`
* Bloc converts failures into UI-friendly messages using:

```
Helpers.convertFailureToMessage(failure)
```

---

## 🚀 Example Usage (UI)

```
context.read<ListingBloc>().add(
  LoadListings(GetListingsParams(subcategoryId: 1)),
);

context.read<ListingBloc>().add(
  LoadListingDetail("12"),
);
```

---

## ✅ Key Benefits

* Clean separation of concerns
* Scalable and maintainable
* Easy to test
* Bloc handles only presentation logic
* Domain layer is framework-independent

---

## 📝 Notes

* Pagination supported via `ListingResponseModel.total`
* Safe handling for nullable API fields (`includes`, `faqs`)
* Listing equality is based on `id`

---
