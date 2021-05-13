# Chelate
The chelate is a data wrapper.  The word chelate is derived from the greek word for claw.
* Chelate is  {"pk":"","sk":"","tk":"","form":{},"active":"","created":"","updated":"","owner":""}
* pk is an immutable key
* sk is an immutable key
* tk is an immutable key
* form is data in JSON format
* active is mark
* created is an immutable date and time stamp
* updated is the last date and time the form or active fields were changed
* owner is the person who added the chelate

# Expect
* The backend will generate GUID for missing pk value
* The backend will generate GUID for missing tk value
* sk is required
* form is required

# API Front End Responsibilities

* handle API authentication
* collect user data (CRUD)
* collect application data (CRUD)
* validate data
* create a chelate, wrap data with keys (pk, sk, and tk, form)
* route new chelate to server via POST
* route updated chelate to server via PUT
* route selected chelate to server via GET
* route deleted chelate to server via DELETE

# Back End Responsibilities
* validate required fields (keys and form)
* generate missing pk or tk GUID on insert
* prevent duplicate pk and sk chelates
* prevent duplicate sk and tk chelates
* timestamp inserted chelate
* timestamp updated chelate
* set chelate.active = true
* provide function to query a chelate
* provide function to insert a chelate
* provide function to update a chelate
* provide function to delete a chelate
* provide function to signup a user
* provide function to signin a user


# User
* User extends Chelate
* form is {username:"\<string>", password: "\<string>", displayname: "\<string>"}
* pk is "username#\<username>"
* sk is "const#USER"
* tk is "guid#\<generated || provided>"


# New User
* The guest token required to create a User
# Update User
* Only the owner can change the user record
* A personal user token required to update user



------------------------------------------------------------
## Insert new user (Manual)
------------------------------------------------------------
Given:
* An empty table: ```{}```
* A user-form: ```{username:"A@a.com",password:"a1A!aaaa"}```
* User-stamp: ```"USER"```


Insert a user
* STEP 1: Collect user data in the application
* STEP 2: Chelate user's data
* STEP 3: Route Chelate to /user
* STEP 4: Verify Guest Token
* STEP 5: Insert the chelate into table or throw Error


------------------------------------------------------------
STEP 1: Collect user data in the application
* User-form
```
{username:"A@a.com", password:"a1A!aaaa", displayname:"A"}
```

STEP 2: Chelate user's data
*
```
{
    pk:"username:a@a.com",
    sk:"const#USER",
    form:{username:"A@a.com", password:"a1A!aaaa", displayname: "A"}
}
```

STEP 3: Verify Guest Token
* Verify that Guest token is valid

STEP 4: Insert the chelate into table
*
```
{
    {
      pk:"username:a@a.com,
      sk:"const#USER",
      tk:"guid#920a5bd9-e669-41d4-b917-81212bc184a3",
      form:{username:"A@a.com", password:"a1A!aaaa", displayname: "A"},
      active: true,
      created: "2021-01-18T19:46:58.122Z",
      updated: "2021-01-18T19:46:58.122Z"
    }
}
```

------------------------------------------------------------
## SignIn
------------------------------------------------------------
Given:
  Table:

* STEP 1: Collect the credentials
* STEP 2: Chelate the credentials
* STEP 3: Route Chelate to /signin
* STEP 4: Verify Guest Token
* STEP 5: Authenticate with credentials
* STEP 6: Return User specific token or Error

------------------------------------------------------------
## Update User Password
------------------------------------------------------------
STEP

Given:
  Table:
  User-chelate:
* STEP 1: Collect the data
* STEP 2: Chelate the Data
* STEP 3: Route Chelate to /user
* STEP 4: Verify Guest Token
* STEP 5: Delete the existing Chelate
* STEP 6: Insert the chelate into table or throw Error
* STEP 7: Return User Chelate

* The table is
```
{
    {
      pk:"username:a@a.com,
      sk:"const#USER",
      tk:"guid#920a5bd9-e669-41d4-b917-81212bc184a3",
      form:{username:"A@a.com", password:"a1A!aaaa", displayname: "A"},
      active: true,
      created: "2021-01-18T19:46:58.122Z",
      updated: "2021-01-18T19:46:58.122Z"
    }
}
```

* User-form is
```
  {username:"A@a.com", password:"b1B!bbbb"}
```
------------------------------------------------------------

STEP 1: Get an user-chelate
* User-chelate is
```
{
  pk:"a1b2c3e4", sk:"USER", data:"USER",created:"2021-01-18T19:46:58.122Z",
  form:{username:"A@a.com", password:"a1A!aaaa"}
}
```
STEP 2: Copy the alias-chelate's form
* Convert
```
{pk:"a1b2c3e4", sk:"USER"}
```
STEP 2: Get the user-chelate with the alias-chelate
```

```
STEP 3:
```
```
STEP 4:
```
```
STEP 5:
```
```
