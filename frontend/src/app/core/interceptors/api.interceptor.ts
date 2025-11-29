import { HttpErrorResponse, HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { catchError, throwError } from 'rxjs';
import { AuthApiService } from '../../features/auth/services/auth.api.service';

export const apiInterceptor: HttpInterceptorFn = (req, next) => {
  const authService = inject(AuthApiService);

  const modifiedReq = req.clone({
    withCredentials: true,
  });

  return next(modifiedReq).pipe(
    catchError((error: HttpErrorResponse) => {
      if (
        error.status === 401 &&
        !req.url.includes('/auth/login') &&
        !req.url.includes('/auth/register')
      ) {
        authService.user.set(null);
      }
      return throwError(() => error);
    })
  );
};
