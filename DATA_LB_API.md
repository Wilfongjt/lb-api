Modeling Steps

1. Understand Use Cases
2. Understand Access Patterns
3. Date Modelling
4. REPEAT -> REVIEW -> REPEAT

## Use Cases
### SignUp
1. Sign-up a User, as a guest
5. User is see [User] ()
1. Send welcome email to user upon creating said user, as a guest
1. Limit *access* to User account to account owner
6. User can change their password
2. Password change initiates an email notification to user

### SignIn
2. Sign-in as a User
3. Sign-in is username and password
1. Search by user email as a guest
2. Authenticate with Password
1. Log sign-in attempt, date and time


## Access Patterns
* POST a User
* GET a User by username
* GET all Users
* PUT a User by PK
* DELETE User by PK
*
## Data Modeling

__Guest-Token__
Table: one
  1. *scope*: "api_guest"
  1. *user*: "guest"
  2. *key*: 0

__User-Token__
Table: one
  1. *scope*: "api_user"
  1. *user*: \<User_form_username>
  2. *key*: \<User_tk>

__User__
Table: one

Access Pattern
* POST a User
* GET a User by username
* GET all Users
* PUT a User by PK
* DELETE User by PK

Data Model
  1. *pk*: username#**\<form.username>**
  1. *sk*: "const#USER"
  1. *tk*: guid#\<guid>
  1. *form*: username:, displayname:, password:, scope:
  1. *owner*: \<User_tk>
  1. *created*: \<datetime>
  1. *updated*: \<datetime>
  1. *active*: true

__SignInLog__
Table: one
  1. *pk*: username#<form_username>
  1. *sk*: \<datetime>#\<guid>
  1. *tk*: const#SIGNIN
  1. *form*: username, success:false || true
  1. *owner*: 0 || \<User_tk>
  1. *created*: \<datetime>
  1. *updated*: \<datetime>
  1. *active*: \<datetime>

__Drain__
Datasource: https://api.data.world/v0/sql/citizenlabs/lgrow-storm-drains-current
  1. dr_asset_id
  2. dr_discharge
  3. dr_jurisdiction
  4. dr_lat
  5. dr_long
  6. dr_location
  7. dr_owner
  8. dr_subtype
  9. dr_subwatershed
  10. dr_type
  Note: this datasource is hosted at data.world and is accessed via the dataworld API.


# Data Transform to 2021 from 2020
## User

| Proposed | Current 2020 |
|----|----|
| pk | username#\<email> |
| sk | const#USER |
| tk | guid#\<guid> |
| - | id |
| - | organization  |
| form.username | email |
| - | voice_number  |
| - | sms_number  |
| - | address_1  |
| - | address_2 |
| - | city  |
| - | state  |
| - | zip  |
| form.scope | admin |
| form.password | encrypted_password |
| - | reset_password_token |
| - | reset_password_sent_at |
| - |remember_created_at |
| - | sign_in_count integer |
| - | current_sign_in_at |
| - | last_sign_in_at  |
| - | current_sign_in_ip |
| - | last_sign_in_ip |
| - | first_name  |
| - | last_name  |
| form.displayname | first_name + last_name  |
| active  | true |
| owner | User_tk |
| created | created_at  |
| updated | updated_at  |


## Adoptee

| Proposed | Current 2020 |
|----|----|
|  -  | id |
| pk | asset_id#\<form_asset_id>|
| sk | const#ADOPTEE |
| tk | guid#\<guid> |
| form.asset_id | dr_asset_id |
| form.system_use_code | system_use_code |
| form.name | adopted_name |
| form.jurisdiction | jurisdiction |
| form.discharge | dr_discharge |
| form.name | name |
| form.lat | lat |
| form.long | long |
| owner | guid#\<guid> |
| - | user_id |
| created | created_at |
| updated | updated_at |
| - | deleted_at |
| - | adopted_at |
|   |   |

## Drain
Datasource: data.world

| Proposed | Current 2020 |
|----|----|
| N/A  | N/A |
