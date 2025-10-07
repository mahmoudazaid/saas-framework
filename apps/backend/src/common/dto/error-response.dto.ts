// src/common/dto/error-response.dto.ts
export class ErrorResponseDto {
  statusCode: number;
  message: string | string[];
  timestamp: string;
  path: string;
  correlationId?: string;
  details?: unknown;

  constructor(
    statusCode: number,
    message: string | string[],
    path: string,
    correlationId?: string,
    details?: unknown,
  ) {
    this.statusCode = statusCode;
    this.message = message;
    this.timestamp = new Date().toISOString();
    this.path = path;
    this.correlationId = correlationId ?? 'unknown';
    this.details = details;
  }
}
