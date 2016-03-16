trading = require "trading"

class UTILS

  ## str_repeat : return a string with n occurences of char
  @repeat: (char, n) ->
    out = ''
    while n > 0
      n--
      out = out + char
    out

  debugInc = 0 # initial indentation
  ## debug : dump a string, an object...
  @debug: (obj, maxLevel=9) ->
    debugInc++
    obj_type = typeof obj

    if debugInc > maxLevel
      debugInc--
      return

    if obj_type is 'string' or obj_type is 'number'
      debug(obj)
      debugInc--
      return

    space = @repeat('.', debugInc);

    nbElement = 0
    for own key, val of obj
      nbElement++
      break if nbElement > 10
      obj_type = typeof val
      if obj_type is 'string' or obj_type is 'number'
        debug(space+" "+key+" --> " +val)
      else
        debug "#{space} #{key} --> "
        @debug(val, maxLevel)
    debugInc--

  ## return current capital
  @getCapital: ->
    instrument = data.instruments[0]
    price = instrument.price
    #debug " #{price} at  ##{data.at}"
    #@debug(portfolio.positions)
    curAmount = portfolio.positions[instrument.curr()].amount
    btcAmount = portfolio.positions[instrument.asset()].amount
    capital = curAmount + btcAmount * price

  ## return current efficiency
  @getEfficiency: ->
    efficiency = @getCapital() / context.initial_capital


# Initialization method called before a simulation starts.
# Context object holds script data and will be passed to 'handle' method.
init: ->

  context.tick = 0
  context.min_transaction_amount = 0.01 # in BTC

  #UTILS.debug(context)

  setPlotOptions
    capital:
      secondary : true
      color: 'blue'
    efficiency:
      secondary : true
      color: 'orange'


# This method is called on each tick
handle: ->

  context.tick++

  ###
  portfolio --> 
    positions --> 
      eth --> 
        initial --> 0
        amount --> 0
      xbt --> 
        initial --> 1000
        amount --> 1000
  
  
  DATA
    pair :
      market : kraken
      id : pair
      interval : 5
      open : []
      low : []
      high : []
      close : []
      volumes : []
      ticks : [
        0: 
          at: ts
          open:
          low: 
          high:
          close:
          volume:
      ]
      pair : [ xbt, eur]
    instruments : [
      market:kraken
      id:eth_xbt
      interval:5
      open: []
      low : []
      high : []
      close : []
      volumes : []
      ticks : [
        0: 
          at: ts
          open:
          low: 
          high:
          close:
          volume:
      ]
    ]
    at: ts
    tick: 
      at: ts
      open:
      low: 
      high:
      close:
      volume:

  ###

  ## keep track of initial balance
  context.initial_capital = UTILS.getCapital() if not context.initial_capital

  capital = UTILS.getCapital()
  efficiency = UTILS.getEfficiency() - 1

  ## UI part
  plot
    capital: capital
    efficiency: efficiency



  ## trading logic part
  instrument = data.instruments[0]
  cash = portfolio.positions[instrument.curr()].amount


  if portfolio.positions[instrument.asset()].amount * instrument.price > context.min_transaction_amount
    if trading.sell instrument
      debug 'SELL order traded'


  ## buy ALL
  else if trading.buy instrument, 'limit', cash / instrument.price, instrument.price
    debug 'BUY order traded'


  ## logging part
  #UTILS.debug(data: data)
  #UTILS.debug(portfolio : portfolio)
  #UTILS.debug(instrument : instrument)

  debug "-- Tick ##{context.tick}"+UTILS.repeat('-', 20)


onStop: ->
  debug context.initial_capital
  debug UTILS.getCapital()
  debug "P/L "+UTILS.getEfficiency()
