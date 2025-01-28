# Part 1: REST API Implementation

## Objective
Develop a REST API to manage deposits, withdrawals, and transfers in a banking system, using a MySQL database, Ruby on Rails, hexagonal architecture, and clean code principles.

### Technologies Used
- Ruby
- Rails
- MySQL
- Libraries: rspec (for unit testing)

### API Endpoints

#### 1. Deposit Money
**Endpoint**: `POST /api/accounts/:id/deposit`

**Request**:
```json
{
  "amount": 1000
}
```

**Response**:
- Success (200):
```json
{
  "message": "Deposit successful",
  "balance": 2000
}
```
- Validation Error (400):
```json
{
  "error": "Amount must be greater than 0"
}
```

#### 2. Withdraw Money
**Endpoint**: `POST /api/accounts/:id/withdraw`

**Request**:
```json
{
  "amount": 500
}
```

**Response**:
- Success (200):
```json
{
  "message": "Withdrawal successful",
  "balance": 1500
}
```
- Validation Error (400):
```json
{
  "error": "Insufficient balance"
}
```

#### 3. Transfer Money
**Endpoint**: `POST /api/accounts/:id/transfer`

**Request**:
```json
{
  "to_account_id": 2,
  "amount": 300
}
```

**Response**:
- Success (200):
```json
{
  "message": "Transfer successful",
  "from_balance": 1200,
  "to_balance": 1500
}
```
- Validation Error (400):
```json
{
  "error": "Insufficient balance in source account"
}
```

#### 4. CRUD Operations for Accounts
**Endpoints**:
- **Create Account**: `POST /api/accounts`
    **Request**:
    ```json
    {
      "name": 2,
      "balance": 300
    }
    ```
    **Response**:
    - Success (200):
    ```json
    {
      "id": 1,
      "name": "Cosme Fulanito",
      "balance": 300
    }
    ```
- **Read Account**: `GET /api/accounts/:id`
    **Response**:
    - Success (200):
    ```json
    {
      "id": 1,
      "name": "Cosme Fulanito",
      "balance": 1500
    }
    ```
    - Not Found (404):
    ```json
    {
      "error": "Account not found"
    }
    ```
- **Update Account**: `PUT /api/accounts/:id`
    **Request**:
    ```json
    {
      "name": "Cosme Nomas"
    }
    ```
    **Response**:
    - Success (200):
    ```json
    {
      "id": 1,
      "name": "Cosme Nomas",
      "balance": 300
    }
    ```
- **Delete Account**: `DELETE /api/accounts/:id`
    **Response**:
    - Success (200):
    ```json
    {
      "message": "Account successfully deleted"
    }
    ```

### Validations
- Amount must be greater than 0 for deposits and withdrawals.
- Ensure sufficient balance for withdrawals and transfers.
- Validate account existence.

### Authorization
- Include a simple basic authentication.

## Part 2: User Guide

### Objective
The API facilitates secure banking operations such as deposits, withdrawals, and transfers between accounts.

### Endpoints Guide
- **POST /api/accounts/:id/deposit**: Deposit funds to an account.
- **POST /api/accounts/:id/withdraw**: Withdraw funds from an account.
- **POST /api/accounts/:id/transfer**: Transfer funds between accounts.
- **CRUD Endpoints**:
  - **POST /api/accounts**: Create a new account.
  - **GET /api/accounts/:id**: Fetch account details.
  - **PUT /api/accounts/:id**: Update account details.
  - **DELETE /api/accounts/:id**: Delete an account.

### Test Cases
- Deposit: Test with valid and invalid amounts.
- Withdraw: Test for balance availability.
- Transfer: Test for account existence and balance sufficiency.
- CRUD Operations: Test creating, reading, updating, and deleting accounts.

## Part 3: Installation

### Prerequisites
- Ruby >= 3.0
- Rails >= 7.0
- MySQL

### Installation Steps
1. Clone the repository:
```bash
git clone <repository-url>
```
2. Install dependencies:
```bash
bundle install
```
3. Set up the database:
```bash
rails db:create db:migrate
```
4. Run the server:
```bash
rails server
```

5. Run rspec tests:
```bash
bundle exec rspec
```

## Part 4: Project Architecture

### Project Structure
```
app/
├── controllers/
│   └── api/
│       ├── accounts_controller.rb
├── models/
│   ├── account.rb
├── services/
|   └── transactions/
│       ├── deposit_service.rb
│       ├── withdraw_service.rb
│       ├── transfer_service.rb
│   └── accounts/
│       ├── create_service.rb
│       ├── find_service.rb
│       ├── update_service.rb
│       └── delete_service.rb
├── serializers/
│   └── account_serializer.rb
```

### Architecture Explanation
- **Hexagonal Architecture**: Core business logic resides in the `services/` directory to separate concerns and facilitate testing.
- **Controllers**: Handle HTTP requests and responses.
- **Models**: Represent the database structure and validations.
- **Serializers**: Format the output for API responses.

### API Flow Diagram
```
Client → Controller → Service → Model → Database
                 ↘ Serializer ↗
```
