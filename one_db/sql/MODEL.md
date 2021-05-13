# Model

## User   
| name | pk | sk | tk | form | active | changed | updated | owner |
| ---- | -- | -- | -- | ---- | ------ | ------- | ------- | ----- |
| User | username#\<email> | const#USER | guid#\<guid> | username, password, displayname | \<boolean> | \<timestamp> | \<timestamp> | guid#\<guid> |

* Hash password
* Stop password from leaving server/data store
* Restrict create to guest,
* Restrict read to owner and admin
* Restrict update to owner
* Restrict delete to owner
* Allow owner to read only one User
* Allow admin to read many Users
