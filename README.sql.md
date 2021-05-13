

# Changes


| file | type | detail |
| ---- | ------- | ------ |
| 00.db.sql | DONE 0.0.0 | Setup environment variables |
| 00.db.sql | DONE 0.0.0 | Create Database |
| 00.db.sql | DONE 0.0.0 | Create Extensions |
| 00.db.sql | DONE 0.0.0 | Create Roles |
| 10.base.0.0.1.sql | TODO 1.4.2 | All adoptees are showing up with red symbol. red is for currently logged in user |
| 10.base.0.0.1.sql | Done 1.4.1 | adoptees empty query should return [] rather than raise exception |
| 10.base.0.0.1.sql | DONE 1.4.0 | adoptees Should return a json array |
| 10.base.0.0.1.sql | DONE 1.4.0 | Add boundary search to adoptee |
| 10.base.0.0.1.sql | DONE 1.4.0 | change 1.3.0 to 1.4.0 |
| 10.base.0.0.1.sql | DONE 1.4.0 | remove commented code |
| 10.base.0.0.1.sql | DONE 1.2.1 | Change "process" type to "event" type |
| 10.base.0.0.1.sql | DONE 1.2.1 | Change Process_logger to event_logger |
| 10.base.0.0.1.sql | DONE 1.2.1 | Change 1_2_1 to 1_3_0 |
| 10.base.0.0.1.sql | DONE 1.2.1 | Create add_base schema |
| 10.base.0.0.1.sql | DONE 1.2.1 | Move adopt_a_drain table to base_0_0_1 schema |
| 10.base.0.0.1.sql | DONE 1.2.1 | stop insert of duplicate adoptee |
| 10.base.0.0.1.sql | DONE 1.2.1 | add tk to adopter insert |
| 10.base.0.0.1.sql | DONE 1.2.1 | add tk to adoptee insert |
| 10.base.0.0.1.sql | DONE 1.2.1 | add tk to signin |


# Order of Creation


| file | type | detail |
| ---- | ------- | ------ |
| 00.db.sql | ISSUES | Common Issues and Solutions |
| 00.db.sql | Environment | Read environment variables |
| 00.db.sql | DATABASE | Drop Database |
| 00.db.sql | DATABASE | Create Database |
| 00.db.sql | EXTENSION | pgcrypto |
| 00.db.sql | EXTENSION | pgtap |
| 00.db.sql | EXTENSION | pgjwt |
| 00.db.sql | EXTENSION | uuid-ossp |
| 00.db.sql | ROLE | process_logger_role |
| 00.db.sql | ROLE | api_guest |
| 00.db.sql | ROLE | api_user |
| 00.db.sql | ROLE | guest_authenticator |
| 00.db.sql | GRANT | api_guest to guest_authenticator |
| 10.base.0.0.1.sql | SCHEMA | Create Schema |
| 10.base.0.0.1.sql | DATABASE | Alter app.settings |
| 10.base.0.0.1.sql | SET | "app.lb _env" To :lb _env; |
| 10.base.0.0.1.sql | SET | "app.postgres_jwt_claims" To :postgres_jwt_claims |
| 10.base.0.0.1.sql | GRANT | Grant Schema Permissions |
| 10.base.0.0.1.sql | SCHEMA | Set Schema Path |
| 10.base.0.0.1.sql | TYPE | Create Types |
| 10.base.0.0.1.sql | TABLE | Create Table |
| 10.base.0.0.1.sql | INDEX | Create Indices |
| 10.base.0.0.1.sql | GRANT | Permissions |
| 12.base.0.0.1.event_logger.sql | FUNCTION | Create event_logger(_form JSONB) |
| 12.base.0.0.1.event_logger_validate.sql | GRANT | Grant Execute |
| 12.base.0.0.1.event_logger_validate.sql | FUNCTION | Create event_logger_validate(form JSONB) |
| 12.base.0.0.1.event_logger_validate.sql | GRANT | Grant Execute |
| 14.base.0.0.1.delete.sql | ToDo | limit delete to users personal records. |
| 14.base.0.0.1.delete.sql | GRANT | Grant Execute |
| 14.base.0.0.1.insert.sql | todo | add user id to inserted record ... :"" |
| 20.api.0.0.1.sql | GRANT | Grant Schema Permissions |
| 24.api.0.0.1.signin.query.sql | SCHEMA | Create Schema |
| 24.api.0.0.1.signin.query.sql | DATABASE | Alter app.settings |
| 24.api.0.0.1.signin.query.sql | GRANT | Grant Schema Permissions |
| 24.api.0.0.1.signin.query.sql | SCHEMA | Set Schema Path |
| 24.api.0.0.1.signin.query.sql | FUNCTION | Create api_0_0_1.signin(token, form JSON) |
| 24.api.0.0.1.signin.query.sql | GRANT | Grant Execute |
| 24.api.0.0.1.user.sql | SCHEMA | Create Schema |
| 24.api.0.0.1.user.sql | DATABASE | Alter app.settings |
| 24.api.0.0.1.user.sql | GRANT | Grant Schema Permissions |
| 24.api.0.0.1.user.sql | SCHEMA | Set Schema Path |
| 90.test.0.0.1.sql | TEST | Test(a) adopter Insert |
| 90.test.0.0.1.sql | TEST | Test(b) signin Insert |
| 90.test.0.0.1.sql | TEST | Test(a) adopter Insert |
| 90.test.api.0.0.1.time.sql | TEST | Test event_logger Insert |
| 90.test.base.0.0.1.event_logger.sql | TEST | Test event_logger Insert |
| 90.test.base.0.0.1.validate_credentials.sql | TEST | Test event_logger Insert |
| 90.test.base.0.0.1.validate_form.sql | TEST | Test event_logger Insert |
| 92.test.base.0.0.1.table.sql | TEST | Test event_logger Insert |
| 94.test.api.0.0.1.signin.query.sql | TEST | Test event_logger Insert |


