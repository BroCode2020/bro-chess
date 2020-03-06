base_uri = 'https://bro-chess-b8ed8.firebaseio.com/'

#firebase = Firebase::Client.new(base_uri)

firebase = Firebase::Client.new(base_uri, ENV['private_key_id'])


#response = firebase.push("todos", { :name => 'Pick the milk', :'.priority' => 1 })
# response.success? # => true
# response.code # => 200
# response.body # => { 'name' => "-INOQPH-aV_psbk3ZXEX" }
# response.raw_body # => '{"name":"-INOQPH-aV_psbk3ZXEX"}'