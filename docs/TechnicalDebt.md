# Technical Debt

This document tracks known technical debt in the project that needs to be addressed in future iterations.

## Security

### Insecure Token Storage

- **Issue**: Authentication tokens (JWT token, refresh token) and user ID are currently stored in plain text in localStorage
- **Risk Level**: High
- **Impact**: Vulnerable to XSS attacks that could steal user credentials and hijack sessions
- **Proposed Solution**:
  - Store tokens in HttpOnly cookies instead of localStorage
  - Implement proper encryption for sensitive data if client-side storage is required
  - Consider using more secure alternatives like session storage with additional security measures
- **Status**: To be addressed
- **Created**: [25/03/2025]
