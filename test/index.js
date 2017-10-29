'use strict';
const fs = require('fs');
const path = require('path');
const test = require('ava');
const parse = require('../index');
const astResult = require('./result.json');

test('parse', t => {
  const thriftFile = fs.readFileSync(path.resolve(__dirname, './thrift/test.thrift'), 'utf8');
  const ast = parse(thriftFile);
  t.deepEqual(ast, astResult);
});
