suppose the eavesdropper cannot modify the data.

our propose: the eavesdropper cannot know anything.

data should be encrypted and the password must be sign by server.

login:
1. client: a client-key encrypted by public key, together with user name/pswd combination
2. server: return a JWT (payload encrypted by server) containing the client-key, encrypted by client-key
3. client: get the right token from the response of server

next communication:
1. client: send information using proper header and encrypts the data with public key, signed by client-key
2. server: verify header using server private key, and verify body using client-key. decode information from body
