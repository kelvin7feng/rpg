local _class={}

function class(super)
	local class_type={}
	class_type.ctor=false
	class_type.super=super
	class_type.new=function(self, ...)
		local obj={}
		setmetatable(obj,{ __index=_class[class_type] })
		local typeSuper = class_type
		while typeSuper ~= nil do
		    local typeSuperL = typeSuper
		    local objSuper = {}
		    obj[typeSuper] = objSuper
			setmetatable(objSuper, {__index=
				function(t,k)
					local ret=_class[typeSuperL][k]
					if type(ret) == "function" then
					    local func = ret
					    ret = function(self1, ...)
					        return func(obj, ...)
					    end
					    t[k] = ret
                    else
                        ret = nil
					end
					return ret
				end
			})
			typeSuper = typeSuper.super
		end
		do
			local create
			create = function(c,...)
				if c.super then
					create(c.super,...)
				end
				if c.ctor then
					c.ctor(obj,...)
				end
			end
			create(class_type,...)
		end
		return obj
	end

	local vtbl={}
	_class[class_type]=vtbl

	setmetatable(class_type,{__newindex=
		function(t,k,v)
			vtbl[k]=v
		end
	})

	if super then
		setmetatable(vtbl,{__index=
			function(t,k)
				local ret=_class[super][k]
				vtbl[k]=ret
				return ret
			end
		})
	end

	return class_type
end