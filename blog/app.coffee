
###
Module dependencies.
###
express = require("express")
index = require("./routes")
ejs = require("ejs")
stylus = require("stylus")
apis = require("./routes/api")
http = require("http")
path = require("path")
ejs.open = "{{"
ejs.close = "}}"
app = express()
# all environments
app.set "port", process.env.PORT or 3000
app.set "views", __dirname + "/views"
app.set "view engine", "ejs"
app.use express.favicon __dirname + "/public/images/favicon.ico"
app.use express.logger("dev")
app.use express.bodyParser()
app.use express.methodOverride()
app.use(express.cookieParser())
app.use(express.session({secret: '1234567890QWERTY'}));
app.use app.router
app.use stylus.middleware path.join __dirname, "public";
app.use express.static(path.join(__dirname, "public"))

# development only
app.use express.errorHandler()  if "development" is app.get("env")
#app.get "/", routes.index
#app.get "/api", api.index
http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
# routes config ./routes
index(app)
apis(app)
