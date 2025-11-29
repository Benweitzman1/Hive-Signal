export interface Message {
  id: string;
  phone_number: string;
  content: string;
  created_at: string;
  session_id: string;
}

export interface SendMessageRequest {
  phone_number: string;
  content: string;
}

