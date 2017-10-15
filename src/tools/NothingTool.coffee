{Tool} = require './base'

module.exports = class NothingTool extends Tool

  name: 'NothingTool'
  iconName: 'nothing'
  usesSimpleAPI: false

  didBecomeActive: (lc) ->
    nothingToolUnsubscribeFuncs = []

    @nothingToolUnsubscribe = =>
      for func in nothingToolUnsubscribeFuncs
        func()

    onDown = ({ x, y }) =>
      return

    nothingToolUnsubscribeFuncs.push lc.on 'lc-pointerdown', onDown

  willBecomeInactive: (lc) ->
    @nothingToolUnsubscribe()
