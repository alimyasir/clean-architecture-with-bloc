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
![Clean Architecture Diagram](https://cdn.prod.website-files.com/5d2dd7e1b4a76d8b803ac1aa/6399591cfc0ba9bf4a25e4a1_zUWWjTnrEREPUEE-VYxaDuJ_-GwE5UR5uikYAqzBXtox7FiAYsODfTcV7F0Zi-KCaxWiq0rodOW2KrAJw6154jRFALdlKitzXUCQ2DpTHXvQi17d8_oBhjfLYZNG4aU7EjR5XresLtOdx3V8M8eOI7JHVYcnE0IOaYnXVk6dMT3Ed6uEmmPdsXsMVsbz.png)
