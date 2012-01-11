local os = require("os")
local table = require("table")
local string = require("string")

local N = 100000

local gt -- global table to store objs

function doit( n, caption, func1,func2)
   local t1tot, t2tot = 0,0
   local rep = 20
   gt = {}
   for i=1,rep do -- to average JIT work
      local st1 = os.clock()
      for i=1,n do
         func1(i)
      end
      local et1 = os.clock()
      t1tot = t1tot + (et1 - st1)
      local st2 = os.clock()
      for i=1,n do
         func2(i)
      end
      local et2 = os.clock()
      t2tot = t2tot + (et2 - st2)
   end

   local t1sec, t2sec = t1tot/rep, t2tot/rep
   print( string.format( "    %40s creator:%.4f caller:%.4f ( %.1fM create/sec, %.1fM call/sec)", caption, t1sec, t2sec, n/t1sec/1000000, n/t2sec/1000000 ) )
end


-------------------

doit( N*10, "empty loop",
      function(i)
      end,
      function(i)
      end)
-------------------
function fixed_mul_func(x,y,v)
   return x*v, y*v
end
doit( N*10, "fixed mul func (call only)",
      function(i)
      end,
      function(i)
         fixed_mul_func(i,i,i)
      end)

-------------------
doit( N*10, "simple table lookup",
      function(i)
         gt[i] = fixed_mul_func
      end,
      function(i)
         gt[i](i,i,i)
      end)

-------------------

function newVector(x,y)
   local obj = {}
   obj.x = x
   obj.y = y
   obj.mul = function(self,v) return self.x*v, self.y*v end
   return obj
end
doit(N, "init-1-meth-everytime",
     function(i)
        gt[i] = newVector(i,i)
     end,
     function(i)
        gt[i]:mul(i)
     end)
-------------------

function newVector2(x,y)
   local obj = {}
   obj.x = x
   obj.y = y
   obj.mul = function(self,v) return self.x*v, self.y*v end
   obj.mul1 = function(self,v) return self.x*v, self.y*v end
   obj.mul2 = function(self,v) return self.x*v, self.y*v end
   obj.mul3 = function(self,v) return self.x*v, self.y*v end
   obj.mul4 = function(self,v) return self.x*v, self.y*v end
   obj.mul5 = function(self,v) return self.x*v, self.y*v end
   obj.mul6 = function(self,v) return self.x*v, self.y*v end
   obj.mul7 = function(self,v) return self.x*v, self.y*v end
   obj.mul8 = function(self,v) return self.x*v, self.y*v end
   obj.mul9 = function(self,v) return self.x*v, self.y*v end
   return obj
end
doit(N, "init-10-meth-everytime",
     function(i)
        gt[i] = newVector2(i,i)
     end,
     function(i)
        gt[i]:mul9(i,i)
     end)

-------------------
function vec_mul(self,v) return self.x*v, self.y*v end
function newVector3(x,y)
   local obj = {}
   obj.x = x
   obj.y = y
   obj.mul = vec_mul
   return obj
end
doit(N, "init-1-meth-everytime-predef",
      function(i)
         gt[i] = newVector3(i,i)
      end,
      function(i)
         gt[i]:mul(i,i)
      end)

-------------------

function vec_mul1(self,v) return self.x*v, self.y*v end
function vec_mul2(self,v) return self.x*v, self.y*v end
function vec_mul3(self,v) return self.x*v, self.y*v end
function vec_mul4(self,v) return self.x*v, self.y*v end
function vec_mul5(self,v) return self.x*v, self.y*v end
function vec_mul6(self,v) return self.x*v, self.y*v end
function vec_mul7(self,v) return self.x*v, self.y*v end
function vec_mul8(self,v) return self.x*v, self.y*v end
function vec_mul9(self,v) return self.x*v, self.y*v end
function newVector4(x,y)
   local obj = {}
   obj.x = x
   obj.y = y
   obj.mul = vec_mul
   obj.mul1 = vec_mul1
   obj.mul2 = vec_mul2
   obj.mul3 = vec_mul3
   obj.mul4 = vec_mul4
   obj.mul5 = vec_mul5
   obj.mul6 = vec_mul6
   obj.mul7 = vec_mul7
   obj.mul8 = vec_mul8
   obj.mul9 = vec_mul9
   return obj
