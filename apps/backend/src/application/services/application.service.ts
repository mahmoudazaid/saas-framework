// src/application/services/application.service.ts
import { Injectable, Logger } from '@nestjs/common';
import { EventBus, DomainEvent } from '../../core/events/domain-event';

@Injectable()
export abstract class ApplicationService {
  protected readonly logger = new Logger(ApplicationService.name);
  
  constructor(protected eventBus: EventBus) {}

  protected async publishEvents(events: DomainEvent[]): Promise<void> {
    try {
      for (const event of events) {
        await this.eventBus.publish(event);
      }
    } catch (error) {
      // Log error but don't throw to avoid breaking the main flow
      this.logger.error('Failed to publish domain events:', error);
      throw new Error(`Failed to publish domain events: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }
}
