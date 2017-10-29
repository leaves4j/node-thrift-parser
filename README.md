node-thrift-parser
---
Parse thrift IDL to an AST

## Installation

```bash
npm install node-thrift-parser -S
```

## Example

```js
const parser = require('node-thrift-parser');
const ast = parser(`
/**
 * test
 */

include 'test.thrift'
namespace * thrift.test

enum Numberz {
  ONE = 1,
  TWO
}

typedef i64 UserId;

struct Bonk {
  1: string message,
  2: i32 type
}

exception Xception {
  1: i32 errorCode,
  2: string message
}

service ThriftTest {
  void testVoid(),
  string testString(1: string thing) throws (1: Xception e),
}
`);

```
 result

```json
{
   "headers": [
      {
         "type": "include",
         "path": "'test.thrift'"
      },
      {
         "type": "namespace",
         "namespaceScope": "*",
         "identifier": "thrift.test"
      }
   ],
   "definitions": [
      {
         "type": "enum",
         "identifier": "Numberz",
         "enumFields": [
            {
               "type": "enumField",
               "identifier": "ONE",
               "value": "1"
            },
            {
               "type": "enumField",
               "identifier": "TWO",
               "value": null
            }
         ]
      },
      {
         "type": "typedef",
         "definitionType": "i64",
         "identifier": "UserId"
      },
      {
         "type": "struct",
         "identifier": "Bonk",
         "fields": [
            {
               "id": "1",
               "option": null,
               "fieldType": "string",
               "identifier": "message",
               "defaultValue": null
            },
            {
               "id": "2",
               "option": null,
               "fieldType": "i32",
               "identifier": "type",
               "defaultValue": null
            }
         ]
      },
      {
         "type": "exception",
         "identifier": "Xception",
         "fields": [
            {
               "id": "1",
               "option": null,
               "fieldType": "i32",
               "identifier": "errorCode",
               "defaultValue": null
            },
            {
               "id": "2",
               "option": null,
               "fieldType": "string",
               "identifier": "message",
               "defaultValue": null
            }
         ]
      },
      {
         "type": "service",
         "identifier": "ThriftTest",
         "extendIdentifier": null,
         "functions": [
            {
               "type": "function",
               "functionType": "void",
               "identifier": "testVoid",
               "oneway": null,
               "args": [],
               "throws": null
            },
            {
               "type": "function",
               "functionType": "string",
               "identifier": "testString",
               "oneway": null,
               "args": [
                  {
                     "id": "1",
                     "option": null,
                     "fieldType": "string",
                     "identifier": "thing",
                     "defaultValue": null
                  }
               ],
               "throws": [
                  {
                     "id": "1",
                     "option": null,
                     "fieldType": "Xception",
                     "identifier": "e",
                     "defaultValue": null
                  }
               ]
            }
         ]
      }
   ]
}

```
## ChangeLog

[ChangeLog](./CHANGELOG.md)

## License

MIT