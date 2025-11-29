import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { envConfig } from '../../../core/config/env.config';
import { Message, SendMessageRequest } from '../models/message.model';

@Injectable({
  providedIn: 'root',
})
export class MessagesApiService {
  private readonly http = inject(HttpClient);
  private readonly apiUrl = `${envConfig.baseApiUrl}/messages`;

  sendMessage(request: SendMessageRequest): Observable<Message> {
    return this.http.post<Message>(this.apiUrl, request);
  }

  getMessages(): Observable<Message[]> {
    return this.http.get<Message[]>(this.apiUrl);
  }
}
