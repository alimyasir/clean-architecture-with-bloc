# clean-architecture-with-bloc



# Layer Responsibility Summary:

| Layer           | Purpose                                  | Depends On          |
| --------------- | ---------------------------------------- | ------------------- |
| `core/`         | Shared helpers/utilities/constants       | Nothing             |
| `data/`         | Fetches & converts raw data              | `domain/`           |
| `domain/`       | Pure business logic (entities, usecases) | Nothing             |
| `presentation/` | UI + State management                    | `domain/` + `core/` |


# This structure helps in:

# Scalability: Easily add new features

# Testability: Unit test business logic separately

# Maintainability: Clear separation of responsibilities