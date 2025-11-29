import { computed, inject, Injectable, signal, Signal } from '@angular/core';
import { Message, SendMessageRequest } from '../models/message.model';
import { MessagesApiService } from '../services/messages.api.service';

@Injectable({ providedIn: 'root' })
export class MessagesState {
  private readonly apiService = inject(MessagesApiService);

  readonly messages = signal<Message[]>([]);
  readonly loading = signal<boolean>(false);
  readonly error = signal<string | null>(null);

  readonly hasMessages: Signal<boolean> = computed(
    () => this.messages().length > 0
  );
  readonly messageCount: Signal<number> = computed(
    () => this.messages().length
  );

  loadMessages(): void {
    this.loading.set(true);
    this.error.set(null);

    this.apiService.getMessages().subscribe({
      next: (msgs) => {
        this.messages.set(msgs);
        this.error.set(null);
        this.loading.set(false);
      },
      error: (err) => {
        const errorMessage = err.error?.error || 'Failed to load messages';
        this.error.set(errorMessage);
        this.loading.set(false);
      },
    });
  }

  sendMessage(request: SendMessageRequest): void {
    this.loading.set(true);
    this.error.set(null);

    this.apiService.sendMessage(request).subscribe({
      next: (message) => {
        console.warn('=== BEFORE UPDATE ===');
        console.warn('Current messages:', this.messages());
        console.warn('New message:', message);

        // this.messages.update((msgs) => [message, ...msgs]);

        this.messages.update((msgs) => {
          const newList = [...msgs, message];
          console.warn('=== AFTER UPDATE ===');
          console.warn('Updated messages:', newList);
          console.warn('New message position:', newList.indexOf(message));
          return newList;
        });

        console.warn('=== SIGNAL UPDATED ===');
        console.warn('Final state:', this.messages());

        this.error.set(null);
        this.loading.set(false);
        this.loadMessages();
      },
      error: (err) => {
        const errorMessage = err.error?.error || 'Failed to send message';
        this.error.set(errorMessage);
        this.loading.set(false);
      },
    });
  }

  reset(): void {
    this.messages.set([]);
    this.loading.set(false);
    this.error.set(null);
  }
}
