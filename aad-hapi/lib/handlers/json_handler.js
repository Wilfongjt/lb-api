const fs = require('fs');
const util = require('util');
const jsonQuery = require('json-query')

const readFile = util.promisify(fs.readFile);
const writeFile = util.promisify(fs.writeFile);

const getJson = async (path_file) => {
  try {
    let storage = await readFile(path_file, 'utf8');
    //console.log(storage);
    return JSON.parse(storage);
  } catch (err) {
    console.log('getJson: ' + err);
    return [{}];
  }
};

const setJson = async (path_file, json_data) => {
  await writeFile(path_file, JSON.stringify(json_data, null, 2), 'utf8');
};


exports.getJson = getJson;
exports.setJson = setJson;
