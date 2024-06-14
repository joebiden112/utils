local Timer = tick();
--// Generator
local SG =  loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/strsplspace/utils/main/Generator.lua'))();

local Functions = {
    --// Paste function here
    ['getprotoclosures'] = function(path) assert(path,'path to script expected'); local r = {}; for i,v in next,debug.getprotos(getscriptclosure(path)) do r[i] = v; end; return r; end;
    ['searchclosureconst'] = function(...) local Constants_for_search = {...} local Function; for _,gc_v in next,getgc(true) do if (type(gc_v) == 'function' and not is_synapse_function(gc_v) and islclosure(gc_v)) then local Entire_fn_consts = debug.getconstants(gc_v); local Continue_ = false; for i,const in next,Constants_for_search do if not table.find(Entire_fn_consts,const) then Continue_ = true;end;end;if Continue_ then continue end;Function = gc_v; break; end; end; SG.Copy(SG.Generate(Constants_for_search)); return Function;end;
    ['searchclosureups'] = function(...) local upvalues = {...} local Function; for i,v in next,getgc(true) do if type(v) == 'function' and islclosure(v) and #getupvalues(v) > 0 then local Func_ups = debug.getupvalues(v); local Continue_ = false; for _,upval in next,upvalues do if not table.find(Func_ups,upval) then Continue_ = true end; end; if Continue_ then continue end; Function = v; break; end; end; SG.Copy(SG.Generate(upvalues,2)); return Function; end;
    ['gcsenv'] = function(path) assert(path,'path to script expected'); assert(typeof(path) == 'Instance','<Instance> LocalScript expected got '..typeof(path)); assert((path):IsA('LocalScript'),'Instance class must be LocalScript got '..path.ClassName); local Script = path; local r = {}; for i,v in next,getgc(true) do if (type(v) == 'function' and islclosure(v) and getfenv(v).script == Script) then r[#r + 1] = v; end; end; return r; end;
};
--// Some addition in functions table for future (prob) synx update
--// Named it getscriptlocals cuz i dont like this name -> "getscriptvars" meh...
if (getthreadfromscript) then
    Functions['getscriptlocals'] = function(path,iterations)
        local getstack = debug.getstack or getstack;
        if (not path:IsA('LocalScript') or not getstack) then return; end;
        local Iterations = iterations or 400;
        local Result = {};
        local Script_thread = getthreadfromscript(path);
        pcall(function()
			for t_value = 1,Iterations do
				local Item = getstack(Script_thread,1,t_value);
				Result[#Result + 1] = Item;
			end;
		end);
        return Result;
    end;
end;
--// Creating global script table
getgenv()['cenv'] = {};
--// Adding functions to a exploit global environment
for FN_NAME,FN in next,Functions do
    getgenv()[FN_NAME] = FN;
end;
--// Adding compatibility function to script table ( cenv )
getgenv()['cenv'].Test = function()
    for FN_NAME,FN in next,Functions do
        if getgenv()[FN_NAME] == FN then
            return true;
        end;
    end;
    return false;
end;
--// Returns function list in console
getgenv()['cenv'].GetFunctions = function()
    printconsole('------ FUNCTIONS LIST ------',0,127,255);
    table.foreach(Functions,function(i,v)
        printconsole(("%s %s"):format(i,tostring(v)),255,182,193);
    end);
    printconsole('------ FUNCTIONS LIST END ------',0,127,255);
end;
--// Finds the needable function and returns it
getgenv()['cenv'].Find = function(function_name)
    assert(type(function_name) == 'string','argument type should be a string');
    for Name,Function in next,Functions do
        if Name:lower():find(function_name:lower()) then
            return Name;
        end;
    end;
end;
--// Responsible for copying in SG.Generate
getgenv()['cenv'].Copy = true;
--// Notify about loading
print(('Custom functions finished loading, took: %.8f'):format(tick() - Timer));
print(('Compatibility test is %s'):format(cenv.Test() and 'succeed' or 'failed'));
