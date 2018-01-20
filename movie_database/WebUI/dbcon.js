var mysql = require('mysql');
var pool = mysql.createPool({
  connectionLimit : 10,
  host            : 'classmysql.engr.oregonstate.edu',
  user            : 'cs340_arnoldke',
  password        : '31HappyCorgi_05',
  database        : 'cs340_arnoldke',
  dateStrings	  : 'date'
});

module.exports.pool = pool;
