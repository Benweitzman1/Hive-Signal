import { Component } from '@angular/core';
import { MessageFormComponent } from './features/messages/components/message-form/message-form.component';
import { MessageListComponent } from './features/messages/components/message-list/message-list.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [MessageFormComponent, MessageListComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent {
  title = 'Hive Signal - SMS Messenger';
}
