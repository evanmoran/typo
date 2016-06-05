
# typo
# ====================================================================
# The missing javascript type checker. _Mistakes happen_.
#
# ### Usage
#
# #### typo(message, input, spec)
#
#     Throws `message` if input does not match spec
#
#     message              The message thrown on a failed match
#     input                The variable to check
#     spec                 The interface input must match
#
# #### typo.check(input, spec)
#
#     Returns `true` if input matches spec
#
#     input                Variable to check of any type
#     spec                 The interface input must match
#
typo = (message, input, spec) ->
  throw message unless typo.check input, spec

typo.check = (input, spec) ->
  function isType(any, type, flagReturnMatch)
  {
        # Private methods:
        function _matchType(value,type)
        {
          # Private methods:
              var _isArray = function(arg)
              {
                if (arg != null && typeof arg == 'object')
                {
                  # Detect by constructor
                  if (typeof(Array) != "undefined" && typeof(arg.constructor) != "undefined" && arg.constructor==Array)
                    return true;
                  # Detect by existance of functions
                  else if (typeof(arg.length)=="number" && typeof(arg.join)=="function" && typeof(arg.sort)=="function" && typeof(arg.reverse)=="function")
                    return true;
                }
                return false;
              }
              var _typeOf = function(any)
              {
                if (any==null)
                  return "null"; # null is sometimes an object
                if (_isArray(any))
                  return "array";
                return typeof(any);
              }
              var _stringTrimWhitespace = function(str)
              {
                return str.replace(/(^\s+|\s+$)/g, "");
              }
          # End Private Mathods
          if (value === undefined)
            value = null;
          var typeOfValue = _typeOf(value);
          var typeOfType = _typeOf(type);

          # If type is string see if it matches value's type
          if (typeOfType == "string")
          {
            var listOfStrings = type.split("||");
            for (var i = 0; i < listOfStrings.length; i++)
            {
              var typeToMatch = _stringTrimWhitespace(listOfStrings[i]);
              # Succeed if type matches
              if (typeToMatch === typeOfValue)
                return {match:true, message:"Type matched"};
            }
            # Fail if type was not found
            return {match:false, message:"Type did not match", value:value, type:type};
          }

          # Otherwise check to see if value is an array or object
          var matchOut = {};
          switch(typeOfValue)
          {
            # Succeed if null so not all levels need to be specified
            case "null":
            #{
            #  matchOut = {match:true, message:"Type matched"};
            #  break;
            #}

            # Fail if type is invalid for defining a type
            case "boolean":     # fall through
            case "number":      # fall through
            case "function":    # fall through
            case "string":      # fall through
            default:
            {
              matchOut = {match:false, message:"Expected type to be string", value:value, type:type};
              break;
            }

            case "object":
            {
              # Compare type at
              if (typeOfType != "object")
                matchOut = {match:false, message:"Expected type to be string or object", value:value, type:type};
              else
              {
                # Default if no values found
                matchOut = {match:true, message:"Type matched"};

                # Recurse for each type
                for (var key in type)
                {
                  var valueChild = value[key];
                  var typeChild = type[key];
                  matchOut = _matchType(valueChild, typeChild);
                  # Fail if subpart didn't match
                  if (matchOut.match != true)
                    return matchOut;
                }
              }
              break;
            }

            case "array":
            {
              if (typeOfType != "array")
                matchOut = {match:false, message:"Expected type to be string or array", value:value, type:type};
              else
              {
                if (value.length != type.length)
                  return {match:false, message:"Expected type to be string or array of length " + value.length, value:value, type:type};

                # Default if no values found
                matchOut = {match:true, message:"Type matched"};

                # Combine strings recursively
                for (var i = 0; i < type.length; ++i)
                {
                  matchOut = _matchType(value[i], type[i]);
                  if (matchOut.match != true)
                    return matchOut;
                }
              }

              break;
            }

          } # end switch
          return matchOut;
        }

    var match = _matchType(any, type);
    if (flagReturnMatch)
      return match;
    return match.match;
  }

###
# Version
typo.version = '0.0.2'

# Export
module.exports = typo
