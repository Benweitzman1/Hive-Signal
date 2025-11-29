import { HttpClient } from '@angular/common/http';
import { computed, inject, Injectable, signal, Signal } from '@angular/core';
import { envConfig } from '../../../core/config/env.config';
import {
  AuthResponse,
  LoginRequest,
  RegisterRequest,
  User,
} from '../models/auth.model';

@Injectable({
  providedIn: 'root',
})
export class AuthApiService {
  private readonly http = inject(HttpClient);
  private readonly apiUrl = `${envConfig.baseApiUrl}/auth`;

  readonly user = signal<User | null>(null);
  readonly loading = signal<boolean>(false);
  readonly error = signal<string | null>(null);

  readonly isAuthenticated: Signal<boolean> = computed(
    () => this.user() !== null
  );

  register(request: RegisterRequest): void {
    this.loading.set(true);
    this.error.set(null);

    this.http.post<AuthResponse>(`${this.apiUrl}/register`, request).subscribe({
      next: (response) => {
        this.user.set(response.user);
        this.error.set(null);
        this.loading.set(false);
      },
      error: (err) => {
        const errorMessage = err.error?.error || 'Registration failed';
        this.error.set(errorMessage);
        this.loading.set(false);
      },
    });
  }

  login(request: LoginRequest): void {
    this.loading.set(true);
    this.error.set(null);

    this.http.post<AuthResponse>(`${this.apiUrl}/login`, request).subscribe({
      next: (response) => {
        this.user.set(response.user);
        this.error.set(null);
        this.loading.set(false);
      },
      error: (err) => {
        const errorMessage = err.error?.error || 'Login failed';
        this.error.set(errorMessage);
        this.loading.set(false);
      },
    });
  }

  logout(): void {
    this.loading.set(true);
    this.error.set(null);

    this.http.post<void>(`${this.apiUrl}/logout`, {}).subscribe({
      next: () => {
        this.user.set(null);
        this.error.set(null);
        this.loading.set(false);
      },
      error: (err) => {
        const errorMessage = err.error?.error || 'Logout failed';
        this.error.set(errorMessage);
        this.loading.set(false);
      },
    });
  }

  checkAuth(): void {
    this.http.get<AuthResponse>(`${this.apiUrl}/current_user`).subscribe({
      next: (response) => {
        this.user.set(response.user);
      },
      error: () => {
        this.user.set(null);
      },
    });
  }

  clearError(): void {
    this.error.set(null);
  }
}
