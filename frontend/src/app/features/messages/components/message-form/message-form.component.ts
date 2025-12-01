import { Component, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MessagesState } from '../../state/messages.state';

@Component({
  selector: 'app-message-form',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    MatButtonModule,
    MatCardModule,
    MatFormFieldModule,
    MatInputModule,
  ],
  templateUrl: './message-form.component.html',
  styleUrl: './message-form.component.scss',
})
export class MessageFormComponent {
  private readonly fb = inject(FormBuilder);
  private readonly messagesState = inject(MessagesState);

  readonly form = this.fb.group({
    phone_number: [
      '',
      [Validators.required, Validators.pattern(/^\+?[1-9]\d{1,14}$/)],
    ],
    content: ['', [Validators.required, Validators.minLength(1)]],
  });

  readonly loading = this.messagesState.loading;

  onSubmit(): void {
    if (this.form.invalid) {
      return;
    }

    const { phone_number, content } = this.form.value;
    if (!phone_number || !content) {
      return;
    }

    this.messagesState.sendMessage({ phone_number, content });
    this.form.patchValue({ content: '' });
  }
}
