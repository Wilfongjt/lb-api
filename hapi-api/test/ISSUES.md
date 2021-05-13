
# Issues
### { statusCode: 403, error: 'Forbidden', message: 'Insufficient scope' }

* JOI threw this error
* Token Issue
  - Change the scope in the JWT token

###  {statusCode: 401, error: 'Unauthorized',message: 'Invalid credentials', attributes: { error: 'Invalid credentials' }}
* JOI threw this error
* Token Issue
  - user tokens require user, key , and scope values


### {statusCode: 400, error: 'Bad Request', message: 'Invalid request query input'}

  * Joi threw this error
  * one of the parameters is not configured properly in JOI

### { msg: 'Not Found', status: '404' }
* a parameter value was not found in search
