# Loader
```lua
loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/strsplspace/utils/main/cenv.lua'))();
```
# Usage

## getprotoclosures

```lua
<table> getprotoclosures(<LocalScript>);
```
Returns the protos of LocalScript

## searchclosureconst
```lua
<function> searchclosureconst(<any> Constants);
```
Returns the function that contains ``` Constants ```

Example of usage 

LocalScript contains this code:
```lua
spawn(function()
	spawn(function() --We need to get this function
		print('a');
		warn('b');
	end);
end);
```
Our code:
```lua
local Fn = searchclosureconst('print','a','warn','b');

print(Fn);
```

This function now generates code after using this function,gets copied into clipboard, pseudo code to get function looks like this

```lua
--Code generated by cenv
local Function;
local Consts = {
["1"] = "print",
["2"] = "a",
["3"] = "warn",
["4"] = "b"
};
for i,v in next,getgc(true) do
    if (type(v) == 'function' and islclosure(v) and not is_synapse_function(v)) then
        for i2,v2 in next,Consts do
            if table.find(debug.getconstants(v),v2) then
                Function = v;
            end;
        end;
    end;
end;
```

## searchclosureups
```lua
<function> searchclosureups(<any> Upvalues);
```
Works same as ```searchclosureconst``` but with ```Upvalues```

## gcsenv
```lua
<table> gcsenv(<LocalScript>);
```
Works same as regular ```getsenv``` but uses gc instead,it can be useful if function in table,regular ```getsenv``` dont gonna return that function

## getscriptlocals
### SYNAPSE DONT SUPPORT THIS FUNCTION RIGHT NOW
```lua
<table> getscriptlocals(<LocalScript>,Iterations);
```
Returns the NON Upvalue variables of script,by default iterations = 400

# Cenv

## cenv.Test
```lua
<boolean> cenv.Test(<void>);
```
The compatability function

## cenv.GetFunctions
```lua
cenv.GetFunctions(<void>);
```
Prints all functions in Synapse console, that are supported

## cenv.Find
```lua
<string> cenv.Find(<string> Function name);
```
Returns the name of function if finds it

## cenv.Copy
```lua
cenv.Copy = <boolean>
```
Responsible for copying in SG.Generate,by default its true
# Note
This project can contain bugs,if you find a bug make a pull request.
