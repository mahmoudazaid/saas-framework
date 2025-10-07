// src/infrastructure/external-services/external-service.interface.ts
// Base interface for external services
export interface IExternalService {
  isHealthy(): Promise<boolean>;
}

// Notification service interface
export interface INotificationService extends IExternalService {
  sendPushNotification(token: string, title: string, body: string, data?: Record<string, unknown>): Promise<void>;
  sendEmail(to: string, subject: string, body: string): Promise<void>;
}

// Payment service interface
export interface IPaymentService extends IExternalService {
  createCustomer(email: string, name: string): Promise<string>;
  createSubscription(customerId: string, priceId: string): Promise<string>;
  cancelSubscription(subscriptionId: string): Promise<void>;
}

// Storage service interface
export interface IStorageService extends IExternalService {
  uploadFile(file: Buffer, key: string): Promise<string>;
  deleteFile(key: string): Promise<void>;
  getSignedUrl(key: string, expiresIn?: number): Promise<string>;
}
