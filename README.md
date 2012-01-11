Speed comparison of Lua OOP
====
Should we always use metatable to implement object oriented lua code?

Conclusion: If you inherit your class many level, metatable can be much slower than simple use of table.

This benchmark compares speed of 2 OOP in Lua,

 - Define constructor functions and pass return value from superclass to subclass.
 - Use metatable 

  
Benchmark Details
====
Please read the source code, it is simple.


Command line:

    luvit bench.lua
    
Out:

luvit bench.lua


                                  empty loop creator:0.0007 caller:0.0007 ( 1408.7M create/sec, 1422.7M call/sec)
                  fixed mul func (call only) creator:0.0007 caller:0.0007 ( 1437.8M create/sec, 1460.9M call/sec)
                         simple table lookup creator:0.0021 caller:0.0016 ( 481.5M create/sec, 612.7M call/sec)
                       init-1-meth-everytime creator:0.0555 caller:0.0030 ( 1.8M create/sec, 33.8M call/sec)
                      init-10-meth-everytime creator:0.2732 caller:0.0088 ( 0.4M create/sec, 11.4M call/sec)
                init-1-meth-everytime-predef creator:0.0492 caller:0.0026 ( 2.0M create/sec, 38.6M call/sec)
               init-10-meth-everytime-predef creator:0.1155 caller:0.0054 ( 0.9M create/sec, 18.6M call/sec)
            init-1-meth-everytime-with-dummy creator:0.0736 caller:0.0035 ( 1.4M create/sec, 28.5M call/sec)
                            metatable-1-meth creator:0.0414 caller:0.0033 ( 2.4M create/sec, 30.0M call/sec)
                           metatable-10-meth creator:0.0430 caller:0.0033 ( 2.3M create/sec, 29.9M call/sec)
                           metatable-20-meth creator:0.0463 caller:0.0034 ( 2.2M create/sec, 29.5M call/sec)
                           
              init-1meth-everytime-5subclass creator:0.0818 caller:0.0045 ( 1.2M create/sec, 22.1M call/sec)                       
                  metatable-1-meth-5subclass creator:0.3676 caller:0.0313 ( 0.3M create/sec, 3.2M call/sec)   


Compare last 2 lines. You can see it is quite slower when 5-level inheritance is done by metatable.

In code,

    function newVector8(x,y)
       local obj = {x=x,y=y}
       obj.mul = function(self,v) return self.x*v, self.y*v end      
       return obj
    end
    function newVector8_1(x,y)
       local obj = newVector8(x,y)
       return obj
    end
    function newVector8_2(x,y)
       local obj = newVector8_1(x,y)
       return obj
    end
    function newVector8_3(x,y)
       local obj = newVector8_2(x,y)
       return obj
    end
    function newVector8_4(x,y)
       local obj = newVector8_3(x,y)
       return obj
    end
    
could be 10x faster than

    Vector7_1 = {}
    setmetatable( Vector7_1, {__index = Vector7})
    function Vector7_1.new(x,y)
       local obj = Vector7.new(x,y)
       return setmetatable( obj, {__index = Vector7_1 } )
    end
    Vector7_2 = {}
    setmetatable( Vector7_2, {__index = Vector7_1})
    function Vector7_2.new(x,y)
       local obj = Vector7_1.new(x,y)
       return setmetatable( obj, {__index = Vector7_2 } )
    end
    Vector7_3 = {}
    setmetatable( Vector7_3, {__index = Vector7_2})
    function Vector7_3.new(x,y)
       local obj = Vector7_2.new(x,y)
       return setmetatable( obj, {__index = Vector7_3 } )
    end
    Vector7_4 = {}
    setmetatable( Vector7_4, {__index = Vector7_3})
    function Vector7_4.new(x,y)
       local obj = Vector7_3.new(x,y)
       return setmetatable( obj, {__index = Vector7_4 } )
    end



