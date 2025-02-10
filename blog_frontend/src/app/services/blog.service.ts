import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class BlogService {
  private apiUrl = process.env.API_URL || 'http://localhost:8000/api/posts/';

  constructor(private http: HttpClient) {}

  getPosts(): Observable<any> {
    return this.http.get(this.apiUrl);
  }

  getPost(id: number): Observable<any> {
    return this.http.get(`${this.apiUrl}${id}/`);
  }
}