###
  Strategy Template
  The script engine is based on CoffeeScript (http://coffeescript.org)
  Any trading algorithm needs to implement two methods:
    init(context) and handle(context,data)
###
class UTILS

  ## str_repeat : return a string with n occurences of char
  @repeat: (char, n) ->
    out = ''
    while n > 0
      n--
      out = out + char
    out

  debugInc = 0 # initial indentation
  @debug: (obj) ->
    return debug(obj) if typeof obj is 'string'

    `console.log(obj)` if debugInc == 0
    debugInc++
    space = @repeat('.', debugInc);

    debug "debug ##{obj}"
    for own key of obj
      debug "#{space} #{key} --> "
      @debug(obj[key])
    debugInc--

  @getCapital: ->
    instrument = data.instruments[0]
    price = instrument.price
    debug " #{price} at  ##{data.at}"
    @debug(portfolio.positions)
    curAmount = portfolio.positions[instrument.curr()].amount
    btcAmount = portfolio.positions[instrument.asset()].amount
    price = instrument.price

    capital = curAmount + btcAmount * price


# Initialization method called before a simulation starts.
# Context object holds script data and will be passed to 'handle' method.
init: (context)->
  # do nothing
  context.balance = 0
  context.limit = 20

  context.initial_capital = UTILS.getCapital()

  setPlotOptions
    capital:
      color: 'green'
    efficiency:
      color: 'orange'

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
  efficiency = context.initial_capital * 100 / capital

  plot
    capital: capital
    efficiency: efficiency

  debug UTILS.repeat('-', 20)

