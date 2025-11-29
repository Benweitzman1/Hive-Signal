import { environment } from '../../../environments/environment';

export const envConfig = {
  baseApiUrl: environment.apiUrl,
} as const;
