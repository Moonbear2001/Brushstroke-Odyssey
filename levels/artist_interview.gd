extends Control

"""

Currently NOT WORKING. The API is mine (desmonds) and there is no free plan.
Ig I'll leave this here and see if we want to come back to it.

"""

@onready var http_request = $HTTPRequest

var default_req = 'Content-Type: application/json\nAuthorization: Bearer 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\n{
	 "model": "gpt-3.5-turbo",
	 "messages": [{"role": "user", "content": "Say this is a test!"}],
	 "temperature": 0.7
   }'
var default_prompt = "Hello! How are you doing today?"
var api_key = "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"
#var endpoint = "https://api.openai.com/v1/engines/davinci-codex/completions"
var endpoint = "https://api.openai.com/v1/chat/completions"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Connect its completion signal.
	http_request.request_completed.connect(self._http_request_completed)
	
	# Perform a GET request
	#var error = http_request.request("https://httpbin.org/get")
	var error = http_request.request(default_req)	
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	
# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	#print("req completed")
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	#print("here")

	# Print response
	#print(response)
	#print(response.headers["User-Agent"])
