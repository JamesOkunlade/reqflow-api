When it became apparent I would be proceeding with the finance squad I tasked myself with thinking of a simple solution I could use to describe an idea of my level of mastery of a few of the required skills. 


This is ## ReqFlow.  A simple request and approval tool.

### Overview

The idea is simple, a user can make a request of an amount for anything and when three other users with a higher clearance level than the requester approve, the requested amount is released in form of a preloaded virtual card (this part has not been implemented yet). The focus of this project is not on the validity of the idea but on the technical tools and choices and also an atempt to describe the barest minimum in terms of proactiveness, requirements definition, ownership, autonomy and good soft communication skills which are all necessary for the role of a product-minded senior engineer.


### Features

- **User Management**: Users can log in, view profiles, and manage requests.
- **Request Management**: Users can create, update, delete, and view requests with various states.
- **Approval Management**: Higher clearance users can approve or reject requests.

### User Stories and Requirements

- A User, who could be an employee of the company, can log on to the system.
- A User can view all Requests made by other users publicly, including descriptions of the requested amounts and their current status.
- Status states include: requested, approval_initiated, approved, and rejected. Users can see who initiated, approved, or rejected a Request.
- A User can create a new Request with a title, description, and amount.
- A User can update their own Request that is still in the requested state.
- A User cannot update a Request in approval_initiated, approved, or rejected states.
- A User can delete their own Request that is still in the requested state.
- A User cannot delete a Request in approval_initiated, approved, or rejected states.
- A User can view a list of all Approvals, including approved and rejected ones.
- A User can view their own profile.
- Users with higher clearance levels than the requester can approve or reject a Request once.
- An approval user (one who has approved or rejected) for a Request must be unique.

### Request States and Transitions

- A Request starts in the state :requested upon creation.
- It requires three approvals to transition from :requested to :approval_initiated and finally to :approved.
- A Request with one or two approvals remains in :approval_initiated state, indicating pending approvals.
- Once approved by three users, a Request transitions to :approved state.
- If rejected by any approval user, the Request enters a final state; no further actions or approvals are possible.


### API Endpoints

- **Requests**
  - `GET /requests` - Fetch list of requests
  - `POST /requests` - Create a new request
  - `GET /requests/:id` - Fetch a single request
  - `PUT /requests/:id` - Update a request
  - `DELETE /requests/:id` - Delete a request

- **Approvals**
  - `GET /approvals` - Fetch list of approvals
  - `POST /approvals/:id/approve` - Approve a pending approval
  - `POST /approvals/:id/reject` - Reject a pending approval

- **Authentication**
  - `POST /auth/login` - Login a user
  - `POST /signup` - Create a new user

### Models and Associations

- **User**
  - `has_many :requests`
  - `has_many :approval_users`
  - `has_many :approvals, through: :approval_users`

- **Request**
  - `belongs_to :user`
  - `has_many :approvals`
  - `has_one :pending_approval, -> { where(status: 'pending') }, class_name: 'Approval'`

- **Approval**
  - `belongs_to :request`
  - `has_one :approval_user`
  - `has_one :user, through: :approval_user`

- **ApprovalUser**
  - `belongs_to :approval`
  - `belongs_to :user`


### Technological Choices

#### Authentication and Authorization

- **Token-based Authentication:** Implemented using the jwt gem for managing JSON Web Tokens (JWT). The User model handles user storage, and the authentication system is structured with four service classes:
  - **JsonWebToken:** Handles encoding and decoding JWT tokens.
  - **AuthorizeApiRequest:** Ensures API calls are authorized with valid tokens and user payloads.
  - **AuthenticationController:** Manages the authentication process.
  - **AuthenticateUser:** Performs user authentication.

- **JWT Singleton:** Provides methods for token encoding and decoding. Encoding uses Rails' unique secret key for signing tokens. Decoding handles token validation and expiration, with JWT raising exceptions handled by an ExceptionHandler module.

- **Message Handling:** Non-domain specific messages are stored in a singleton `Message` class, co-located with `JsonWebToken.rb` and `ApiVersion.rb` files in `app/lib`.

#### Versioning

- **API Versioning:** Even for internal projects, versioning APIs is crucial to manage breaking changes. Implemented by adding a route constraint based on request headers and organizing controllers into different modules.
  
- **ApiVersion Class:** Checks API version from headers and routes requests to appropriate controller modules. Implements content negotiation via `Accept` headers to handle requested or default versions. Nonexistent versions default to `v1` as per Rails conventions.

#### Serializers

- **Active Model Serializers:** Used for defining custom JSON representations of model attributes and relationships. Simplifies serialization by specifying whitelists of attributes and model associations.

#### State Machine (AASM)

- **AASM Gem:** Manages state transitions for `Request` and `Approval` models, ensuring defined flows from creation through approval or rejection.


- **Request Model**
  - **States**: `:requested`, `:approval_initiated`, `:approved`, `:rejected`
  - **Transitions**:
    - Initial state is `:requested`
    - Transitions to `:approval_initiated` after one or two approvals
    - Transitions to `:approved` after three approvals
    - Transitions to `:rejected` if any approval is rejected

- **Approval Model**
  - **States**: `:pending`, `:approved`, `:rejected`
  - **Transitions**:
    - Initial state is `:pending`
    - Transitions to `:approved` if approved by a user
    - Transitions to `:rejected` if rejected by a user


### Dependencies

- **Ruby on Rails**: 7.1.3
- **Ruby**: 3.2.2
- **PostgreSQL**: Relational database
- **RSpec**: Testing framework
- **Factory Bot Rails**: Test data generation
- **Shoulda Matchers**: Additional matchers for testing
- **Database Cleaner**: Ensures clean state in test database
- **JWT**: Token-based authentication
- **BCrypt**: Password hashing
- **AASM**: State machine for managing states and transitions
- **Active Model Serializers**: JSON serialization
- **Pundit**: Authorization policies
- **Money-Rails**: Handling monetary values
- **Rack-CORS**: Cross-Origin Resource Sharing
