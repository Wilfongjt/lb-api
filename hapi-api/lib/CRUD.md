

# User
* The guest user can initiate a new user
* An authenticated user can change the chelate's form
* Api maintains the chelate's fields
* Chelate "pk", "sk", "data", and "created" are immutable
* Chelate "form" and "updated" values are mutable
* Update field is NOT included on the initial insert
* Update field is set to update's date-time when form is changed  

------------------------------------------------------------
## Insert new user
------------------------------------------------------------
Given:
* An empty table: ```{}```
* A user-form: ```{username:"A@a.com",password:"a1A!aaaa"}```
* User-stamp: ```"USER"```
* Alias-stamp: ```"ALIAS"```

Insert a user
* Create a user-form
* Chelate the user-form
* Insert the user-chelate
* Create an alias-form
* Chelate the alias-form
* Insert the alias-chelate

------------------------------------------------------------
STEP 1: Create a user-form
* User-form
```
{username:"A@a.com", password:"a1A!aaaa"}
```

STEP 2: Chelate the user-form
* User-chelate
```
{
    pk:"a1b2c3e4",
    sk:"USER",
    data:"USER",
    created:"2021-01-18T19:46:58.122Z",
    form:{username:"A@a.com", password:"a1A!aaaa"}
}
```

STEP 3: Insert user-chelate
* Inserted user-chelate
```
{
    {
      pk:"a1b2c3e4", sk:"USER", data:"USER",created:"2021-01-18T19:46:58.122Z",
      form:{username:"A@a.com", password:"a1A!aaaa"}
    }
}
```

STEP 4: Create the alias-form
* Generate a GUID: "a1b2c3e4"
* Generate a time-stamp: "2021-01-18T19:46:58.122Z"
* The alias-form is
```
{
    pk:"a1b2c3e4",
    sk:"USER"
}
```

STEP 5: Chelate the alias-form
* Alias-chelate
```
{
    pk:"A@a.com", sk:"ALIAS", data:"USER", created:"2021-01-18T19:46:58.122Z",
    form:{pk:"a1b2c3e4", sk:"USER"}
}
```

STEP 6: Insert the alias-chelate
* Inserted alias-chelate  
```
{
    {
      pk:"a1b2c3e4", sk:"USER", data:"USER",created:"2021-01-18T19:46:58.122Z",
      form:{username:"A@a.com", password:"a1A!aaaa"}
    },
    {
      pk:"A@a.com", sk:"USER", data:"ALIAS", created:"2021-01-18T19:46:58.122Z",
      form:{pk:"a1b2c3e4", sk:"USER"}
    }
}
```
------------------------------------------------------------
## SignIn
------------------------------------------------------------
Given:
  Table:

STEP 1: Create signin-form
STEP 2: Chelate the signin-form
STEP 3: Signin with signin-chelate
STEP 4: Insert the signin-chelate
STEP 2: Find alias-chelate
STEP 2:

STEP 3: Get user-chelate
STEP 4: Authenticate

------------------------------------------------------------
## Update User Password
------------------------------------------------------------
Given:
  Table:
  User-chelate:

* The table is
```
  {
    {
      pk:"a1b2c3e4", sk:"USER", data:"USER",created:"2021-01-18T19:46:58.122Z",
      form:{username:"A@a.com", password:"a1A!aaaa"}
    },
    {
      pk:"A@a.com", sk:"USER", data:"ALIAS", created:"2021-01-18T19:46:58.122Z",
      form:{pk:"a1b2c3e4", sk:"USER"}
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
