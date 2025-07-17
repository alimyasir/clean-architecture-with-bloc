# clean-architecture-with-bloc



# Layer Responsibility Summary:

| Layer           | Purpose                                  | Depends On          |
| --------------- | ---------------------------------------- | ------------------- |
| `core/`         | Shared helpers/utilities/constants       | Nothing             |
| `data/`         | Fetches & converts raw data              | `domain/`           |
| `domain/`       | Pure business logic (entities, usecases) | Nothing             |
| `presentation/` | UI + State management                    | `domain/` + `core/` |


# This structure helps in:
✅ Benefits of This Structure
Scalability: Easily extend features or add modules

Testability: Independently test use cases and business rules

Maintainability: Enforces separation of concerns, easier to debug and refactor

Reusability: Core business logic can be reused across multiple apps or platforms

# This structure Diagram:
![Clean Architecture Diagram](https://raw.githubusercontent.com/AbdullahAlfaraj/clean-architecture-with-bloc/main/clean_architecture_diagram.png)
