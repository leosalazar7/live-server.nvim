local HOST = "127.0.0.1"
local PORT = 3000

local create_server = function(host, port, on_connect)
	local server = vim.uv.new_tcp()
	server:bind(host, port)
	server:listen(1024, function(err)
		assert(not err, err)
		local sock = vim.uv.new_tcp()
		server:accept(sock)
		on_connect(sock)
	end)
	return server
end

local server = create_server(HOST, PORT, function(sock)
	sock:read_start(function(err, chunk)
		assert(not err, err)
		if chunk then
			print(chunk)
			local pattern = "GET%s+(/[%a%p]*)"
			local path = string.match(chunk, pattern)

			if path == "/" then
				path = path .. "index.html"
			end

			path = "." .. path
			print(path)

			local file = io.open(path, "rb")
			local body, status, content_type
			if file then
				body = file:read("a")
				status = "HTTP/1.1 200 OK"
				content_type = "text/html"
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

			sock:write(response)
		else
			sock:close()
		end
	end)
end)
print("TCP echo-server listening on port: " .. server:getsockname().port)
