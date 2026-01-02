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
