import {Range} from "./range"
import * as p from "core/properties"
import {isArray, isNumber, isString} from "core/util/types"

export class FactorRange extends Range
  type: 'FactorRange'

  @define {
    factors: [ p.Array,  [] ]
    start:   [ p.Number     ]
    end:     [ p.Number     ]
  }

  @getters {
    min: () -> @start
    max: () -> @end
  }

  initialize: (attrs, options) ->
    super(attrs, options)
    @_init()
    @connect(@properties.factors.change, () -> @reset())

  reset: () ->
    @_init()
    @change.emit()

  # convert a string factor into a synthetic coordinate
  synthetic: (x) ->
    if not isArray(x)
      x = [x]

    result = 0
    for c, i in x
      if isString(c)
        result += @_mapping[i][c]
      else if isNumber(c)
        if i != (x.length-1)
          throw new Error("")
        result += c
    return result

  # convert string factors into a synthetic coordinates
  v_synthetic: (xs) ->
    result = []
    for x in xs
      result.push(@synthetic(x))
    return result

  _init: () ->
    start = 0
    end = @factors.length
    @setv({start: start, end: end}, {silent: true})
    @_mapping = {}
    @_mapping[0] = {}
    for f, i in @factors
      @_mapping[0][f] = 0.5 + i
