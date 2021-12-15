local Prompt = {}

function Prompt:new(prefix)
	local prompt = {
		prefix = prefix,
	}
	self.__index = self

	return setmetatable(prompt, self)
end

function Prompt:input(msg, ...)
	msg = string.format(msg, ...)
	if self.prefix and #self.prefix > 0 then
		msg = string.format("(%s) %s", self.prefix, msg)
	end

	return vim.fn.input(msg)
end

return Prompt
