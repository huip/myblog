setting = require "../settings"
exports.index = (req, res) ->
  res.render "index",
    title: setting.title
    brand: setting.brand
    motto: setting.motto
    index: setting.nav.index
    about: setting.nav.about
    login: setting.nav.login
    register: setting.nav.register
   
