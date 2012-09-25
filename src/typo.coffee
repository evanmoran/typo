
# typo
# ====================================================================
# The missing javascript type checker. _Mistakes happen_.
#
# ### Usage
#
# #### typo(message, input, interface)
#
#     message              The message thrown if thing doesn't match interface
#     input                A variable to verify it matches the interface
#     spec                 The interface the input must match

typo = (message, input, spec) ->
  console.log 'typo called'

typo.is = (input, spec) ->
  console.log 'typo.is called'

# Version
typo.version = '0.0.1'

# Export
module.exports = typo