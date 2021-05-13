import json
import subprocess
expect_version = 'Python 3.6.2'
x = subprocess.run(["python", "--version"])


#python --version
class Stack (list):
    #def __init__(self):
    #    self.items = []

    def isEmpty(self):
        return self.items == []

    def push(self, item):
        self.append(item)

    #def pop(self):
    #    return self.pop()

    def peek(self):
        return self[len(self.items) - 1]

    def size(self):
        return len(self)
    def toString(self):
        return ', '.join(self)
i = 0
key=''
#claims = ["'app.postgres_jwt_claims'"]
#['200', '403', '403']
# 'guest-api_guest-current_settings(\'app.settings.jwt_secret\')'
# 'existing@user.com-api_user-current_settings(\'app.settings.jwt_secret\')'
users  = ["guest","existing@user.com","", "bad-value"]
 #        ['200', '403', '403', '403']

scope  = ["api_guest","api_user", "", "bad-scope"]
 #        ['200', '403', '403','403']

#secret = ["current_settings('app.settings.jwt_secret')", "\'\'", "'bad-secret'"]
 #        ['200', '403', '403','403']

tmpl = 'sign((current_setting({})::JSONB || ''{"user":"{}", "scope":"{}"}''::JSONB)::JSON, current_setting(''{}''))::TEXT'

#for c in claims:
goods = [
    'guest, api_guest, current_settings(\'app.settings.jwt_secret\')',
    'existing@user.com, api_user, ']

stack_ = Stack()

for u in users:
    #push
    stack_.push(u)
    for sc in scope:
        #push
        stack_.push(sc)
        j = '\'{}\''.format(json.dumps({'user': u, 'scope': sc}))
        "current_settings('app.settings.jwt_secret')"
        tmpl = f'sign(current_setting(\'app.postgres_jwt_claims\')::JSONB || {j}::JSONB, current_settings(\'app.settings.jwt_secret\')::TEXT)'
        i += 1
        print('tmpl: ', tmpl)
        '''
        for s in secret:
            # push
            stack_.push(s)
            #tmpl = f'sign((current_setting({c})::JSONB || \{"user":{u}, "scope":{sc}\}::JSONB)::JSON, current_setting({s}))::TEXT'
            j = '\'{}\''.format(json.dumps({'user': u, 'scope': sc}))
            tmpl = f'sign(current_setting(\'app.postgres_jwt_claims\')::JSONB || {j}::JSONB, {s}::TEXT)'
            print('tmpl: ', tmpl)
            print('key: ', stack_.toString())

            i+=1
            key = ''
            # pop
            stack_.pop()
        '''
        # pop
        stack_.pop()
    # pop
    stack_.pop()

print('test count ', i)
