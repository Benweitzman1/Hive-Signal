import { Component, OnInit, inject } from '@angular/core';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MessagesState } from '../../state/messages.state';

@Component({
  selector: 'app-message-list',
  standalone: true,
  imports: [MatCardModule, MatIconModule, MatProgressSpinnerModule],
  templateUrl: './message-list.component.html',
  styleUrl: './message-list.component.scss',
})
export class MessageListComponent implements OnInit {
  private readonly messagesState = inject(MessagesState);

  readonly messages = this.messagesState.messages;
  readonly loading = this.messagesState.loading;
  readonly error = this.messagesState.error;
  readonly hasMessages = this.messagesState.hasMessages;

  ngOnInit(): void {
    this.messagesState.loadMessages();
  }

  formatDate(dateString: string): string {
    const date = new Date(dateString);
    return new Intl.DateTimeFormat('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    }).format(date);
  }
}
