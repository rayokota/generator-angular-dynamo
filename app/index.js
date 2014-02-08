'use strict';
var util = require('util'),
    path = require('path'),
    yeoman = require('yeoman-generator'),
    _ = require('lodash'),
    _s = require('underscore.string'),
    pluralize = require('pluralize'),
    asciify = require('asciify');

var AngularDynamoGenerator = module.exports = function AngularDynamoGenerator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  this.on('end', function () {
    this.installDependencies({ skipInstall: options['skip-install'] });
  });

  this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(AngularDynamoGenerator, yeoman.generators.Base);

AngularDynamoGenerator.prototype.askFor = function askFor() {

  var cb = this.async();

  console.log('\n' +
    '+-+-+-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+\n' +
    '|a|n|g|u|l|a|r| |d|y|n|a|m|o| |g|e|n|e|r|a|t|o|r|\n' +
    '+-+-+-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+\n' +
    '\n');

  var prompts = [{
    type: 'input',
    name: 'baseName',
    message: 'What is the name of your application?',
    default: 'myapp'
  },
  {
    type: 'input',
    name: 'username',
    message: 'What is the PostgreSQL username?',
    default: 'postgres'
  },
  {
    type: 'input',
    name: 'password',
    message: 'What is the PostgreSQL password?',
    default: 'postgres'
  }];

  this.prompt(prompts, function (props) {
    this.baseName = props.baseName;
    this.username = props.username;
    this.password = props.password;

    cb();
  }.bind(this));
};

AngularDynamoGenerator.prototype.app = function app() {

  this.entities = [];
  this.resources = [];
  this.generatorConfig = {
    "baseName": this.baseName,
    "username": this.username,
    "password": this.password,
    "entities": this.entities,
    "resources": this.resources
  };
  this.generatorConfigStr = JSON.stringify(this.generatorConfig, null, '\t');

  this.template('_generator.json', 'generator.json');
  this.template('_package.json', 'package.json');
  this.template('_bower.json', 'bower.json');
  this.template('bowerrc', '.bowerrc');
  this.template('Gruntfile.js', 'Gruntfile.js');
  this.copy('gitignore', '.gitignore');

  var libDir = 'lib/';
  var migrationsDir = 'priv/repo/migrations/';
  var publicDir = 'priv/static/';
  var webDir = 'web/';
  var routersDir = webDir + 'routers/';
  this.mkdir(libDir);
  this.mkdir(migrationsDir);
  this.mkdir(publicDir);
  this.mkdir(webDir);
  this.mkdir(routersDir);
  this.template('_mix.exs', 'mix.exs');
  this.template('lib/_app.ex', libDir + this.baseName + '.ex');
  this.template('web/routers/_application_router.ex', routersDir + 'application_router.ex');

  var publicCssDir = publicDir + 'css/';
  var publicJsDir = publicDir + 'js/';
  var publicViewDir = publicDir + 'views/';
  this.mkdir(publicCssDir);
  this.mkdir(publicJsDir);
  this.mkdir(publicViewDir);
  this.template('public/_index.html', publicDir + 'index.html');
  this.copy('public/css/app.css', publicCssDir + 'app.css');
  this.template('public/js/_app.js', publicJsDir + 'app.js');
  this.template('public/js/home/_home-controller.js', publicJsDir + 'home/home-controller.js');
  this.template('public/views/home/_home.html', publicViewDir + 'home/home.html');
};

AngularDynamoGenerator.prototype.projectfiles = function projectfiles() {
  this.copy('editorconfig', '.editorconfig');
  this.copy('jshintrc', '.jshintrc');
};
