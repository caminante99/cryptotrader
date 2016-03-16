
###
  Strategy Template
  The script engine is based on CoffeeScript (http://coffeescript.org)
  Any trading algorithm needs to implement two methods:
    init(context) and handle(context,data)
###

class UTILS

  ## str_repeat
  @repeat: (char, n) ->
    out = ''
    while n > 0
      n--
      out = out + char
    out

  debugInc = 0
  @debug: (obj) ->
    debugInc++
    space = @repeat('.', debugInc);
    debug "debug ##{obj}"
    for own key of obj
      debug "#{space} #{key} --> "
      val = @debug(obj[key])
    debugInc--


  @getCapital: ->
    instrument = data.instruments[0]
    price = instrument.price
    debug " #{price} at  ##{data.at}"
    @debug(portfolio.positions)
    #curAmount = portfolio.positions[instrument.curr()].amount
    #btcAmount = portfolio.positions[instrument.asset()].amount
    price = instrument.price

#capital = curAmount + btcAmount * price



# Initialization method called before a simulation starts.
# Context object holds script data and will be passed to 'handle' method.
init: (context)->
  # do nothing
  context.balance = 0
  context.limit = 20

  setPlotOptions
    capital:
      color: 'green'

# This method is called on each tick
handle: (context, data, storage)->
  ###
  context - object that holds current script state
  data - allows to access current trading environment
    data.at - current time in milliseconds
    data.portfolio - Portfolio object
  storage - the object is used to persist variable data in the database
  ###



  capital = UTILS.getCapital()

  plot
    capital: capital

  debug UTILS.repeat('-', 20)
