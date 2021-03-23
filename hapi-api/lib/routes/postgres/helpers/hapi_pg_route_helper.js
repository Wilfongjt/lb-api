import { Pool, Client } from 'pg';
// Strategy: put pool in server.js
export class HapiPgRouteHelper {
  constructor () {
  }
  route_post() {
    return {
      method: 'POST',
      path: '/pg',
      handler: async function (request, h) {
        let result = {status:"200", msg:"OK"};
        return result;
      }
    };
  }
  route_get() {
      return {
          method: 'GET',
          path: '/pg',
          handler: async function (request, h) {
            let result = {status:"200", msg:"OK"};
            return result;
            /*
            let select_criteria; /// pk sk, sk tk, xk yk
            let selection = {};
            let token = '';
            let client;
            try {
              //client = await pools.pool.connect();
              client = awwait request.pg.connect();
              token = request.headers.authorization.replace('Bearer ','');
              select_criteria = request.headers.payload;
              result = await client.query(select_criteria);
            } catch (e) {
              console.log('pg plugin e', e);
              status = '500';
              error= 'Unknown Issue';
            } finally {
              client.release();
              return result;
            }
            */
          }
      };
  }
  route_put() {
    return {
      method: 'PUT',
      path: '/pg',
      handler: async function (request, h) {
        let result = {status:"200", msg:"OK"};
        return result;
      }
    };
    }
  route_delete() {
    return {
      method: 'DELETE',
      path: '/pg',
      handler: async function (request, h) {
        let result = {status:"200", msg:"OK"};
        return result;
      }
    };
  }
  getRoutes() {
    return [this.route_post(),this.route_get(), this.route_put(), this.route_delete()];
  }

};
