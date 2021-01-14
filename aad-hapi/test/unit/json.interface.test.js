if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''
  require('dotenv').config({path: '../.env'});
}
const path_file = '../../lib/data/development_data.json';
// const Interface = require('../../lib/handlers/json_handler');
const {Client} = require('../../lib/handlers/%s_client'.replace('%s', process.env.LB_BACKEND));

const Wrapper = require('../../lib/models/wrapper');
const Messages = require('../../lib/models/messages');

describe('JSON Client', () => {
  // const data = Client.open();
  const client = new Client({path: path_file});
  //const test_data = JSON.parse(JSON.stringify(require(path_file)));
  const ndate = new Date();
  //const item = Wrapper.wrapper();
  /*
  const hh = {
              response: (json_obj) => {
                                       return {data: json_obj, code: (num) => {return {msg: "ok"};}}
                                      }
             };
  */
  /*
  test('JSON Client ', () => {
    console.log(client);

  });
  */
  test('JSON Client connect ', () => {
    expect(client.connect()).toEqual({isValid: true});
  });

  test('JSON happy client insert', () => {
    // happy insert
    client.connect();
    const item = Wrapper.wrapper();

    item.pk = 'aaa';
    item.sk = 'bbb';
    item.data = 'ccc';
    item.form = {name:"ddd",color:"eee"}
    const expected = Wrapper.wrapper();
    expected.pk = 'aaa';
    expected.sk = 'bbb';
    expected.data = 'ccc';
    expected.form = {name:"ddd",color:"eee"}
    expect(client.insert(item))
      .toEqual({"isValid": true, "result": expect.any(Object)});
    client.end();
  });

  test('JSON client duplicate insert', () => {
    let item= {pk: 'aaa',
                sk: 'bbb',
                data: 'ccc'};

    expect(() => {
      client.connect();
      client.insert(item, test_data);
    }).toThrow();
  });

  test('JSON update', () => {
    // update existing
    // ignore Missing
    // add form new attributes
    client.connect();
    let ins_item = Wrapper.wrapper();
    ins_item.pk = 'bbb';
    ins_item.sk = 'bbb';
    ins_item.data = 'bbb';
    ins_item.form = {name:"ddi",color:"eei",height:12};
    ins_item.updated = ndate.toISOString();
    let upd_item = Wrapper.wrapper();
    upd_item.pk = 'bbb';
    upd_item.sk = 'bbb';
    upd_item.data = 'bbb';
    upd_item.form = {name:"ddu",color:"eeu",height:13};
    upd_item.updated = ndate.toISOString();

    let expected = {
              isValid:true,
              result: {pk:"bbb",
                          sk:"bbb",
                          data:"bbb",
                          form:{name:"ddu",color:"eeu",height:13},
                          uuid:"",
                          active:true,
                          created:expect.any(String),
                          updated:expect.any(String)
                      }
            };
    // insert a record
    client.insert(ins_item);
    // change the values
    expect(client.update(upd_item)).toEqual(expected);

  });
  /*
  test('JSON delete', () => {
    //let results = Messages.results();
    let ins_item = Wrapper.wrapper();

    ins_item.pk = 'ccc';
    ins_item.sk = 'ccc';
    ins_item.data = 'ccc';
    ins_item.form = {name:"ddd",color:"eee"};

    //console.log('inserted', Client.insert(ins_item, test_data));
    Client.insert(ins_item, test_data);

    let del_item= {pk: 'ccc',
                sk: 'ccc',
                data: 'ccc'};
    //console.log('deleted',Client.delete(del_item, test_data));
    expect(Client.delete(del_item, test_data)).toEqual({isValid: true, result: expect.any(Object)});
  });


  test('JSON show', () => {
    console.log(JSON.stringify(test_data));
  });
*/
});
