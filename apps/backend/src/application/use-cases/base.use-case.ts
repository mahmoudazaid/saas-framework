// src/application/use-cases/base.use-case.ts
import { DomainEvent } from '../../core/events/domain-event';

export abstract class UseCase<TRequest, TResponse> {
  abstract execute(request: TRequest): Promise<TResponse>;
}

export abstract class CommandUseCase<TRequest, TResponse> extends UseCase<TRequest, TResponse> {
  protected publishEvents(_events: DomainEvent[]): void {
    // Implementation will be injected via DI
    void _events;
  }
}

export abstract class QueryUseCase<TRequest, TResponse> extends UseCase<TRequest, TResponse> {
  // Query use cases typically don't publish events
}
