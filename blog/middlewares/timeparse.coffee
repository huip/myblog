ParseDate = (timestamp)->
  timestamp = new Date timestamp
  getYear: () ->
    return timestamp.getYear() + 1900
  getMonth: (type) ->
    month = timestamp.getMonth()+1
    if not type? 
      return @getYear() + '-' + month
    else
      return @getYear() + '/'+ month
  getDay: (type) ->
     day = timestamp.getDate()
     day = '0' + day if day < 10
     if not type?
       return @getMonth(type) + '-' + day
     else
       return @getMonth(type) +'/'+ day
  getHours: (type)->
     hours = timestamp.getHours()
     hours = '0' + hours if hours < 10
     return @getDay(type) + ' '+ hours
  getMinutes: (type)->
     minutes = timestamp.getMinutes()
     minutes = '0'+minutes if minutes < 10
     return  @getHours(type) + ':' + minutes
  getSeconds: (type)->
     seconds = timestamp.getSeconds()
     seconds = '0' + seconds if seconds < 10
     return @getMinutes(type) + ':' + seconds

module.exports = ParseDate
