

# Process


### Function: Changed_Key
* Description: determines if one of the keys has been changed 
1. [Updates are done on primary key]
1. [Assume changed When chelate is missing pk and sk]
1. [Detect change by comparing Chelate.Key.Value to Chelate.form keys and values]
1. [Form to Key Transform is {name:A} to {k:name#A}]
1. 	[Key to Form Tranform is {k:name#A to name:A}]
1. [usernname:a@b.com ---> usernname#a@b.com]
1. [Return Boolean] 

### Function: Chelate
* Description: Build a Chelate given a list of expected keys and a form
1. [Handle Simple Value]
1. [Handle Constant ... passthrough]
1. [Handle GUID...passthrough]
1. [Handle Wildcard...generate guid]
1. [Return {pk,sk,tk,form:{key1:value, key2:value2,...}}] 

* [Fail NULL when expected_keys or form is NULL]
 * [Fail NULL When expected key is not found in form]
 * [Fail NULL When expected key object is {}]
### Function: event_logger
### Function: event_logger_validate
### Function: Validate Token given token and expected scope
1. [False when token or scope is NULL]
1. [Remove Bearer prefix on token]
1. [False when scope isnt verified]
1. [Scope may contain more than one comma delemeted role]
1. [Set user in session]
1. [Set scope in session]
1. [Set user key in session]
1. [Return Boolean] 

### Function: Validate Chelate given Chelate and Expected Value
1. [False when Chelate or Expected is NULL]
1. [Check for existance of pk,sk,tk,form,owner,active,created, and updated]
1. [Exit with NULL when evaluation does not match expected]
1. [Return chelate when evaluation matches expected] 

### Function: Validate Credentials given Credentials like {username,password}
1. [Exit NULL when credentials are NULL]
1. [Exit NULL when username or password is missing]
1. [Return Credentials on success] 

### Function: Validate Criteria given Criteria like {sk}, {pk,sk}, {sk,tk}, or {xk,yk}
1. [Exit False when criteria is NULL]
1. [Exit False when sk is missing]
1. [Exit False when missing pk and tk]
1. [Return Boolean] 

### Function: Validate Form given required_form_keys and form
1. [NULL when required_form_keys is NULL]
1. [Exit NULL when form is NULL]
1. [Exit NULL when form is missing]
1. [Return form] 

### Function: Validate Token
* Description: Validate Token given token and expected scope
1. [False when token or scope is NULL]
1. [Ensure token payload has user and scope claims]
1. [Set user in session]
1. [Set scope in session]
1. [Set user key in session]
1. [Set role to token scope]
1. [False when scope isnt verified]
1. [Return token claims] 

### Function: Delete by Primary Criteria {pk,sk}
* Description: Delete User by primary key {pk,sk}
1. [Delete where pk and sk]
1. [Remove password from results when found]
1. [Return {status,msg,criteria,deletion}] 

* [Fail 400 when a criteria parameter is NULL]
 * [Fail 400 when criteria is missing pk or sk]
 * [Fail 404 when primary key is not found]
 * [Fail 404 when item is not owned by current]
### Function: Insert Chelate like {pk,sk,tk,form}, {pk,sk,form}, {sk,tk,form}, or {sk,form}
1. [Validate Chelate]
1. [Add owner to chelate]
1. [figure out who the owner is]
1. [Insert requires an owner key value]
1. [Insert Unique Chelate]
1. [Handle chelate with pk, sk and tk]
1. [Handle chelate with pk and sk]
1. [Handle chelate with sk and tk]
1. [Handle chelate with sk]
1. [Return {status,msg,insertion}] 

* [Fail 400 when a parameter is NULL]
 * [Fail 400 when chelate is missig a form]
 * [Fail 400 when chelate is missing a proper set of keys (pk,sk,tk),(pk,sk),(sk,tk), or (sk)]
 * [Fail 409 when duplicate]
### Function: Query by Criteria like {pk,sk},{sk,tk}, or {xk,yk}
* Description: General search
1. [Validate parameters (criteria)]
1. [Note sk, tk, yk key may contain wildcards *]
1. [Remove password when found]
1. [Query where criteria is {pk, sk:*}]
1. [Query where criteria is {pk, sk}]
1. [Query where criteria is {sk, tk:*}]
1. [Query where criteria is {sk, tk}]
1. [Query where criteria is {xk,yk:*}]
1. [Query where criteria is {xk, yk}]
1. [Return {status,msg,selection}] 

* [Fail 400 when a parameter is NULL]
 * [Fail 400 when the Search Pattern is missing expected Keys]
 * [Fail 404 when query results are empty]
### Function: Update with Chelate like {pk,sk,form}
* Description: General update
1. [Validate Parameter (chelate)]
1. [Delete old chelate and insert new when keys change]
1. [Get existing chelate from table when key change detected]
1. [Patch tk from old chelate when key change detected]
1. [Build replacement chelate when key change detected]
1. [Drop existing chelate when key change detected]
1. [Insert new chelate when key change detected]
1. [Update the Chelate's Form when keys are not changed]
1. [Remove password before return]
1. [Return {status,msg,updation}] 

* [Fail 400 when a parameter is NULL]
 * [Fail 400 when pk, sk or form are missing ]
 * [Fail 404 when chelate is not found in table]
 * [Fail 404 when given chelate is not found]
### Function: Signin given token and credentials
* Description: Get a user token given the users credentials
1. [Validate Token]
1. [Switch Role]
1. [Validate Credentials]
1. [Verify User Credentials]
1. [Generate user token]
1. [Return {status,msg,token}] 

* [Fail 403 when token is invalid]
 * [Fail 400 when credentials are NULL or missing]
 * [Fail 404 when User Credentials are not found]
### Function: Signup given guest_token TEXT, form JSON
* Description: Add a new user
1. [Switch to Role]
1. [Validate Token]
1. [Verify token has expected scope]
1. [Validate Form with user's credentials]
1. [Validate Requred form fields]
1. [Hash password when found]
1. [Overide the token's default role]
1. [Assemble Data]
1. [Stash guid for insert]
1. [Execute insert]
1. [Return {status,msg,insertion}] 

* [Fail 403 When token is invalid]
 * [Fail 401 when unexpected scope is detected]
 * [Fail 400 when form is NULL]
 * [Fail 400 when form is missing requrired field]
### Function: User POST
* Description: Store the original values of a user chelate
* Parameters: token TEXT,form JSON
1. [pk is <text-value> or guid#<value>
1. [Switch to api_guest Role]
1. [Validate token parameter]
1. [Verify token has expected scope]
1. [Validate form parameter] 
1. [Validate Requred form fields]
1. [Assemble Data]
1. [Hash password when found]
1. [Chelate Data]
1. [Stash guid for insert]
1. [Insert user Chelate]
1. [Return {status,msg,insertion}] 

* [Fail 403 When token is invalid]
 * [Fail 401 when unexpected scope is detected]
 * [Fail 400 when form is NULL]
 * [Fail 400 when form is missing requrired field]
### Function: User GET
* Description: Find the values of a user chelate
* Parameters: token TEXT,criteria JSON,options JSON
1. [Switch to api_guest Role]
1. [Validate token parameter]
1. [Verify token has expected scope]
1. [Assemble user specific data]
1. [Primary query {pk,sk}]
1. [Primary query {pk,sk:*}]
1. [Secondary query {sk,tk}]
1. [Secondary query {sk,tk:*}]
1. [Teriary query {tk,sk} aka {xk, yk}]
1. [Teriary query {tk} aka {xk}]
1. [Quaternary query {sk,pk} akd {yk,zk}
1. [Quaternary query {yk}
1. [Primary query {pk,sk}]
1. [Primary query {pk,sk:*}]
1. [Secondary query {sk,tk}]
1. [Secondary query {sk,tk:*}]
1. [Teriary query {tk,sk} aka {xk, yk}]
1. [Teriary query {tk} aka {xk}]
1. [Quaternary query {sk,pk} akd {yk,zk}
1. [Quaternary query {yk}
1. [API GET user Function]
1. [Return {status,msg,insertion}] 

* [Fail 403 When token is invalid]
 * [Fail 401 when unexpected scope is detected]
### Function: User DELETE
* Description: Remove a user from the table
* Parameters: token TEXT,pk TEXT
1. [Delete by primary key]
1. [pk is <text-value> or guid#<value>
1. [Switch to api_guest Role]
1. [Validate token parameter]
1. [Verify token has expected scope]
1. [Validate pk parameter]
1. [Assemble user specific data]
1. [Assume <key> is valid when # is found ... at worst, delete will end with a 404]
1. [Delete by pk:<key>#<value> and sk:const#USER when undefined prefix]                
1. [Wrap pk as primary key when # is not found in pk]
1. [Delete by pk:username#<value> and sk:const#USER when <key># is not present]
1. [API DELETE user Function]
1. [Return {status,msg,insertion}] 

* [Fail 403 When token is invalid]
 * [Fail 401 when unexpected scope is detected]
 * [Fail 400 when pk is NULL]
### Function: User PUT
* Description: Change the values of a user chelate
* Parameters: token TEXT,pk TEXT,form JSON
1. [Update by primary key]
1. [pk is <text-value> or guid#<value>
1. [Switch to api_guest Role]
1. [Validate token parameter]
1. [Verify token has expected scope]
1. [Validate pk parameter]
1. [Validate form parameter] 
1. [Validate Requred form fields]
1. [No required PUT form fields ]
1. [Validate optional form fields]
1. [No optional PUT form fields]
1. [Hash password when found]
1. [Assemble user specific data]
1. [Assume <key> is valid when # is found ... at worst, delete will end with a 404]
1. [Delete by pk:<key>#<value> and sk:const#USER when undefined prefix]      
1. [Wrap pk as primary key when # is not found in pk]
1. [Delete by pk:username#<value> and sk:const#USER when <key># is not present]
1. [API PUT user Function]
1. [Return {status,msg,insertion}] 

* [Fail 403 When token is invalid]
 * [Fail 401 when unexpected scope is detected]
 * [Fail 400 when pk is NULL]
 * [Fail 400 when form is NULL]
