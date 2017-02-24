require('coffee-script/register');

if (process.env.NODE_ENV === "development")
	require('dotenv').load();

if (!process.env.DEBUG)
  process.env.DEBUG = 'todo:*'

var App = require("./server");
var app = new App();

app.start();
