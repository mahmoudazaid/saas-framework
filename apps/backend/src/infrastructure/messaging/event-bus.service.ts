// src/infrastructure/messaging/event-bus.service.ts
import { Injectable, Logger } from '@nestjs/common';
import { EventBus, DomainEvent, EventHandler } from '../../core/events/domain-event';

@Injectable()
export class EventBusService implements EventBus {
  private readonly logger = new Logger(EventBusService.name);
  private handlers = new Map<string, EventHandler<DomainEvent>[]>();

  async publish(event: DomainEvent): Promise<void> {
    const eventType = event.constructor.name;
    const handlers = this.handlers.get(eventType) ?? [];
    
    for (const handler of handlers) {
      try {
        await handler.handle(event);
      } catch (error) {
        this.logger.error(`Error handling event ${eventType}:`, error);
        // In production, you might want to use a dead letter queue
      }
    }
  }

  subscribe<T extends DomainEvent>(eventType: string, handler: EventHandler<T>): void {
    if (!this.handlers.has(eventType)) {
      this.handlers.set(eventType, []);
    }
    this.handlers.get(eventType)!.push(handler);
  }
}
