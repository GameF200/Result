-- @ScriptType: ModuleScript
--!strict
--!optimize 2

-- Result

-- A Rust-inspired Result type for Roblox Luau
-- @author super_sonic
-- @version 1.0.0



export type Result<T, E> = {
	tag: "Ok",
	value: T,
} | {
	tag: "Err",
	error: E,
}

local Result = {}


function Result.Ok<T>(value: T): { tag: "Ok", value: T }
	if value == nil then
		error("Result.Ok() cannot be called with nil value", 2)
	end
	return {
		tag = "Ok",
		value = value,
	}
end

function Result.Err<E>(err: E): { tag: "Err", error: E }
	if err == nil then
		error("Result.Err() cannot be called with nil error", 2)
	end
	return {
		tag = "Err",
		error = err,
	}
end

function Result.is_ok<T, E>(self: Result<T, E>): boolean
	return self.tag == "Ok"
end

function Result.is_err<T, E>(self: Result<T, E>): boolean
	return self.tag == "Err"
end

function Result.unwrap<T, E>(self: Result<T, E>): T
	if self.tag == "Ok" then
		return self.value
	else
		error("Unwrap failed: " .. tostring(self.error), 2)
	end
end

function Result.unwrap_err<T, E>(self: Result<T, E>): E
	if self.tag == "Err" then
		return self.error
	else
		error("Called UnwrapErr on Ok value", 2)
	end
end

function Result.unwrap_or<T, E>(self: Result<T, E>, default: T): T
	if self.tag == "Ok" then
		return self.value
	else
		return default
	end
end

function Result.unwrap_or_function<T, E>(self: Result<T, E>, func: (E) -> T): T
	if self.tag == "Err" then
		return func(self.error)
	else
		return self.value
	end
end

function Result.and_then<T, E, U>(self: Result<T, E>, fn: (T) -> Result<U, E>): Result<U, E>
	if self.tag == "Ok" then
		return fn(self.value)
	else
		return Result.Err(self.error)
	end
end

function Result.try<E>(fn: () -> (any, E?)): Result<any, E>
	local ok, result_or_error = pcall(fn)
	if not ok then
		return Result.Err(result_or_error)
	end
	return Result.Ok(result_or_error)
end


return Result