end
doit(N, "init-10-meth-everytime-predef",
      function(i)
         gt[i] = newVector4(i,i)
      end,
      function(i)
         gt[i]:mul9(i,i)
      end)

-------------------

Vector5 = {}
function Vector5.new(x,y)
   local obj = {}
   obj.x = x
   obj.y = y
   return setmetatable( obj,  {__index = Vector5} )
end

function Vector5.mul(self,v)
   return self.x*v, self.y*v 
end

doit(N, "metatable-1-meth",
      function(i)
         gt[i] = Vector5.new(i,i)
      end,
      function(i)
         gt[i]:mul(i)
      end)
         
-------------------

function Vector5.mul1(self,v) return self.x*v, self.y*v end
function Vector5.mul2(self,v) return self.x*v, self.y*v end
function Vector5.mul3(self,v) return self.x*v, self.y*v end
function Vector5.mul4(self,v) return self.x*v, self.y*v end
function Vector5.mul5(self,v) return self.x*v, self.y*v end
function Vector5.mul6(self,v) return self.x*v, self.y*v end
function Vector5.mul7(self,v) return self.x*v, self.y*v end
function Vector5.mul8(self,v) return self.x*v, self.y*v end
function Vector5.mul9(self,v) return self.x*v, self.y*v end

doit(N, "metatable-10-meth",
      function(i)
         gt[i] = Vector5.new(i,i)
      end,
      function(i)
         gt[i]:mul9(i,i)
      end)



function Vector5.mul10(self,v) return self.x*v, self.y*v end
function Vector5.mul11(self,v) return self.x*v, self.y*v end
function Vector5.mul12(self,v) return self.x*v, self.y*v end
function Vector5.mul13(self,v) return self.x*v, self.y*v end
function Vector5.mul14(self,v) return self.x*v, self.y*v end
function Vector5.mul15(self,v) return self.x*v, self.y*v end
function Vector5.mul16(self,v) return self.x*v, self.y*v end
function Vector5.mul17(self,v) return self.x*v, self.y*v end
function Vector5.mul18(self,v) return self.x*v, self.y*v end
function Vector5.mul19(self,v) return self.x*v, self.y*v end

doit(N, "metatable-20-meth",
      function(i)
         gt[i] = Vector5.new(i,i)
      end,
      function(i)
         gt[i]:mul19(i,i)
      end)




-------------------

function newVector6(x,y)
   local obj = {}
   obj.x = x
   obj.y = y
   obj.mul = function(self,v) return self.x*v, self.y*v end
   obj.mul_notused_dummy_long = function(self,v)
                                   local a,b,c,d,e,f,g,h,i,j,k,l,m,n
                                   print("dummy_long_func",a,b,c,d,e,f,g,h,i,j,k,l,m,n)
                                   print("dummy_long_func",a,b,c,d,e,f,g,h,i,j,k,l,m,n)
                                   print("dummy_long_func",a,b,c,d,e,f,g,h,i,j,k,l,m,n)
                                   print("dummy_long_func",a,b,c,d,e,f,g,h,i,j,k,l,m,n)
                                   print("dummy_long_func",a,b,c,d,e,f,g,h,i,j,k,l,m,n)
                                   print("dummy_long_func",a,b,c,d,e,f,g,h,i,j,k,l,m,n)
                                   print("dummy_long_func",a,b,c,d,e,f,g,h,i,j,k,l,m,n)
                                   print("dummy_long_func",a,b,c,d,e,f,g,h,i,j,k,l,m,n)
                                   print("dummy_long_func",a,b,c,d,e,f,g,h,i,j,k,l,m,n)
                                end
   return obj
end
doit(N, "init-1-meth-everytime-with-dummy",
     function(i)
        gt[i] = newVector6(i,i)
     end,
     function(i)
        gt[i]:mul(i,i)
     end)

-------------------

Vector7 = {}
function Vector7.new(x,y)
   local obj = {x=x,y=y}
   return setmetatable( obj, {__index = Vector7 } )
end
function Vector7.mul(self,v)
   return self.x*v, self.y*v
end

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

doit(N, "metatable-1-meth-5subclass",
     function(i)
        gt[i] = Vector7_4.new(i,i)
     end,
     function(i)
        gt[i]:mul(i)
     end)

-------------------
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

doit(N, "init-1meth-everytime-5subclass",
     function(i)
        gt[i] = newVector8_4(i,i)
     end,
     function(i)
        gt[i]:mul(i)
     end)