# Database


| file | Database | role
| ---- | ------- | --------- |
| 00.db.sql |  one_db  |


# EXTENSION


| file | EXTENSION |
| ---- | ------- |
| 00.db.sql |  pgcrypto  |
| 00.db.sql |  pgtap  |
| 00.db.sql |  pgjwt  |
| 00.db.sql |  "uuid-ossp"  |
# Roles


| file | Role |
| ---- | ------- |
| 00.db.sql |  process_logger_role nologin   |
| 00.db.sql |  event_logger_role nologin   |
| 00.db.sql |  api_guest  |
| 00.db.sql |  api_user  |
| 00.db.sql |  api_admin  |
| 00.db.sql |  guest_authenticator noinherit login password :api_password  |
# Schema


| file | Schema |
| ---- | ------- |
| 10.base.0.0.1.sql |  base_0_0_1  |
| 20.api.0.0.1.sql |  api_0_0_1  |
# Type


| file | Schema | Name
| ---- | ------- | --------- |
| 10.base.0.0.1.sql |  base_0_0_1 | jwt_token AS ( |
# Table


| file | Schema | Table
| ---- | ------- | --------- |
| 10.base.0.0.1.sql |  base_0_0_1 | one  ( |
# Unique Index


| file | Name | Schema | Table and Indices |
| ---- | ------- | ------ | ------------- |
| 10.base.0.0.1.sql |  one_first_idx  |  base_0_0_1 | one(pk,sk)  |
| 10.base.0.0.1.sql |  one_second_idx  |  base_0_0_1 | one(sk,tk)  |
| 10.base.0.0.1.sql |  one_second_flip_idx  |  base_0_0_1 | one(tk, sk)  |
# Functions


| file | Schema | FUNCTION | Returns |
| ---- | ------- | --------- | ------- |
| 12.base.0.0.1.changed_key.sql |  base_0_0_1 | changed_key(chelate JSONB)  |  BOOLEAN |
| 12.base.0.0.1.chelate.sql |  base_0_0_1 | chelate(keys JSONB, form JSONB)  |  JSONB |
| 12.base.0.0.1.chelate.sql |  base_0_0_1 | chelate(chelate JSONB)  |  JSONB |
| 12.base.0.0.1.event_logger.sql |  base_0_0_1 | event_logger(form JSONB)  |  JSONB |
| 12.base.0.0.1.event_logger_validate.sql |  base_0_0_1 | event_logger_validate(form JSONB)  |  JSONB |
| 12.base.0.0.1.is_valid_token.sql |  base_0_0_1 | is_valid_token(_token TEXT, expected_role TEXT)  |  BOOLEAN |
| 12.base.0.0.1.validate_chelate.sql |  base_0_0_1 | validate_chelate(chelate JSONB, expected TEXT)  |  JSONB |
| 12.base.0.0.1.validate_credentials.sql |  base_0_0_1 | validate_credentials(credentials JSONB)  |  JSONB |
| 12.base.0.0.1.validate_criteria.sql |  base_0_0_1 | validate_criteria(criteria JSONB)  |  JSONB |
| 12.base.0.0.1.validate_form.sql |  base_0_0_1 | validate_form(required_form_keys TEXT[], form JSONB)  |  JSONB |
| 12.base.0.0.1.validate_token.sql |  base_0_0_1 | validate_token(_token TEXT)  |  JSONB |
| 14.base.0.0.1.delete.sql |  base_0_0_1 | delete(criteria JSONB)  |  JSONB |
| 14.base.0.0.1.insert.sql |  base_0_0_1 | insert(_chelate JSONB)  |  JSONB |
| 14.base.0.0.1.query.sql |  base_0_0_1 | query(criteria JSONB)  |  JSONB |
| 22.api.0.0.1.time.sql |  api_0_0_1 | time()  |  JSONB |
| 24.api.0.0.1.signin.query.sql |  api_0_0_1 | signin(guest_token TEXT,credentials JSON)  |  JSONB |
| 24.api.0.0.1.user.delete.sql |  api_0_0_1 | user(api_token TEXT, pk TEXT, sk TEXT)  |  JSONB |
| 24.api.0.0.1.user.insert.sql |  api_0_0_1 | user(api_token TEXT, form JSON)  |  JSONB |
| 24.api.0.0.1.user.query.sql |  api_0_0_1 | user(user_token TEXT, criteria JSON, options JSON)  |  JSONB |
| 24.api.0.0.1.user.sql |  api_0_0_1 | user(api_token TEXT, atts_required TEXT, form JSON)  |  JSONB |
| 24.api.0.0.1.user.sql |  api_0_0_1 | user(api_token TEXT, primarykey JSON, chelate JSON )  |  JSONB |
| 24.api.0.0.1.user.sql |  api_0_0_1 | user(api_token TEXT, pk TEXT, sk TEXT )  |  JSONB |
| 24.qpi.0.0.1.user.update.sql |  api_0_0_1 | user(api_token TEXT, pk TEXT, sk TEXT, form JSON)  |  JSONB |
