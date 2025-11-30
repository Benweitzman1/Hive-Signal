import { Component, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { AuthApiService } from '../../services/auth.api.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    MatButtonModule,
    MatCardModule,
    MatFormFieldModule,
    MatIconModule,
    MatInputModule,
  ],
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss',
})
export class LoginComponent {
  private readonly fb = inject(FormBuilder);
  private readonly authService = inject(AuthApiService);

  readonly form = this.fb.group({
    username: ['', [Validators.required, Validators.minLength(3)]],
    password: ['', [Validators.required, Validators.minLength(6)]],
  });

  constructor() {
    // Clear error when user starts typing
    this.form.valueChanges.subscribe(() => {
      if (this.error()) {
        this.authService.clearError();
      }
    });
  }

  readonly loading = this.authService.loading;
  readonly error = this.authService.error;
  readonly isRegisterMode = signal<boolean>(false);

  onSubmit(): void {
    if (this.form.invalid) {
      return;
    }

    const { username, password } = this.form.value;
    if (this.isRegisterMode()) {
      this.authService.register({ username: username!, password: password! });
    } else {
      this.authService.login({ username: username!, password: password! });
    }
  }

  toggleMode(): void {
    this.isRegisterMode.update((mode) => !mode);
    this.authService.clearError();
  }
}
