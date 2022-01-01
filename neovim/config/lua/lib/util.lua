local logger = require("lib.logger")

local M = {}

function M.packadd(package)
	local ok, err = pcall(vim.cmd, "packadd " .. package)

	if not ok then
		logger.errorf("Could not add package %q: %s", package, err)
		return
	end

	logger.debugf("Loaded package %q via packadd", package)
end

function M.feature_is_on(feature)
	if feature:is_on() then
		logger.tracef(
			"Feature %q is on, associated variable: %s",
			feature.label,
			feature:get_var_name()
		)
		return true
	end

	logger.infof(
		"Feature %q was not loaded because it was disabled by %s",
		feature.label,
		feature:as_str()
	)
	return false
end

return M
