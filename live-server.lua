local socket = require("socket")

local HOST = "127.0.0.1"
local PORT = 3000

local server = assert(socket.bind(HOST, PORT))
print("Listening on port:", PORT)

local get_type = function(path)
	local pattern = "%.(%a+)"
	if string.match(path, pattern) == "html" then
		return "text/html"
	elseif string.match(path, pattern) == "css" then
		return "text/css"
	elseif string.match(path, pattern) == "js" then
		return "text/javascript"
	end
end

while true do
	local client, err = server:accept()
	if client then
		print("client exists")
		local data = client:receive()
		print(data)

		local pattern = "GET%s+(/[%a%p]*)"
		local path = string.match(data, pattern)

		print(path)
		if path == "/" then
			path = path .. "index.html"
		end
		path = "." .. path

		local file = io.open(path, "rb")
		local body, status, content_type
		if file then
			body = file:read("a")
			file:close()
			status = "HTTP/1.1 200 OK"
			content_type = get_type(path)
		else
			body = "<h1>404 Not Found</h1>"
			status = "HTTP/1.1 404 Not Found"
			content_type = "text/html"
		end

		local response = status
			.. "\r\n"
			.. "Content-Type: "
			.. content_type
			.. "\r\n"
			.. "Content-Length: "
			.. #body
			.. "\r\n"
			.. "Connection: close\r\n\r\n"
			.. body

		print(response)
		client:send(response)
		client:close()
	else
		print("Failed to accept connection:", err)
	end
end
