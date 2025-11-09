# Contractor Jobs API - Complete Documentation

## Base URL
```
http://localhost:3000
```

## Authentication
Most endpoints require JWT authentication. Include the token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

---

## Table of Contents
1. [Authentication Endpoints](#authentication-endpoints)
2. [User Profile Endpoints](#user-profile-endpoints)
3. [Contractor Catalog Endpoints](#contractor-catalog-endpoints)
4. [Job Management Endpoints](#job-management-endpoints)
5. [Review Endpoints](#review-endpoints)
6. [Data Models](#data-models)
7. [Error Responses](#error-responses)

---

## Authentication Endpoints

### Register User
Creates a new user account (Client or Contractor).

**Endpoint:** `POST /auth/register`

**Authentication:** Not required

**Request Body:**
```json
{
  "email": "string (valid email format)",
  "password": "string (minimum 8 characters)",
  "firstName": "string",
  "lastName": "string",
  "role": "CLIENT" | "CONTRACTOR"
}
```

**Example Request:**
```json
{
  "email": "john.doe@example.com",
  "password": "password123",
  "firstName": "John",
  "lastName": "Doe",
  "role": "CLIENT"
}
```

**Success Response:** `201 Created`
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "john.doe@example.com",
  "password": "hashed_password_string",
  "firstName": "John",
  "lastName": "Doe",
  "role": "CLIENT",
  "createdAt": "2024-01-15T10:30:00.000Z",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

**Notes:**
- ⚠️ KNOWN ISSUE: Response includes hashed password (security concern)
- Password must be at least 8 characters
- Valid roles: `CLIENT`, `CONTRACTOR`

---

### Login
Authenticate and receive a JWT token.

**Endpoint:** `POST /auth/login`

**Authentication:** Not required

**Request Body:**
```json
{
  "email": "string (valid email format)",
  "password": "string"
}
```

**Example Request:**
```json
{
  "email": "john.doe@example.com",
  "password": "password123"
}
```

**Success Response:** `200 OK`
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Error Response:** `401 Unauthorized`
```json
{
  "statusCode": 401,
  "message": "Invalid credentials"
}
```

**Notes:**
- Token contains payload: `{sub: userId, email: userEmail, role: userRole}`
- Store the `access_token` for subsequent authenticated requests
- Token expiration is configured via environment variables

---

## User Profile Endpoints

### Get Current User Profile
Retrieves the authenticated user's profile information.

**Endpoint:** `GET /users/me`

**Authentication:** Required (JWT)

**Request Headers:**
```
Authorization: Bearer <jwt_token>
```

**Success Response:** `200 OK`
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "john.doe@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "role": "CLIENT",
  "createdAt": "2024-01-15T10:30:00.000Z",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

**Notes:**
- Password is NOT included in response (secure)
- Works for both CLIENT and CONTRACTOR roles

---

### Update Contractor Services
Updates the services offered by a contractor (CONTRACTOR only).

**Endpoint:** `PATCH /users/me/services`

**Authentication:** Required (JWT, CONTRACTOR role only)

**Request Headers:**
```
Authorization: Bearer <jwt_token>
```

**Request Body:**
```json
{
  "services": [
    {
      "name": "string",
      "description": "string",
      "rate": number
    }
  ]
}
```

**Example Request:**
```json
{
  "services": [
    {
      "name": "Plumbing",
      "description": "General plumbing services including repairs and installations",
      "rate": 75.50
    },
    {
      "name": "Emergency Plumbing",
      "description": "24/7 emergency plumbing services",
      "rate": 150.00
    }
  ]
}
```

**Success Response:** `200 OK`
```json
[
  {
    "id": "service-uuid-1",
    "name": "Plumbing",
    "description": "General plumbing services including repairs and installations",
    "rate": 75.50,
    "contractorId": "550e8400-e29b-41d4-a716-446655440000"
  },
  {
    "id": "service-uuid-2",
    "name": "Emergency Plumbing",
    "description": "24/7 emergency plumbing services",
    "rate": 150.00,
    "contractorId": "550e8400-e29b-41d4-a716-446655440000"
  }
]
```

**Error Response:** `403 Forbidden` (if user is CLIENT)
```json
{
  "statusCode": 403,
  "message": "Only contractors can update services."
}
```

**Notes:**
- ⚠️ This endpoint REPLACES all existing services (delete + recreate)
- All previous services are deleted when you call this endpoint
- Rate is a decimal number (e.g., 75.50 for $75.50/hour or per job)
- Only CONTRACTOR role can access this endpoint

---

## Contractor Catalog Endpoints

### List All Contractors
Browse all available contractors and their services (Public endpoint).

**Endpoint:** `GET /workers`

**Authentication:** Not required

**Success Response:** `200 OK`
```json
[
  {
    "id": "contractor-uuid-1",
    "email": "plumber@example.com",
    "firstName": "Mike",
    "lastName": "Johnson",
    "role": "CONTRACTOR",
    "services": [
      {
        "id": "service-uuid-1",
        "name": "Plumbing",
        "description": "General plumbing services",
        "rate": 75.50,
        "contractorId": "contractor-uuid-1"
      }
    ],
    "reviewsAsContractor": [
      {
        "id": "review-uuid-1",
        "rating": 5,
        "comment": "Excellent work!",
        "createdAt": "2024-01-10T15:00:00.000Z",
        "jobId": "job-uuid-1",
        "clientId": "client-uuid-1",
        "contractorId": "contractor-uuid-1"
      }
    ]
  }
]
```

**Notes:**
- Public endpoint - no authentication needed
- Returns only users with role CONTRACTOR
- Includes all services and reviews for each contractor
- Frontend can filter/search by service type

---

### Get Specific Contractor
Retrieve details for a single contractor (Public endpoint).

**Endpoint:** `GET /workers/:id`

**Authentication:** Not required

**URL Parameters:**
- `id` (string, required): Contractor's UUID

**Example Request:**
```
GET /workers/550e8400-e29b-41d4-a716-446655440000
```

**Success Response:** `200 OK`
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "plumber@example.com",
  "firstName": "Mike",
  "lastName": "Johnson",
  "role": "CONTRACTOR",
  "services": [
    {
      "id": "service-uuid-1",
      "name": "Plumbing",
      "description": "General plumbing services",
      "rate": 75.50,
      "contractorId": "550e8400-e29b-41d4-a716-446655440000"
    }
  ],
  "reviewsAsContractor": [
    {
      "id": "review-uuid-1",
      "rating": 5,
      "comment": "Excellent work!",
      "createdAt": "2024-01-10T15:00:00.000Z",
      "jobId": "job-uuid-1",
      "clientId": "client-uuid-1",
      "contractorId": "550e8400-e29b-41d4-a716-446655440000"
    }
  ]
}
```

**Error Response:** Returns `null` if contractor not found

**Notes:**
- Public endpoint - no authentication needed
- Returns null if ID doesn't exist or user is not a CONTRACTOR
- Use this to show contractor profile page

---

## Job Management Endpoints

### Create Job
Create a new job posting (CLIENT only).

**Endpoint:** `POST /jobs`

**Authentication:** Required (JWT, CLIENT role only)

**Request Headers:**
```
Authorization: Bearer <jwt_token>
```

**Request Body:**
```json
{
  "serviceId": "string (UUID)",
  "description": "string"
}
```

**Example Request:**
```json
{
  "serviceId": "service-uuid-1",
  "description": "Need to fix a leaking kitchen faucet urgently"
}
```

**Success Response:** `201 Created`
```json
{
  "id": "job-uuid-1",
  "description": "Need to fix a leaking kitchen faucet urgently",
  "status": "PENDING",
  "createdAt": "2024-01-15T14:30:00.000Z",
  "updatedAt": "2024-01-15T14:30:00.000Z",
  "clientId": "client-uuid-1",
  "contractorId": "contractor-uuid-1",
  "serviceId": "service-uuid-1"
}
```

**Error Responses:**

`403 Forbidden` (if user is CONTRACTOR):
```json
{
  "statusCode": 403,
  "message": "Only clients can create jobs."
}
```

`404 Not Found` (if service doesn't exist):
```json
{
  "statusCode": 404,
  "message": "Service not found"
}
```

**Notes:**
- Only CLIENT role can create jobs
- `serviceId` must be a valid UUID from the catalog
- Job status starts as `PENDING`
- The contractor is automatically assigned based on the service owner

---

### List Jobs
Get jobs filtered by user role (CLIENT or CONTRACTOR).

**Endpoint:** `GET /jobs`

**Authentication:** Required (JWT)

**Request Headers:**
```
Authorization: Bearer <jwt_token>
```

**Success Response:** `200 OK`

**For CLIENTS** (returns their own jobs):
```json
[
  {
    "id": "job-uuid-1",
    "description": "Need to fix a leaking kitchen faucet",
    "status": "PENDING",
    "createdAt": "2024-01-15T14:30:00.000Z",
    "updatedAt": "2024-01-15T14:30:00.000Z",
    "clientId": "client-uuid-1",
    "contractorId": "contractor-uuid-1",
    "serviceId": "service-uuid-1"
  }
]
```

**For CONTRACTORS** (returns ALL pending jobs):
```json
[
  {
    "id": "job-uuid-2",
    "description": "Install new bathroom sink",
    "status": "PENDING",
    "createdAt": "2024-01-15T15:00:00.000Z",
    "updatedAt": "2024-01-15T15:00:00.000Z",
    "clientId": "client-uuid-2",
    "contractorId": "contractor-uuid-1",
    "serviceId": "service-uuid-2"
  }
]
```

**Notes:**
- ⚠️ KNOWN ISSUE: Contractors see ALL pending jobs, not just jobs matching their services
- For CLIENTS: Returns all jobs created by that client (any status)
- For CONTRACTORS: Returns only jobs with status PENDING (from all contractors)
- Response does NOT include nested client/contractor/service objects
- You may need additional API calls to get related data

---

### Accept Job
Contractor accepts a pending job (CONTRACTOR only).

**Endpoint:** `PATCH /jobs/:id/accept`

**Authentication:** Required (JWT, CONTRACTOR role only)

**Request Headers:**
```
Authorization: Bearer <jwt_token>
```

**URL Parameters:**
- `id` (string, required): Job UUID

**Example Request:**
```
PATCH /jobs/job-uuid-1/accept
```

**Success Response:** `200 OK`
```json
{
  "id": "job-uuid-1",
  "description": "Need to fix a leaking kitchen faucet",
  "status": "ACCEPTED",
  "createdAt": "2024-01-15T14:30:00.000Z",
  "updatedAt": "2024-01-15T16:00:00.000Z",
  "clientId": "client-uuid-1",
  "contractorId": "contractor-uuid-1",
  "serviceId": "service-uuid-1"
}
```

**Error Responses:**

`403 Forbidden` (if user is CLIENT):
```json
{
  "statusCode": 403,
  "message": "Only contractors can accept jobs."
}
```

`403 Forbidden` (if job is not assigned to this contractor):
```json
{
  "statusCode": 403,
  "message": "You are not allowed to accept this job."
}
```

`403 Forbidden` (if job is not PENDING):
```json
{
  "statusCode": 403,
  "message": "This job is not pending."
}
```

**Notes:**
- Only CONTRACTOR role can accept jobs
- Job must be in PENDING status
- Job must be assigned to the requesting contractor
- Status changes from PENDING → ACCEPTED

---

### Complete Job
Contractor marks a job as completed (CONTRACTOR only).

**Endpoint:** `PATCH /jobs/:id/complete`

**Authentication:** Required (JWT, CONTRACTOR role only)

**Request Headers:**
```
Authorization: Bearer <jwt_token>
```

**URL Parameters:**
- `id` (string, required): Job UUID

**Example Request:**
```
PATCH /jobs/job-uuid-1/complete
```

**Success Response:** `200 OK`
```json
{
  "id": "job-uuid-1",
  "description": "Need to fix a leaking kitchen faucet",
  "status": "COMPLETED",
  "createdAt": "2024-01-15T14:30:00.000Z",
  "updatedAt": "2024-01-15T18:00:00.000Z",
  "clientId": "client-uuid-1",
  "contractorId": "contractor-uuid-1",
  "serviceId": "service-uuid-1"
}
```

**Error Responses:**

`403 Forbidden` (if user is CLIENT):
```json
{
  "statusCode": 403,
  "message": "Only contractors can complete jobs."
}
```

`403 Forbidden` (if job is not assigned to this contractor):
```json
{
  "statusCode": 403,
  "message": "You are not allowed to complete this job."
}
```

`403 Forbidden` (if job is not ACCEPTED):
```json
{
  "statusCode": 403,
  "message": "This job is not accepted."
}
```

**Notes:**
- Only CONTRACTOR role can complete jobs
- Job must be in ACCEPTED status
- Job must be assigned to the requesting contractor
- Status changes from ACCEPTED → COMPLETED
- After completion, client can leave a review

---

### Cancel Job
Cancel a job (CLIENT or CONTRACTOR).

**Endpoint:** `PATCH /jobs/:id/cancel`

**Authentication:** Required (JWT)

**Request Headers:**
```
Authorization: Bearer <jwt_token>
```

**URL Parameters:**
- `id` (string, required): Job UUID

**Example Request:**
```
PATCH /jobs/job-uuid-1/cancel
```

**Success Response:** `200 OK`
```json
{
  "id": "job-uuid-1",
  "description": "Need to fix a leaking kitchen faucet",
  "status": "CANCELLED",
  "createdAt": "2024-01-15T14:30:00.000Z",
  "updatedAt": "2024-01-15T17:00:00.000Z",
  "clientId": "client-uuid-1",
  "contractorId": "contractor-uuid-1",
  "serviceId": "service-uuid-1"
}
```

**Error Response:**

`403 Forbidden` (if user is not the client or contractor of this job):
```json
{
  "statusCode": 403,
  "message": "You are not allowed to cancel this job."
}
```

**Notes:**
- Both CLIENT and CONTRACTOR can cancel jobs
- Can only cancel your own jobs (as client or assigned contractor)
- Works from any status (PENDING, ACCEPTED, COMPLETED)
- Status changes to CANCELLED

---

## Review Endpoints

### Create Review
Create a review for a completed job (CLIENT only).

**Endpoint:** `POST /reviews`

**Authentication:** Required (JWT, CLIENT role only)

**Request Headers:**
```
Authorization: Bearer <jwt_token>
```

**Request Body:**
```json
{
  "rating": number (1-5),
  "comment": "string",
  "jobId": "string (UUID)"
}
```

**Example Request:**
```json
{
  "rating": 5,
  "comment": "Excellent work! Very professional and quick.",
  "jobId": "job-uuid-1"
}
```

**Success Response:** `201 Created`
```json
{
  "id": "review-uuid-1",
  "rating": 5,
  "comment": "Excellent work! Very professional and quick.",
  "createdAt": "2024-01-15T19:00:00.000Z",
  "jobId": "job-uuid-1",
  "clientId": "client-uuid-1",
  "contractorId": "contractor-uuid-1"
}
```

**Error Responses:**

`403 Forbidden` (if user is CONTRACTOR):
```json
{
  "statusCode": 403,
  "message": "Only clients can create reviews."
}
```

`403 Forbidden` (if job doesn't belong to this client):
```json
{
  "statusCode": 403,
  "message": "You are not allowed to review this job."
}
```

`403 Forbidden` (if job is not COMPLETED):
```json
{
  "statusCode": 403,
  "message": "You can only review completed jobs."
}
```

`403 Forbidden` (if review already exists for this job):
```json
{
  "statusCode": 403,
  "message": "A review for this job already exists."
}
```

**Validation Errors:**

`400 Bad Request` (if rating is not 1-5):
```json
{
  "statusCode": 400,
  "message": ["rating must not be greater than 5", "rating must not be less than 1"]
}
```

**Notes:**
- Only CLIENT role can create reviews
- Job must be in COMPLETED status
- Job must belong to the requesting client
- One review per job (no duplicates)
- Rating must be an integer between 1 and 5
- `contractorId` is automatically set from the job

---

## Data Models

### User
```typescript
{
  id: string;                    // UUID
  email: string;                 // Unique email
  firstName: string;
  lastName: string;
  role: "CLIENT" | "CONTRACTOR"; // User role
  createdAt: string;             // ISO 8601 datetime
  updatedAt: string;             // ISO 8601 datetime
}
```

### Service
```typescript
{
  id: string;           // UUID
  name: string;         // Service name (e.g., "Plumbing")
  description: string;  // Service description
  rate: number;         // Hourly or project rate
  contractorId: string; // UUID of contractor offering service
}
```

### Job
```typescript
{
  id: string;                                     // UUID
  description: string;                            // Job details
  status: "PENDING" | "ACCEPTED" | "COMPLETED" | "CANCELLED";
  createdAt: string;                              // ISO 8601 datetime
  updatedAt: string;                              // ISO 8601 datetime
  clientId: string;                               // UUID of client
  contractorId: string;                           // UUID of contractor
  serviceId: string;                              // UUID of service
}
```

### Review
```typescript
{
  id: string;           // UUID
  rating: number;       // 1-5 stars
  comment: string;      // Review text
  createdAt: string;    // ISO 8601 datetime
  jobId: string;        // UUID of job (unique)
  clientId: string;     // UUID of client who wrote review
  contractorId: string; // UUID of contractor being reviewed
}
```

---

## Error Responses

### Validation Errors
**Status Code:** `400 Bad Request`

```json
{
  "statusCode": 400,
  "message": [
    "email must be an email",
    "password must be longer than or equal to 8 characters"
  ],
  "error": "Bad Request"
}
```

### Authentication Errors
**Status Code:** `401 Unauthorized`

```json
{
  "statusCode": 401,
  "message": "Unauthorized"
}
```

### Authorization Errors
**Status Code:** `403 Forbidden`

```json
{
  "statusCode": 403,
  "message": "Only contractors can accept jobs."
}
```

### Not Found Errors
**Status Code:** `404 Not Found`

```json
{
  "statusCode": 404,
  "message": "Service not found"
}
```

### Server Errors
**Status Code:** `500 Internal Server Error`

```json
{
  "statusCode": 500,
  "message": "Internal server error"
}
```

---

## Job Lifecycle Flow

```
1. CLIENT creates job
   ↓
   Status: PENDING
   ↓
2. CONTRACTOR accepts job
   ↓
   Status: ACCEPTED
   ↓
3. CONTRACTOR completes job
   ↓
   Status: COMPLETED
   ↓
4. CLIENT creates review (optional)

Alternative:
- Either party can cancel at any time
  ↓
  Status: CANCELLED
```

---

## Authentication Flow

```
1. Register user (POST /auth/register)
   ↓
2. Login (POST /auth/login)
   ↓
3. Receive access_token
   ↓
4. Include token in Authorization header for protected endpoints
   Authorization: Bearer <access_token>
```

---

## Common Use Cases

### As a CLIENT:
1. Register → Login → Get token
2. Browse contractors: `GET /workers`
3. View contractor details: `GET /workers/:id`
4. Create job: `POST /jobs` (with serviceId from contractor)
5. View my jobs: `GET /jobs`
6. Cancel job: `PATCH /jobs/:id/cancel`
7. Review completed job: `POST /reviews`

### As a CONTRACTOR:
1. Register → Login → Get token
2. Add/update services: `PATCH /users/me/services`
3. View available jobs: `GET /jobs` (shows all pending jobs)
4. Accept job: `PATCH /jobs/:id/accept`
5. Complete job: `PATCH /jobs/:id/complete`
6. Cancel job: `PATCH /jobs/:id/cancel`

---

## Environment Variables Required

```env
DATABASE_URL=postgresql://user:password@localhost:5432/contractors_db
JWT_SECRET=your_secret_key_here
JWT_EXPIRES_IN=24h
PORT=3000
```

---

## Known Issues / Limitations

1. **Password Exposure in Registration**: The `/auth/register` endpoint returns the hashed password in the response. This should be removed for security.

2. **Contractor Job Discovery Bug**: The `GET /jobs` endpoint for contractors returns ALL pending jobs, not filtered by contractor's service offerings. Contractors will see jobs outside their specialty.

3. **Missing Relationship Data**: Job listings don't include nested client/contractor/service details. Frontend may need to make additional API calls or this should be enhanced with Prisma includes.

4. **Service Updates Delete All**: The `PATCH /users/me/services` endpoint deletes all existing services before creating new ones. This is a full replacement operation, not a partial update.

5. **No Payment Integration**: As mentioned, this is a class project with no actual payment handling.

6. **No Pagination**: All list endpoints return all records without pagination. This could be problematic with large datasets.

---

## Testing Tips

### Using cURL:

**Register:**
```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "firstName": "Test",
    "lastName": "User",
    "role": "CLIENT"
  }'
```

**Login:**
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

**Get Profile (with auth):**
```bash
curl -X GET http://localhost:3000/users/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Using Postman:
1. Create an environment variable for `token`
2. Set it after login from `{{access_token}}`
3. Use `{{token}}` in Authorization header as Bearer token

---

## Support

For issues or questions, contact the backend team or refer to the source code at:
- Controllers: `/src/**/**.controller.ts`
- Services: `/src/**/**.service.ts`
- DTOs: `/src/**/dto/**.dto.ts`
- Database Schema: `/prisma/schema.prisma`

---

**Document Version:** 1.0
**Last Updated:** 2024-01-15
**API Version:** 1.0
