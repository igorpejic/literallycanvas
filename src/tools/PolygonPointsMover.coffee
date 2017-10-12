{ToolWithStroke} = require './base'
{createShape} = require '../core/shapes'

module.exports = class PolygonPointsMover extends ToolWithStroke

  name: 'PolygonPointsMover'
  iconName: 'polygon-points-mover'
  usesSimpleAPI: false

  didBecomeActive: (lc) ->
    super(lc)
    polygonPointsMoverUnsubscribeFuncs = []
    @polygonPointsMoverUnsubscribe = =>
      for func in polygonPointsMoverUnsubscribeFuncs
        func()

    @points = null
    @isPressed = false

    onUp = =>
      @isPressed = false
      lc.repaintLayer('main')

    onMove = ({x, y}) =>
      if @isPressed && @shapeIndex? && @pointIndex?
        lc.shapes[@shapeIndex].points[@pointIndex].x = x
        lc.shapes[@shapeIndex].points[@pointIndex].y = y
        lc.repaintLayer('main')

    onDown = ({x, y}) =>
      @shapeIndex = null
      @pointIndex = null
      @isPressed = true
      for shape, shapeIndex in lc.shapes
        for point, pointIndex in shape.points
          if @_getArePointsClose(point, {x, y})
              console.log point, 'point close'
              @shapeIndex = shapeIndex
              @pointIndex = pointIndex

    polygonPointsMoverUnsubscribeFuncs.push lc.on 'lc-pointerdown', onDown
    polygonPointsMoverUnsubscribeFuncs.push lc.on 'lc-pointerdrag', onMove
    polygonPointsMoverUnsubscribeFuncs.push lc.on 'lc-pointermove', onMove
    polygonPointsMoverUnsubscribeFuncs.push lc.on 'lc-pointerup', onUp

  _getArePointsClose: (a, b) ->
    return (Math.abs(a.x - b.x) + Math.abs(a.y - b.y)) < 10
