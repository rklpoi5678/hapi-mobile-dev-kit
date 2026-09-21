# Security

This repository must never contain personal provider keys, HAPI access tokens, SSH private keys, or copied `~/.hapi` state.

If a credential is committed accidentally:

1. Rotate/revoke the credential at the provider immediately.
2. Remove it from Git history.
3. Treat any copied HAPI access token as compromised and rotate it.

The default setup uses HAPI's encrypted relay and does not require directly exposing TCP port 3006 to the public internet.
