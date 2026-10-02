# Sourced by mani tasks that talk to my AYON server.
# If SSL_CERT is given (mani run <task> SSL_CERT=<path to CA bundle>), e.g. for a local self-signed
# ayon-docker behind Caddy, point Python/requests at it. Otherwise does nothing, so any
# SSL_CERT_FILE / REQUESTS_CA_BUNDLE already set in the calling shell is inherited untouched.
if [ -n "$SSL_CERT" ]; then
    export SSL_CERT_FILE="$SSL_CERT"
    export REQUESTS_CA_BUNDLE="$SSL_CERT"
fi
