Speed comparison on 3 ways of object-oriented programming in Lua
====

We have 3 major way to implement Lua class:

 1. Simply use table, and initialize methods each time
 2. Define named functions and set it in methods on initialization of each instances
 3. Metatable

This benchmark will compare speed of theese 3 ways.

Conclusion first: always use metatable, but for the simplest classes, take it easy to use lambda in your table.

  
Benchmark
====

Command line:

    luvit bench.lua
    
Out:

                                  empty loop creator:0.0008 caller:0.0007 ( 1333.1M create/sec, 1344.8M call/sec)
                  fixed mul func (call only) creator:0.0007 caller:0.0007 ( 1388.2M create/sec, 1415.2M call/sec)
                         simple table lookup creator:0.0022 caller:0.0017 ( 458.2M create/sec, 599.2M call/sec)
                         
                       init-1-meth-everytime creator:0.0567 caller:0.0030 ( 1.8M create/sec, 33.1M call/sec)
                      init-10-meth-everytime creator:0.2852 caller:0.0090 ( 0.4M create/sec, 11.1M call/sec)
            init-1-meth-everytime-with-dummy creator:0.0732 caller:0.0036 ( 1.4M create/sec, 27.7M call/sec)                      
                      
                init-1-meth-everytime-predef creator:0.0514 caller:0.0026 ( 1.9M create/sec, 38.4M call/sec)
               init-10-meth-everytime-predef creator:0.1154 caller:0.0053 ( 0.9M create/sec, 19.0M call/sec)
               
                            metatable-1-meth creator:0.0441 caller:0.0034 ( 2.3M create/sec, 29.0M call/sec)
                           metatable-10-meth creator:0.0477 caller:0.0035 ( 2.1M create/sec, 28.8M call/sec)
                           metatable-20-meth creator:0.0433 caller:0.0034 ( 2.3M create/sec, 29.3M call/sec)
                           


Found
====
 - Adding anonymous function in every instantiation causes heavy GC load to clean up those functions.
   So, if you don't dispose any instances, way1 could be faster.
 - To avoid the GC, you can name member functions, and set it in constructor. It improves, but it still cause heavy GC.
 - Bigger functions causes more frequent GC.
 - By using metatable, GC will not invoked, so always fastest to create objects.