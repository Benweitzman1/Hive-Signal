export interface Message {
  id: string;
  phone_number: string;
  content: string;
  created_at: string;
}

export interface SendMessageRequest {
  phone_number: string;
  content: string;
}

