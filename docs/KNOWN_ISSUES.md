# Known Issues and Solutions

## 302 Redirect Issue with Initial API Requests

### Issue Description

When the app first initializes, the initial GET request to fetch transactions returns a 302 (Redirect) status code, causing the transactions not to load. However, after making a POST request (e.g., adding a transaction), subsequent GET requests work correctly with 200 status code.

**Observed Behavior:**

1. Initial Request:

```
GET http://localhost:8080/api/v0/transactions/{userId}
Status: 302 Redirect
```

2. After POST Request:

```
GET http://localhost:8080/api/v0/transactions/{userId}
Status: 200 Success
Response: {transactions: [...]}
```

### Temporary Solution

We've implemented a retry mechanism in the Dio HTTP client configuration (`lib/src/core/network/dio_config.dart`):

```dart
if (error.response?.statusCode == 302 &&
    error.requestOptions.extra['retried'] != true) {
  final options = error.requestOptions;
  options.extra['retried'] = true;

  try {
    final response = await dio.fetch(options);
    return handler.resolve(response);
  } catch (e) {
    return handler.next(error);
  }
}
```

This solution:

1. Detects 302 redirect responses
2. Retries the request once if it hasn't been retried before
3. Uses the same request options for the retry

### Possible Root Causes

1. **Session Initialization**: The backend might require a session to be established before serving requests
2. **CORS Setup**: CORS headers might not be properly set up on the first request
3. **Backend Middleware**: Some middleware might need a "warm-up" request
4. **Authentication Flow**: There might be an authentication/authorization flow that's not properly handled

### Recommended Long-term Solutions

#### Frontend Solutions

1. **Pre-flight Request**:

   - Make a lightweight ping request when the app starts
   - Wait for successful response before making actual API calls

2. **Authentication Handler**:

   - Implement proper authentication flow
   - Store and manage authentication tokens
   - Add authentication interceptor to Dio

3. **Retry Strategy**:
   - Implement a more sophisticated retry strategy with exponential backoff
   - Handle different types of errors differently

#### Backend Solutions

1. **Session Management**:

   - Review session initialization process
   - Consider making the API stateless if possible
   - Implement proper session handling

2. **CORS Configuration**:

   - Configure CORS properly for all routes
   - Add necessary CORS headers to all responses

   ```javascript
   app.use(
     cors({
       origin: "http://localhost:3000",
       credentials: true,
     })
   );
   ```

3. **Authentication Flow**:

   - Implement proper JWT or session-based authentication
   - Add clear error responses for unauthorized requests
   - Consider using refresh tokens

4. **Middleware Order**:
   - Review middleware execution order
   - Ensure authentication/authorization checks happen in correct order
   - Add proper error handling in middleware

### Next Steps

1. Monitor if the retry solution causes any side effects
2. Investigate backend logs during the 302 redirect
3. Consider implementing one of the long-term solutions based on root cause
4. Add proper error tracking and monitoring

### Related Files

- `lib/src/core/network/dio_config.dart`
- `lib/src/features/transaction/data/data_sources/remote/transaction_remote_data_source.dart`
- Backend API routes and middleware configuration
