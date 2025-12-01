import { Component, OnInit, inject } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { LoginComponent } from './features/auth/components/login/login.component';
import { AuthApiService } from './features/auth/services/auth.api.service';
import { MessageFormComponent } from './features/messages/components/message-form/message-form.component';
import { MessageListComponent } from './features/messages/components/message-list/message-list.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    MatButtonModule,
    LoginComponent,
    MessageFormComponent,
    MessageListComponent,
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent implements OnInit {
  private readonly authService = inject(AuthApiService);

  readonly title = 'Hive Signal';
  readonly isAuthenticated = this.authService.isAuthenticated;
  readonly user = this.authService.user;
  readonly checkingAuth = this.authService.checkingAuth;

  ngOnInit(): void {
    this.authService.checkAuth();
  }

  logout(): void {
    this.authService.logout();
  }
}
