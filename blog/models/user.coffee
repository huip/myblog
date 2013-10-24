mongodb = require "./db"
User = (user)->
  @username = user.username
  @email = user.email
  @password = user.password
module.exports = User
User.prototype.save = (callback)->
  user =
    username : @username
    email : @email
    password : @password
  mongodb.open (err,db)->
    callback err if err
    db.collection "users",(err,collection)->
      if err
        mongodb.close()
        callback err
      collection.ensureIndex "email",{unique:true}
      collection.insert user,{safe:true},(arr,user)->
        mongodb.close()
        callback err,user

User.get = (email,callback)->
  mongodb.open (err,db)->
    callback err if err
    db.collection "users",(err,collection)->
      if err
        mongodb.close()
        callback err
      collection.findOne {email:email},(err,doc)->
        mongodb.close()
        if doc
          user = new User(doc)
          callback err,user
        else
          callback err,null
