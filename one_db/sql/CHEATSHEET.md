# Postgres Cheetsheet

## Switching Roles
| from | to |
| ---- | -- |
| api_guest | api_user  |

## Setup Roles
CREATE ROLE api_user;
CREATE ROLE api_guest;
CREATE ROLE guest_authenticator noinherit login password :api_password;
GRANT api_guest to guest_authenticator;

## Switch Role
connect as guest_authenticator
set role api_user

## Limit Query to user's privileges
